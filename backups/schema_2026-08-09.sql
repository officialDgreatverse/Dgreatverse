


SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_cron" WITH SCHEMA "pg_catalog";






COMMENT ON SCHEMA "public" IS 'standard public schema';



CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "public";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE OR REPLACE FUNCTION "public"."activate_vip"("p_user_id" "uuid", "p_plan" "text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  v_interval interval;
begin
  v_interval := case p_plan when 'yearly' then interval '1 year' else interval '1 month' end;
  update users
  set is_vip = true,
      vip_plan = p_plan,
      vip_expires_at = greatest(coalesce(vip_expires_at, now()), now()) + v_interval
  where id = p_user_id;
end;
$$;


ALTER FUNCTION "public"."activate_vip"("p_user_id" "uuid", "p_plan" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."can_create_channel"("p_user_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  v_count int;
  v_is_vip boolean;
begin
  select count(*) into v_count from channels where owner_id = p_user_id;
  select coalesce(is_vip, false) into v_is_vip from users where id = p_user_id;

  if v_is_vip then
    return true; -- no cap for VIP, change to `return v_count < N` if you want one
  end if;

  return v_count < 2;
end;
$$;


ALTER FUNCTION "public"."can_create_channel"("p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."channel_comment_count_sync"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if TG_OP = 'INSERT' then
    update channel_posts set comment_count = comment_count + 1 where id = new.post_id;
  elsif TG_OP = 'DELETE' then
    update channel_posts set comment_count = greatest(comment_count - 1, 0) where id = old.post_id;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."channel_comment_count_sync"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."channel_follow_count_sync"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if TG_OP = 'INSERT' then
    update channels set follower_count = follower_count + 1 where id = new.channel_id;
  elsif TG_OP = 'DELETE' then
    update channels set follower_count = greatest(follower_count - 1, 0) where id = old.channel_id;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."channel_follow_count_sync"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."channel_like_count_sync"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if TG_OP = 'INSERT' then
    update channel_posts set like_count = like_count + 1 where id = new.post_id;
  elsif TG_OP = 'DELETE' then
    update channel_posts set like_count = greatest(like_count - 1, 0) where id = old.post_id;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."channel_like_count_sync"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."channel_post_count_sync"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if TG_OP = 'INSERT' then
    update channels set post_count = post_count + 1 where id = new.channel_id;
  elsif TG_OP = 'DELETE' then
    update channels set post_count = greatest(post_count - 1, 0) where id = old.channel_id;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."channel_post_count_sync"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."channel_tip_apply"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  update channel_posts set tip_total_dg = tip_total_dg + new.amount_dg where id = new.post_id;

  update users set wallet_balance_dg = wallet_balance_dg - new.amount_dg where id = new.from_user_id;
  update users set wallet_balance_dg = wallet_balance_dg + (new.amount_dg - new.platform_cut_dg) where id = new.to_user_id;

  return new;
end;
$$;


ALTER FUNCTION "public"."channel_tip_apply"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."complete_topup"("p_payment_reference" "text") RETURNS "void"
    LANGUAGE "plpgsql" SECURITY DEFINER
    AS $$
declare
  v_user_id uuid;
  v_amount_dg integer;
  v_status text;
begin
  -- Lock the topup row so two webhook retries can't double-credit.
  select user_id, amount_dg, status
    into v_user_id, v_amount_dg, v_status
  from topups
  where payment_reference = p_payment_reference
  for update;

  if not found then
    raise exception 'No topup found for reference %', p_payment_reference;
  end if;

  if v_status = 'completed' then
    -- Already processed (webhook retried) — do nothing, no error.
    return;
  end if;

  update topups
    set status = 'completed'
  where payment_reference = p_payment_reference;

  update wallets
    set balance = balance + v_amount_dg,
        updated_at = now()
  where user_id = v_user_id;
end;
$$;


ALTER FUNCTION "public"."complete_topup"("p_payment_reference" "text") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."create_wallet_for_new_user"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
                                        begin
                                          insert into wallets (user_id, balance) values (new.id, 0)
                                            on conflict (user_id) do nothing;
                                              return new;
                                              end;
                                              $$;


ALTER FUNCTION "public"."create_wallet_for_new_user"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_channel_follow_count"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if (tg_op = 'INSERT') then
    update channels
      set follower_count = coalesce(follower_count, 0) + 1
      where id = new.channel_id;
    return new;
  elsif (tg_op = 'DELETE') then
    update channels
      set follower_count = greatest(coalesce(follower_count, 0) - 1, 0)
      where id = old.channel_id;
    return old;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."handle_channel_follow_count"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_channel_post_comment_count"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if (tg_op = 'INSERT') then
    update channel_posts
      set comment_count = coalesce(comment_count, 0) + 1
      where id = new.post_id;
    return new;
  elsif (tg_op = 'DELETE') then
    update channel_posts
      set comment_count = greatest(coalesce(comment_count, 0) - 1, 0)
      where id = old.post_id;
    return old;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."handle_channel_post_comment_count"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."handle_channel_post_like_count"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
begin
  if (tg_op = 'INSERT') then
    update channel_posts
      set like_count = coalesce(like_count, 0) + 1
      where id = new.post_id;
    return new;
  elsif (tg_op = 'DELETE') then
    update channel_posts
      set like_count = greatest(coalesce(like_count, 0) - 1, 0)
      where id = old.post_id;
    return old;
  end if;
  return null;
end;
$$;


ALTER FUNCTION "public"."handle_channel_post_like_count"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_group_admin"("p_group_id" "uuid", "p_user_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.group_members
    where group_id = p_group_id and user_id = p_user_id and is_admin = true
  );
$$;


ALTER FUNCTION "public"."is_group_admin"("p_group_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."is_group_member"("p_group_id" "uuid", "p_user_id" "uuid") RETURNS boolean
    LANGUAGE "sql" STABLE SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
  select exists (
    select 1 from public.group_members
    where group_id = p_group_id and user_id = p_user_id
  );
$$;


ALTER FUNCTION "public"."is_group_member"("p_group_id" "uuid", "p_user_id" "uuid") OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_community_verification"() RETURNS "trigger"
    LANGUAGE "plpgsql"
    AS $$
begin
  if new.is_vip is distinct from old.is_vip then
    update communities
    set is_verified = new.is_vip
    where created_by = new.id;
  end if;
  return new;
end;
$$;


ALTER FUNCTION "public"."sync_community_verification"() OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE TABLE IF NOT EXISTS "public"."app_info" (
    "id" integer DEFAULT 1 NOT NULL,
    "creator_name" "text",
    "email" "text",
    "tiktok" "text",
    CONSTRAINT "single_row" CHECK (("id" = 1))
);


ALTER TABLE "public"."app_info" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."app_settings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "key" "text" NOT NULL,
    "value" "text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."app_settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channel_follows" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "channel_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."channel_follows" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channel_post_comments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "post_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "body" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."channel_post_comments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channel_post_likes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "post_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."channel_post_likes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channel_post_tips" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "post_id" "uuid" NOT NULL,
    "from_user_id" "uuid" NOT NULL,
    "to_user_id" "uuid" NOT NULL,
    "amount_dg" integer NOT NULL,
    "platform_cut_dg" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "channel_post_tips_amount_dg_check" CHECK (("amount_dg" > 0))
);


ALTER TABLE "public"."channel_post_tips" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channel_posts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "channel_id" "uuid" NOT NULL,
    "caption" "text",
    "media_url" "text",
    "media_public_id" "text",
    "media_type" "text",
    "like_count" integer DEFAULT 0 NOT NULL,
    "comment_count" integer DEFAULT 0 NOT NULL,
    "tip_total_dg" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "channel_posts_media_type_check" CHECK (("media_type" = ANY (ARRAY['image'::"text", 'video'::"text"])))
);


ALTER TABLE "public"."channel_posts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channel_subscriptions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "channel_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "status" "text" DEFAULT 'active'::"text" NOT NULL,
    "expires_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    CONSTRAINT "channel_subscriptions_status_check" CHECK (("status" = ANY (ARRAY['active'::"text", 'cancelled'::"text", 'expired'::"text"])))
);


ALTER TABLE "public"."channel_subscriptions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."channels" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "handle" "text",
    "about" "text",
    "avatar_url" "text",
    "avatar_public_id" "text",
    "banner_url" "text",
    "banner_public_id" "text",
    "is_gated" boolean DEFAULT false NOT NULL,
    "price_usd" numeric(10,2),
    "price_ngn" numeric(10,2),
    "follower_count" integer DEFAULT 0 NOT NULL,
    "post_count" integer DEFAULT 0 NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."channels" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."chat_requests" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "from_user" "uuid" NOT NULL,
    "to_user" "uuid" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."chat_requests" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."comments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "message_id" "uuid",
    "group_message_id" "uuid",
    "user_id" "uuid" NOT NULL,
    "content" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."comments" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."communities" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "about" "text",
    "avatar_url" "text",
    "avatar_public_id" "text",
    "created_by" "uuid",
    "invite_code" "text",
    "invite_enabled" boolean DEFAULT true NOT NULL,
    "is_verified" boolean DEFAULT false NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."communities" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."contact_settings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" NOT NULL,
    "contact_id" "uuid" NOT NULL,
    "archived" boolean DEFAULT false,
    "hidden" boolean DEFAULT false,
    "hide_pin" "text",
    "blocked" boolean DEFAULT false,
    "disappear_seconds" integer DEFAULT 0,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "updated_at" timestamp with time zone DEFAULT "now"(),
    "cleared_before" timestamp with time zone
);


ALTER TABLE "public"."contact_settings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."contacts" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "contact_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."contacts" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_invites" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "group_id" "uuid" NOT NULL,
    "status" "text" DEFAULT 'pending'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "from_user" "uuid",
    "to_user" "uuid"
);


ALTER TABLE "public"."group_invites" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_members" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "group_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "joined_at" timestamp with time zone DEFAULT "now"(),
    "is_admin" boolean DEFAULT false
);


ALTER TABLE "public"."group_members" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "group_id" "uuid" NOT NULL,
    "sender_id" "uuid" NOT NULL,
    "content" "text",
    "file_url" "text",
    "file_type" "text",
    "reply_to_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "public_id" "text",
    "expiry_warned" boolean DEFAULT false
);


ALTER TABLE "public"."group_messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_poll_votes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "poll_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "option_index" integer NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."group_poll_votes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_polls" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "group_id" "uuid" NOT NULL,
    "sender_id" "uuid" NOT NULL,
    "question" "text" NOT NULL,
    "options" "jsonb" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."group_polls" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."group_reads" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "group_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "last_read_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."group_reads" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."groups" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "avatar_url" "text",
    "created_by" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "about" "text",
    "msg_permission" "text" DEFAULT 'everyone'::"text",
    "invite_code" "text",
    "invite_enabled" boolean DEFAULT true,
    "avatar_public_id" "text",
    "community_id" "uuid"
);


ALTER TABLE "public"."groups" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."hidden_messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" NOT NULL,
    "message_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."hidden_messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."likes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "message_id" "uuid",
    "group_message_id" "uuid",
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "emoji" "text" DEFAULT '👍'::"text" NOT NULL
);


ALTER TABLE "public"."likes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."media_expiry_warnings" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "message_id" "uuid",
    "group_message_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."media_expiry_warnings" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."messages" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sender_id" "uuid" NOT NULL,
    "receiver_id" "uuid" NOT NULL,
    "content" "text",
    "file_url" "text",
    "file_type" "text",
    "reply_to_id" "uuid",
    "read_at" timestamp with time zone,
    "created_at" timestamp with time zone DEFAULT "now"(),
    "public_id" "text",
    "expiry_warned" boolean DEFAULT false,
    "expires_at" timestamp with time zone
);


ALTER TABLE "public"."messages" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."private_reads" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "contact_id" "uuid" NOT NULL,
    "last_read_at" timestamp with time zone DEFAULT "now"() NOT NULL
);


ALTER TABLE "public"."private_reads" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."push_subscriptions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "endpoint" "text" NOT NULL,
    "p256dh" "text" NOT NULL,
    "auth" "text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."push_subscriptions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."status_exclusions" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "owner_id" "uuid" NOT NULL,
    "excluded_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."status_exclusions" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."stories" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid" NOT NULL,
    "media_url" "text",
    "media_type" "text",
    "caption" "text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "expires_at" timestamp with time zone DEFAULT ("now"() + '24:00:00'::interval),
    "public_id" "text"
);


ALTER TABLE "public"."stories" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."story_likes" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "story_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."story_likes" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."story_views" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "story_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."story_views" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."tips" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "sender_id" "uuid",
    "receiver_id" "uuid",
    "amount_dg" integer NOT NULL,
    "platform_fee_dg" integer DEFAULT 0 NOT NULL,
    "story_id" "uuid",
    "message_id" "uuid",
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."tips" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."topups" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "user_id" "uuid",
    "amount_dg" integer NOT NULL,
    "currency" "text" NOT NULL,
    "amount_paid" numeric NOT NULL,
    "payment_provider" "text" NOT NULL,
    "payment_reference" "text",
    "status" "text" DEFAULT 'pending'::"text" NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."topups" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "name" "text" NOT NULL,
    "email" "text",
    "chat_code" "text",
    "avatar_url" "text",
    "about" "text" DEFAULT 'Hey there! I am using DgreatVerse.'::"text",
    "created_at" timestamp with time zone DEFAULT "now"(),
    "avatar_public_id" "text",
    "is_vip" boolean DEFAULT false NOT NULL,
    "vip_plan" "text",
    "vip_expires_at" timestamp with time zone,
    CONSTRAINT "users_vip_plan_check" CHECK (("vip_plan" = ANY (ARRAY['monthly'::"text", 'yearly'::"text"])))
);


ALTER TABLE "public"."users" OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."wallets" (
    "user_id" "uuid" NOT NULL,
    "balance" integer DEFAULT 0 NOT NULL,
    "updated_at" timestamp with time zone DEFAULT "now"()
);


ALTER TABLE "public"."wallets" OWNER TO "postgres";


ALTER TABLE ONLY "public"."app_info"
    ADD CONSTRAINT "app_info_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."app_settings"
    ADD CONSTRAINT "app_settings_key_key" UNIQUE ("key");



ALTER TABLE ONLY "public"."app_settings"
    ADD CONSTRAINT "app_settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channel_follows"
    ADD CONSTRAINT "channel_follows_channel_id_user_id_key" UNIQUE ("channel_id", "user_id");



ALTER TABLE ONLY "public"."channel_follows"
    ADD CONSTRAINT "channel_follows_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channel_post_comments"
    ADD CONSTRAINT "channel_post_comments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channel_post_likes"
    ADD CONSTRAINT "channel_post_likes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channel_post_likes"
    ADD CONSTRAINT "channel_post_likes_post_id_user_id_key" UNIQUE ("post_id", "user_id");



ALTER TABLE ONLY "public"."channel_post_tips"
    ADD CONSTRAINT "channel_post_tips_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channel_posts"
    ADD CONSTRAINT "channel_posts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channel_subscriptions"
    ADD CONSTRAINT "channel_subscriptions_channel_id_user_id_key" UNIQUE ("channel_id", "user_id");



ALTER TABLE ONLY "public"."channel_subscriptions"
    ADD CONSTRAINT "channel_subscriptions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."channels"
    ADD CONSTRAINT "channels_handle_key" UNIQUE ("handle");



ALTER TABLE ONLY "public"."channels"
    ADD CONSTRAINT "channels_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."chat_requests"
    ADD CONSTRAINT "chat_requests_from_user_to_user_key" UNIQUE ("from_user", "to_user");



ALTER TABLE ONLY "public"."chat_requests"
    ADD CONSTRAINT "chat_requests_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_invite_code_key" UNIQUE ("invite_code");



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contact_settings"
    ADD CONSTRAINT "contact_settings_owner_id_contact_id_key" UNIQUE ("owner_id", "contact_id");



ALTER TABLE ONLY "public"."contact_settings"
    ADD CONSTRAINT "contact_settings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_user_id_contact_id_key" UNIQUE ("user_id", "contact_id");



ALTER TABLE ONLY "public"."group_invites"
    ADD CONSTRAINT "group_invites_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_group_id_user_id_key" UNIQUE ("group_id", "user_id");



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."group_messages"
    ADD CONSTRAINT "group_messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."group_poll_votes"
    ADD CONSTRAINT "group_poll_votes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."group_poll_votes"
    ADD CONSTRAINT "group_poll_votes_poll_id_user_id_key" UNIQUE ("poll_id", "user_id");



ALTER TABLE ONLY "public"."group_polls"
    ADD CONSTRAINT "group_polls_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."group_reads"
    ADD CONSTRAINT "group_reads_group_id_user_id_key" UNIQUE ("group_id", "user_id");



ALTER TABLE ONLY "public"."group_reads"
    ADD CONSTRAINT "group_reads_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."hidden_messages"
    ADD CONSTRAINT "hidden_messages_owner_id_message_id_key" UNIQUE ("owner_id", "message_id");



ALTER TABLE ONLY "public"."hidden_messages"
    ADD CONSTRAINT "hidden_messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."media_expiry_warnings"
    ADD CONSTRAINT "media_expiry_warnings_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."private_reads"
    ADD CONSTRAINT "private_reads_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."private_reads"
    ADD CONSTRAINT "private_reads_user_id_contact_id_key" UNIQUE ("user_id", "contact_id");



ALTER TABLE ONLY "public"."push_subscriptions"
    ADD CONSTRAINT "push_subscriptions_endpoint_key" UNIQUE ("endpoint");



ALTER TABLE ONLY "public"."push_subscriptions"
    ADD CONSTRAINT "push_subscriptions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."status_exclusions"
    ADD CONSTRAINT "status_exclusions_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."status_exclusions"
    ADD CONSTRAINT "status_exclusions_user_id_excluded_user_id_key" UNIQUE ("owner_id", "excluded_id");



ALTER TABLE ONLY "public"."stories"
    ADD CONSTRAINT "stories_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."story_likes"
    ADD CONSTRAINT "story_likes_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."story_likes"
    ADD CONSTRAINT "story_likes_story_id_user_id_key" UNIQUE ("story_id", "user_id");



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_story_id_user_id_key" UNIQUE ("story_id", "user_id");



ALTER TABLE ONLY "public"."tips"
    ADD CONSTRAINT "tips_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."topups"
    ADD CONSTRAINT "topups_payment_reference_key" UNIQUE ("payment_reference");



ALTER TABLE ONLY "public"."topups"
    ADD CONSTRAINT "topups_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_chat_code_key" UNIQUE ("chat_code");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."wallets"
    ADD CONSTRAINT "wallets_pkey" PRIMARY KEY ("user_id");



CREATE INDEX "idx_channel_comments_post" ON "public"."channel_post_comments" USING "btree" ("post_id", "created_at");



CREATE INDEX "idx_channel_follows_channel" ON "public"."channel_follows" USING "btree" ("channel_id");



CREATE INDEX "idx_channel_follows_user" ON "public"."channel_follows" USING "btree" ("user_id");



CREATE INDEX "idx_channel_posts_channel" ON "public"."channel_posts" USING "btree" ("channel_id", "created_at" DESC);



CREATE INDEX "idx_channel_subs_channel" ON "public"."channel_subscriptions" USING "btree" ("channel_id");



CREATE INDEX "idx_channel_subs_user" ON "public"."channel_subscriptions" USING "btree" ("user_id");



CREATE INDEX "idx_channel_tips_owner" ON "public"."channel_post_tips" USING "btree" ("to_user_id");



CREATE INDEX "idx_channel_tips_post" ON "public"."channel_post_tips" USING "btree" ("post_id");



CREATE INDEX "idx_channels_owner" ON "public"."channels" USING "btree" ("owner_id");



CREATE INDEX "idx_groups_community_id" ON "public"."groups" USING "btree" ("community_id");



CREATE INDEX "private_reads_lookup" ON "public"."private_reads" USING "btree" ("user_id", "contact_id");



CREATE OR REPLACE TRIGGER "send_notification_on_new_group_message" AFTER INSERT ON "public"."group_messages" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://azmbhcyoubsnvxiyvdro.supabase.co/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF6bWJoY3lvdWJzbnZ4aXl2ZHJvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MzE0ODEwMCwiZXhwIjoyMDk4NzI0MTAwfQ.5IWx8v2aqgwghSZhl9-_OGYUHOB3QwaOzQ4iF2-b0pE","x-webhook-secret":"dg7x9k2m4p8w1q5z9tr3"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "send_notification_on_new_message" AFTER INSERT ON "public"."messages" FOR EACH ROW EXECUTE FUNCTION "supabase_functions"."http_request"('https://azmbhcyoubsnvxiyvdro.supabase.co/functions/v1/send-notification', 'POST', '{"Content-type":"application/json","Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImF6bWJoY3lvdWJzbnZ4aXl2ZHJvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc4MzE0ODEwMCwiZXhwIjoyMDk4NzI0MTAwfQ.5IWx8v2aqgwghSZhl9-_OGYUHOB3QwaOzQ4iF2-b0pE","x-webhook-secret":"dg7x9k2m4p8w1q5z9tr3"}', '{}', '5000');



CREATE OR REPLACE TRIGGER "trg_channel_comment_count" AFTER INSERT OR DELETE ON "public"."channel_post_comments" FOR EACH ROW EXECUTE FUNCTION "public"."channel_comment_count_sync"();



CREATE OR REPLACE TRIGGER "trg_channel_follow_count" AFTER INSERT OR DELETE ON "public"."channel_follows" FOR EACH ROW EXECUTE FUNCTION "public"."handle_channel_follow_count"();



CREATE OR REPLACE TRIGGER "trg_channel_like_count" AFTER INSERT OR DELETE ON "public"."channel_post_likes" FOR EACH ROW EXECUTE FUNCTION "public"."channel_like_count_sync"();



CREATE OR REPLACE TRIGGER "trg_channel_post_comment_count" AFTER INSERT OR DELETE ON "public"."channel_post_comments" FOR EACH ROW EXECUTE FUNCTION "public"."handle_channel_post_comment_count"();



CREATE OR REPLACE TRIGGER "trg_channel_post_count" AFTER INSERT OR DELETE ON "public"."channel_posts" FOR EACH ROW EXECUTE FUNCTION "public"."channel_post_count_sync"();



CREATE OR REPLACE TRIGGER "trg_channel_post_like_count" AFTER INSERT OR DELETE ON "public"."channel_post_likes" FOR EACH ROW EXECUTE FUNCTION "public"."handle_channel_post_like_count"();



CREATE OR REPLACE TRIGGER "trg_channel_tip_apply" AFTER INSERT ON "public"."channel_post_tips" FOR EACH ROW EXECUTE FUNCTION "public"."channel_tip_apply"();



CREATE OR REPLACE TRIGGER "trg_create_wallet" AFTER INSERT ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."create_wallet_for_new_user"();



CREATE OR REPLACE TRIGGER "trg_sync_community_verification" AFTER UPDATE OF "is_vip" ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "public"."sync_community_verification"();



ALTER TABLE ONLY "public"."channel_follows"
    ADD CONSTRAINT "channel_follows_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "public"."channels"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_follows"
    ADD CONSTRAINT "channel_follows_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_post_comments"
    ADD CONSTRAINT "channel_post_comments_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."channel_posts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_post_comments"
    ADD CONSTRAINT "channel_post_comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_post_likes"
    ADD CONSTRAINT "channel_post_likes_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."channel_posts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_post_likes"
    ADD CONSTRAINT "channel_post_likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_post_tips"
    ADD CONSTRAINT "channel_post_tips_from_user_id_fkey" FOREIGN KEY ("from_user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."channel_post_tips"
    ADD CONSTRAINT "channel_post_tips_post_id_fkey" FOREIGN KEY ("post_id") REFERENCES "public"."channel_posts"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_post_tips"
    ADD CONSTRAINT "channel_post_tips_to_user_id_fkey" FOREIGN KEY ("to_user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."channel_posts"
    ADD CONSTRAINT "channel_posts_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "public"."channels"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_subscriptions"
    ADD CONSTRAINT "channel_subscriptions_channel_id_fkey" FOREIGN KEY ("channel_id") REFERENCES "public"."channels"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channel_subscriptions"
    ADD CONSTRAINT "channel_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."channels"
    ADD CONSTRAINT "channels_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chat_requests"
    ADD CONSTRAINT "chat_requests_from_user_fkey" FOREIGN KEY ("from_user") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."chat_requests"
    ADD CONSTRAINT "chat_requests_to_user_fkey" FOREIGN KEY ("to_user") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_group_message_id_fkey" FOREIGN KEY ("group_message_id") REFERENCES "public"."group_messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."comments"
    ADD CONSTRAINT "comments_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."communities"
    ADD CONSTRAINT "communities_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."contact_settings"
    ADD CONSTRAINT "contact_settings_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."contact_settings"
    ADD CONSTRAINT "contact_settings_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."contacts"
    ADD CONSTRAINT "contacts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_invites"
    ADD CONSTRAINT "group_invites_from_user_fkey" FOREIGN KEY ("from_user") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_invites"
    ADD CONSTRAINT "group_invites_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_invites"
    ADD CONSTRAINT "group_invites_to_user_fkey" FOREIGN KEY ("to_user") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_members"
    ADD CONSTRAINT "group_members_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_messages"
    ADD CONSTRAINT "group_messages_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_messages"
    ADD CONSTRAINT "group_messages_reply_to_id_fkey" FOREIGN KEY ("reply_to_id") REFERENCES "public"."group_messages"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."group_messages"
    ADD CONSTRAINT "group_messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_poll_votes"
    ADD CONSTRAINT "group_poll_votes_poll_id_fkey" FOREIGN KEY ("poll_id") REFERENCES "public"."group_polls"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_poll_votes"
    ADD CONSTRAINT "group_poll_votes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_polls"
    ADD CONSTRAINT "group_polls_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_polls"
    ADD CONSTRAINT "group_polls_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_reads"
    ADD CONSTRAINT "group_reads_group_id_fkey" FOREIGN KEY ("group_id") REFERENCES "public"."groups"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."group_reads"
    ADD CONSTRAINT "group_reads_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_community_id_fkey" FOREIGN KEY ("community_id") REFERENCES "public"."communities"("id");



ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_owner_id_fkey" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."hidden_messages"
    ADD CONSTRAINT "hidden_messages_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."hidden_messages"
    ADD CONSTRAINT "hidden_messages_owner_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_group_message_id_fkey" FOREIGN KEY ("group_message_id") REFERENCES "public"."group_messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."likes"
    ADD CONSTRAINT "likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."media_expiry_warnings"
    ADD CONSTRAINT "media_expiry_warnings_group_message_id_fkey" FOREIGN KEY ("group_message_id") REFERENCES "public"."group_messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."media_expiry_warnings"
    ADD CONSTRAINT "media_expiry_warnings_message_id_fkey" FOREIGN KEY ("message_id") REFERENCES "public"."messages"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."media_expiry_warnings"
    ADD CONSTRAINT "media_expiry_warnings_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_reply_to_id_fkey" FOREIGN KEY ("reply_to_id") REFERENCES "public"."messages"("id") ON DELETE SET NULL;



ALTER TABLE ONLY "public"."messages"
    ADD CONSTRAINT "messages_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."private_reads"
    ADD CONSTRAINT "private_reads_contact_id_fkey" FOREIGN KEY ("contact_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."private_reads"
    ADD CONSTRAINT "private_reads_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."push_subscriptions"
    ADD CONSTRAINT "push_subscriptions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."status_exclusions"
    ADD CONSTRAINT "status_exclusions_excluded_user_id_fkey" FOREIGN KEY ("excluded_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."status_exclusions"
    ADD CONSTRAINT "status_exclusions_user_id_fkey" FOREIGN KEY ("owner_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."stories"
    ADD CONSTRAINT "stories_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."story_likes"
    ADD CONSTRAINT "story_likes_story_id_fkey" FOREIGN KEY ("story_id") REFERENCES "public"."stories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."story_likes"
    ADD CONSTRAINT "story_likes_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_story_id_fkey" FOREIGN KEY ("story_id") REFERENCES "public"."stories"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."story_views"
    ADD CONSTRAINT "story_views_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."tips"
    ADD CONSTRAINT "tips_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."tips"
    ADD CONSTRAINT "tips_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."topups"
    ADD CONSTRAINT "topups_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE ONLY "public"."wallets"
    ADD CONSTRAINT "wallets_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



CREATE POLICY "Admins can update member roles" ON "public"."group_members" FOR UPDATE TO "authenticated" USING (true) WITH CHECK (true);



CREATE POLICY "Anyone can read app settings" ON "public"."app_settings" FOR SELECT USING (true);



CREATE POLICY "Anyone can read app_info" ON "public"."app_info" FOR SELECT TO "authenticated", "anon" USING (true);



CREATE POLICY "Anyone can read comments" ON "public"."comments" FOR SELECT USING (true);



CREATE POLICY "Anyone can read group members" ON "public"."group_members" FOR SELECT USING (true);



CREATE POLICY "Anyone can read group polls" ON "public"."group_polls" FOR SELECT USING (true);



CREATE POLICY "Anyone can read groups" ON "public"."groups" FOR SELECT USING (true);



CREATE POLICY "Anyone can read likes" ON "public"."likes" FOR SELECT USING (true);



CREATE POLICY "Anyone can read poll votes" ON "public"."group_poll_votes" FOR SELECT USING (true);



CREATE POLICY "Anyone can read stories" ON "public"."stories" FOR SELECT USING (true);



CREATE POLICY "Anyone can read story likes" ON "public"."story_likes" FOR SELECT USING (true);



CREATE POLICY "Anyone can read story views" ON "public"."story_views" FOR SELECT USING (true);



CREATE POLICY "Communities are viewable by everyone" ON "public"."communities" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Group members can read messages" ON "public"."group_messages" FOR SELECT USING (true);



CREATE POLICY "Members can insert their own votes" ON "public"."group_poll_votes" FOR INSERT TO "authenticated" WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Members can read group_members" ON "public"."group_members" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Members can read votes" ON "public"."group_poll_votes" FOR SELECT TO "authenticated" USING (true);



CREATE POLICY "Members can update their own votes" ON "public"."group_poll_votes" FOR UPDATE TO "authenticated" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Owner can delete group" ON "public"."groups" FOR DELETE USING (("auth"."uid"() = "created_by"));



CREATE POLICY "Owner can update and delete group" ON "public"."groups" FOR UPDATE USING (("auth"."uid"() = "created_by"));



CREATE POLICY "Owners can delete their own communities" ON "public"."communities" FOR DELETE TO "authenticated" USING (("created_by" = "auth"."uid"()));



CREATE POLICY "Owners can update their own communities" ON "public"."communities" FOR UPDATE TO "authenticated" USING (("created_by" = "auth"."uid"())) WITH CHECK (("created_by" = "auth"."uid"()));



CREATE POLICY "Receiver can update invite status" ON "public"."group_invites" FOR UPDATE USING (("auth"."uid"() = "to_user"));



CREATE POLICY "Users can create group polls" ON "public"."group_polls" FOR INSERT WITH CHECK (("auth"."uid"() = "sender_id"));



CREATE POLICY "Users can create groups" ON "public"."groups" FOR INSERT WITH CHECK (("auth"."uid"() = "created_by"));



CREATE POLICY "Users can create their own communities" ON "public"."communities" FOR INSERT TO "authenticated" WITH CHECK (("created_by" = "auth"."uid"()));



CREATE POLICY "Users can delete invites" ON "public"."group_invites" FOR DELETE USING ((("auth"."uid"() = "from_user") OR ("auth"."uid"() = "to_user")));



CREATE POLICY "Users can delete own group messages" ON "public"."group_messages" FOR DELETE USING (("auth"."uid"() = "sender_id"));



CREATE POLICY "Users can delete their invites" ON "public"."group_invites" FOR DELETE USING ((("auth"."uid"() = "to_user") OR ("auth"."uid"() = "from_user")));



CREATE POLICY "Users can dismiss their own warnings" ON "public"."media_expiry_warnings" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can insert invites" ON "public"."group_invites" FOR INSERT WITH CHECK (("auth"."uid"() = "from_user"));



CREATE POLICY "Users can insert own profile" ON "public"."users" FOR INSERT WITH CHECK (("auth"."uid"() = "id"));



CREATE POLICY "Users can manage chat requests" ON "public"."chat_requests" USING ((("auth"."uid"() = "from_user") OR ("auth"."uid"() = "to_user")));



CREATE POLICY "Users can manage own comments" ON "public"."comments" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own contacts" ON "public"."contacts" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own exclusions" ON "public"."status_exclusions" USING (("auth"."uid"() = "owner_id"));



CREATE POLICY "Users can manage own group reads" ON "public"."group_reads" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own likes" ON "public"."likes" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own membership" ON "public"."group_members" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own messages" ON "public"."messages" USING ((("auth"."uid"() = "sender_id") OR ("auth"."uid"() = "receiver_id")));



CREATE POLICY "Users can manage own push subscriptions" ON "public"."push_subscriptions" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own stories" ON "public"."stories" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage own votes" ON "public"."group_poll_votes" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage story likes" ON "public"."story_likes" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can manage story views" ON "public"."story_views" USING (("auth"."uid"() = "user_id"));



CREATE POLICY "Users can read all profiles" ON "public"."users" FOR SELECT USING (true);



CREATE POLICY "Users can read invites sent to them" ON "public"."group_invites" FOR SELECT USING ((("auth"."uid"() = "from_user") OR ("auth"."uid"() = "to_user")));



CREATE POLICY "Users can see contacts where they appear" ON "public"."contacts" FOR SELECT USING (("auth"."uid"() = "contact_id"));



CREATE POLICY "Users can send group messages" ON "public"."group_messages" FOR INSERT WITH CHECK (("auth"."uid"() = "sender_id"));



CREATE POLICY "Users can send invites" ON "public"."group_invites" FOR INSERT WITH CHECK (("auth"."uid"() = "from_user"));



CREATE POLICY "Users can update invites" ON "public"."group_invites" FOR UPDATE USING ((("auth"."uid"() = "from_user") OR ("auth"."uid"() = "to_user")));



CREATE POLICY "Users can update own profile" ON "public"."users" FOR UPDATE USING (("auth"."uid"() = "id"));



CREATE POLICY "Users can view their invites" ON "public"."group_invites" FOR SELECT USING ((("auth"."uid"() = "to_user") OR ("auth"."uid"() = "from_user")));



CREATE POLICY "Users can view their own warnings" ON "public"."media_expiry_warnings" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "admins can delete any group message" ON "public"."group_messages" FOR DELETE USING ("public"."is_group_admin"("group_id", "auth"."uid"()));



ALTER TABLE "public"."app_info" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."app_settings" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "channel_comments_delete_own" ON "public"."channel_post_comments" FOR DELETE USING (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_comments_insert_own" ON "public"."channel_post_comments" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_comments_select_all" ON "public"."channel_post_comments" FOR SELECT USING (true);



ALTER TABLE "public"."channel_follows" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "channel_follows_delete_own" ON "public"."channel_follows" FOR DELETE USING (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_follows_insert_own" ON "public"."channel_follows" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_follows_select_all" ON "public"."channel_follows" FOR SELECT USING (true);



CREATE POLICY "channel_likes_delete_own" ON "public"."channel_post_likes" FOR DELETE USING (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_likes_insert_own" ON "public"."channel_post_likes" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_likes_select_all" ON "public"."channel_post_likes" FOR SELECT USING (true);



ALTER TABLE "public"."channel_post_comments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."channel_post_likes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."channel_post_tips" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."channel_posts" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "channel_posts_delete_owner" ON "public"."channel_posts" FOR DELETE USING (("channel_id" IN ( SELECT "channels"."id"
   FROM "public"."channels"
  WHERE ("channels"."owner_id" = "auth"."uid"()))));



CREATE POLICY "channel_posts_insert_owner" ON "public"."channel_posts" FOR INSERT WITH CHECK (("channel_id" IN ( SELECT "channels"."id"
   FROM "public"."channels"
  WHERE ("channels"."owner_id" = "auth"."uid"()))));



CREATE POLICY "channel_posts_select_all" ON "public"."channel_posts" FOR SELECT USING (true);



CREATE POLICY "channel_posts_update_owner" ON "public"."channel_posts" FOR UPDATE USING (("channel_id" IN ( SELECT "channels"."id"
   FROM "public"."channels"
  WHERE ("channels"."owner_id" = "auth"."uid"()))));



CREATE POLICY "channel_subs_insert_own" ON "public"."channel_subscriptions" FOR INSERT WITH CHECK (("user_id" = "auth"."uid"()));



CREATE POLICY "channel_subs_select_own" ON "public"."channel_subscriptions" FOR SELECT USING ((("user_id" = "auth"."uid"()) OR ("channel_id" IN ( SELECT "channels"."id"
   FROM "public"."channels"
  WHERE ("channels"."owner_id" = "auth"."uid"())))));



ALTER TABLE "public"."channel_subscriptions" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "channel_tips_insert_own" ON "public"."channel_post_tips" FOR INSERT WITH CHECK (("from_user_id" = "auth"."uid"()));



CREATE POLICY "channel_tips_select_own" ON "public"."channel_post_tips" FOR SELECT USING ((("from_user_id" = "auth"."uid"()) OR ("to_user_id" = "auth"."uid"())));



ALTER TABLE "public"."channels" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "channels_delete_own" ON "public"."channels" FOR DELETE USING (("owner_id" = "auth"."uid"()));



CREATE POLICY "channels_insert_own" ON "public"."channels" FOR INSERT WITH CHECK ((("owner_id" = "auth"."uid"()) AND "public"."can_create_channel"("auth"."uid"())));



CREATE POLICY "channels_select_all" ON "public"."channels" FOR SELECT USING (true);



CREATE POLICY "channels_update_own" ON "public"."channels" FOR UPDATE USING (("owner_id" = "auth"."uid"()));



ALTER TABLE "public"."chat_requests" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."comments" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."communities" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."contact_settings" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "contact_settings_delete" ON "public"."contact_settings" FOR DELETE USING (("auth"."uid"() = "owner_id"));



CREATE POLICY "contact_settings_insert" ON "public"."contact_settings" FOR INSERT WITH CHECK (("auth"."uid"() = "owner_id"));



CREATE POLICY "contact_settings_select" ON "public"."contact_settings" FOR SELECT USING ((("auth"."uid"() = "owner_id") OR ("auth"."uid"() = "contact_id")));



CREATE POLICY "contact_settings_update" ON "public"."contact_settings" FOR UPDATE USING (("auth"."uid"() = "owner_id"));



ALTER TABLE "public"."contacts" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "delete own hidden_messages" ON "public"."hidden_messages" FOR DELETE USING (("owner_id" = "auth"."uid"()));



ALTER TABLE "public"."group_invites" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_members" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_messages" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_poll_votes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_polls" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."group_reads" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."groups" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."hidden_messages" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "insert own hidden_messages" ON "public"."hidden_messages" FOR INSERT WITH CHECK (("owner_id" = "auth"."uid"()));



ALTER TABLE "public"."likes" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."media_expiry_warnings" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "members can delete own group message" ON "public"."group_messages" FOR DELETE USING (("sender_id" = "auth"."uid"()));



ALTER TABLE "public"."messages" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "own push subscriptions" ON "public"."push_subscriptions" USING (("auth"."uid"() = "user_id")) WITH CHECK (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."private_reads" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "private_reads_insert" ON "public"."private_reads" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "private_reads_select" ON "public"."private_reads" FOR SELECT USING ((("auth"."uid"() = "user_id") OR ("auth"."uid"() = "contact_id")));



CREATE POLICY "private_reads_update" ON "public"."private_reads" FOR UPDATE USING (("auth"."uid"() = "user_id"));



ALTER TABLE "public"."push_subscriptions" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "select own hidden_messages" ON "public"."hidden_messages" FOR SELECT USING (("owner_id" = "auth"."uid"()));



CREATE POLICY "status exclusions are viewable by all authenticated users" ON "public"."status_exclusions" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."status_exclusions" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."stories" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "stories are viewable by all authenticated users" ON "public"."stories" FOR SELECT TO "authenticated" USING (true);



ALTER TABLE "public"."story_likes" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "story_likes_delete_own" ON "public"."story_likes" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "story_likes_insert_own" ON "public"."story_likes" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "story_likes_select_all" ON "public"."story_likes" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



ALTER TABLE "public"."story_views" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "story_views_insert_own" ON "public"."story_views" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "story_views_select_all" ON "public"."story_views" FOR SELECT USING (("auth"."role"() = 'authenticated'::"text"));



ALTER TABLE "public"."tips" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."topups" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."users" ENABLE ROW LEVEL SECURITY;


ALTER TABLE "public"."wallets" ENABLE ROW LEVEL SECURITY;




ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";






ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."chat_requests";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."contacts";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."group_invites";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."group_members";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."group_messages";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."group_poll_votes";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."groups";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."messages";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."stories";



ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."users";






GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";














































































































































































GRANT ALL ON FUNCTION "public"."activate_vip"("p_user_id" "uuid", "p_plan" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."activate_vip"("p_user_id" "uuid", "p_plan" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."activate_vip"("p_user_id" "uuid", "p_plan" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."can_create_channel"("p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."can_create_channel"("p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."can_create_channel"("p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."channel_comment_count_sync"() TO "anon";
GRANT ALL ON FUNCTION "public"."channel_comment_count_sync"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."channel_comment_count_sync"() TO "service_role";



GRANT ALL ON FUNCTION "public"."channel_follow_count_sync"() TO "anon";
GRANT ALL ON FUNCTION "public"."channel_follow_count_sync"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."channel_follow_count_sync"() TO "service_role";



GRANT ALL ON FUNCTION "public"."channel_like_count_sync"() TO "anon";
GRANT ALL ON FUNCTION "public"."channel_like_count_sync"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."channel_like_count_sync"() TO "service_role";



GRANT ALL ON FUNCTION "public"."channel_post_count_sync"() TO "anon";
GRANT ALL ON FUNCTION "public"."channel_post_count_sync"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."channel_post_count_sync"() TO "service_role";



GRANT ALL ON FUNCTION "public"."channel_tip_apply"() TO "anon";
GRANT ALL ON FUNCTION "public"."channel_tip_apply"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."channel_tip_apply"() TO "service_role";



GRANT ALL ON FUNCTION "public"."complete_topup"("p_payment_reference" "text") TO "anon";
GRANT ALL ON FUNCTION "public"."complete_topup"("p_payment_reference" "text") TO "authenticated";
GRANT ALL ON FUNCTION "public"."complete_topup"("p_payment_reference" "text") TO "service_role";



GRANT ALL ON FUNCTION "public"."create_wallet_for_new_user"() TO "anon";
GRANT ALL ON FUNCTION "public"."create_wallet_for_new_user"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."create_wallet_for_new_user"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_channel_follow_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_channel_follow_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_channel_follow_count"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_channel_post_comment_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_channel_post_comment_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_channel_post_comment_count"() TO "service_role";



GRANT ALL ON FUNCTION "public"."handle_channel_post_like_count"() TO "anon";
GRANT ALL ON FUNCTION "public"."handle_channel_post_like_count"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."handle_channel_post_like_count"() TO "service_role";



GRANT ALL ON FUNCTION "public"."is_group_admin"("p_group_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_group_admin"("p_group_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_group_admin"("p_group_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."is_group_member"("p_group_id" "uuid", "p_user_id" "uuid") TO "anon";
GRANT ALL ON FUNCTION "public"."is_group_member"("p_group_id" "uuid", "p_user_id" "uuid") TO "authenticated";
GRANT ALL ON FUNCTION "public"."is_group_member"("p_group_id" "uuid", "p_user_id" "uuid") TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_community_verification"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_community_verification"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_community_verification"() TO "service_role";
























GRANT ALL ON TABLE "public"."app_info" TO "anon";
GRANT ALL ON TABLE "public"."app_info" TO "authenticated";
GRANT ALL ON TABLE "public"."app_info" TO "service_role";



GRANT ALL ON TABLE "public"."app_settings" TO "anon";
GRANT ALL ON TABLE "public"."app_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."app_settings" TO "service_role";



GRANT ALL ON TABLE "public"."channel_follows" TO "anon";
GRANT ALL ON TABLE "public"."channel_follows" TO "authenticated";
GRANT ALL ON TABLE "public"."channel_follows" TO "service_role";



GRANT ALL ON TABLE "public"."channel_post_comments" TO "anon";
GRANT ALL ON TABLE "public"."channel_post_comments" TO "authenticated";
GRANT ALL ON TABLE "public"."channel_post_comments" TO "service_role";



GRANT ALL ON TABLE "public"."channel_post_likes" TO "anon";
GRANT ALL ON TABLE "public"."channel_post_likes" TO "authenticated";
GRANT ALL ON TABLE "public"."channel_post_likes" TO "service_role";



GRANT ALL ON TABLE "public"."channel_post_tips" TO "anon";
GRANT ALL ON TABLE "public"."channel_post_tips" TO "authenticated";
GRANT ALL ON TABLE "public"."channel_post_tips" TO "service_role";



GRANT ALL ON TABLE "public"."channel_posts" TO "anon";
GRANT ALL ON TABLE "public"."channel_posts" TO "authenticated";
GRANT ALL ON TABLE "public"."channel_posts" TO "service_role";



GRANT ALL ON TABLE "public"."channel_subscriptions" TO "anon";
GRANT ALL ON TABLE "public"."channel_subscriptions" TO "authenticated";
GRANT ALL ON TABLE "public"."channel_subscriptions" TO "service_role";



GRANT ALL ON TABLE "public"."channels" TO "anon";
GRANT ALL ON TABLE "public"."channels" TO "authenticated";
GRANT ALL ON TABLE "public"."channels" TO "service_role";



GRANT ALL ON TABLE "public"."chat_requests" TO "anon";
GRANT ALL ON TABLE "public"."chat_requests" TO "authenticated";
GRANT ALL ON TABLE "public"."chat_requests" TO "service_role";



GRANT ALL ON TABLE "public"."comments" TO "anon";
GRANT ALL ON TABLE "public"."comments" TO "authenticated";
GRANT ALL ON TABLE "public"."comments" TO "service_role";



GRANT ALL ON TABLE "public"."communities" TO "anon";
GRANT ALL ON TABLE "public"."communities" TO "authenticated";
GRANT ALL ON TABLE "public"."communities" TO "service_role";



GRANT ALL ON TABLE "public"."contact_settings" TO "anon";
GRANT ALL ON TABLE "public"."contact_settings" TO "authenticated";
GRANT ALL ON TABLE "public"."contact_settings" TO "service_role";



GRANT ALL ON TABLE "public"."contacts" TO "anon";
GRANT ALL ON TABLE "public"."contacts" TO "authenticated";
GRANT ALL ON TABLE "public"."contacts" TO "service_role";



GRANT ALL ON TABLE "public"."group_invites" TO "anon";
GRANT ALL ON TABLE "public"."group_invites" TO "authenticated";
GRANT ALL ON TABLE "public"."group_invites" TO "service_role";



GRANT ALL ON TABLE "public"."group_members" TO "anon";
GRANT ALL ON TABLE "public"."group_members" TO "authenticated";
GRANT ALL ON TABLE "public"."group_members" TO "service_role";



GRANT ALL ON TABLE "public"."group_messages" TO "anon";
GRANT ALL ON TABLE "public"."group_messages" TO "authenticated";
GRANT ALL ON TABLE "public"."group_messages" TO "service_role";



GRANT ALL ON TABLE "public"."group_poll_votes" TO "anon";
GRANT ALL ON TABLE "public"."group_poll_votes" TO "authenticated";
GRANT ALL ON TABLE "public"."group_poll_votes" TO "service_role";



GRANT ALL ON TABLE "public"."group_polls" TO "anon";
GRANT ALL ON TABLE "public"."group_polls" TO "authenticated";
GRANT ALL ON TABLE "public"."group_polls" TO "service_role";



GRANT ALL ON TABLE "public"."group_reads" TO "anon";
GRANT ALL ON TABLE "public"."group_reads" TO "authenticated";
GRANT ALL ON TABLE "public"."group_reads" TO "service_role";



GRANT ALL ON TABLE "public"."groups" TO "anon";
GRANT ALL ON TABLE "public"."groups" TO "authenticated";
GRANT ALL ON TABLE "public"."groups" TO "service_role";



GRANT ALL ON TABLE "public"."hidden_messages" TO "anon";
GRANT ALL ON TABLE "public"."hidden_messages" TO "authenticated";
GRANT ALL ON TABLE "public"."hidden_messages" TO "service_role";



GRANT ALL ON TABLE "public"."likes" TO "anon";
GRANT ALL ON TABLE "public"."likes" TO "authenticated";
GRANT ALL ON TABLE "public"."likes" TO "service_role";



GRANT ALL ON TABLE "public"."media_expiry_warnings" TO "anon";
GRANT ALL ON TABLE "public"."media_expiry_warnings" TO "authenticated";
GRANT ALL ON TABLE "public"."media_expiry_warnings" TO "service_role";



GRANT ALL ON TABLE "public"."messages" TO "anon";
GRANT ALL ON TABLE "public"."messages" TO "authenticated";
GRANT ALL ON TABLE "public"."messages" TO "service_role";



GRANT ALL ON TABLE "public"."private_reads" TO "anon";
GRANT ALL ON TABLE "public"."private_reads" TO "authenticated";
GRANT ALL ON TABLE "public"."private_reads" TO "service_role";



GRANT ALL ON TABLE "public"."push_subscriptions" TO "anon";
GRANT ALL ON TABLE "public"."push_subscriptions" TO "authenticated";
GRANT ALL ON TABLE "public"."push_subscriptions" TO "service_role";



GRANT ALL ON TABLE "public"."status_exclusions" TO "anon";
GRANT ALL ON TABLE "public"."status_exclusions" TO "authenticated";
GRANT ALL ON TABLE "public"."status_exclusions" TO "service_role";



GRANT ALL ON TABLE "public"."stories" TO "anon";
GRANT ALL ON TABLE "public"."stories" TO "authenticated";
GRANT ALL ON TABLE "public"."stories" TO "service_role";



GRANT ALL ON TABLE "public"."story_likes" TO "anon";
GRANT ALL ON TABLE "public"."story_likes" TO "authenticated";
GRANT ALL ON TABLE "public"."story_likes" TO "service_role";



GRANT ALL ON TABLE "public"."story_views" TO "anon";
GRANT ALL ON TABLE "public"."story_views" TO "authenticated";
GRANT ALL ON TABLE "public"."story_views" TO "service_role";



GRANT ALL ON TABLE "public"."tips" TO "anon";
GRANT ALL ON TABLE "public"."tips" TO "authenticated";
GRANT ALL ON TABLE "public"."tips" TO "service_role";



GRANT ALL ON TABLE "public"."topups" TO "anon";
GRANT ALL ON TABLE "public"."topups" TO "authenticated";
GRANT ALL ON TABLE "public"."topups" TO "service_role";



GRANT ALL ON TABLE "public"."users" TO "anon";
GRANT ALL ON TABLE "public"."users" TO "authenticated";
GRANT ALL ON TABLE "public"."users" TO "service_role";



GRANT ALL ON TABLE "public"."wallets" TO "anon";
GRANT ALL ON TABLE "public"."wallets" TO "authenticated";
GRANT ALL ON TABLE "public"."wallets" TO "service_role";









ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES TO "service_role";































