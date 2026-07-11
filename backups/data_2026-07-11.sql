SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict uTNBMbNVb6BLvu62w8eczpOIwcZ5t4u9sTzn0tdNfmChwtMi5vIzaRcI33GlyKg

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."users" ("instance_id", "id", "aud", "role", "email", "encrypted_password", "email_confirmed_at", "invited_at", "confirmation_token", "confirmation_sent_at", "recovery_token", "recovery_sent_at", "email_change_token_new", "email_change", "email_change_sent_at", "last_sign_in_at", "raw_app_meta_data", "raw_user_meta_data", "is_super_admin", "created_at", "updated_at", "phone", "phone_confirmed_at", "phone_change", "phone_change_token", "phone_change_sent_at", "email_change_token_current", "email_change_confirm_status", "banned_until", "reauthentication_token", "reauthentication_sent_at", "is_sso_user", "deleted_at", "is_anonymous") VALUES
	('00000000-0000-0000-0000-000000000000', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'authenticated', 'authenticated', 'ememprince82@gmail.com', '$2a$10$UvE8D8Ml.KF6KHbOvyp9Cuj4lzYb37k3pbr/fz9C/DW6RbcKDwnZK', '2026-07-06 17:52:06.151979+00', NULL, '', '2026-07-06 17:51:16.453046+00', '', NULL, '', '', NULL, '2026-07-06 17:52:06.167369+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "2bb13930-2533-4c22-8da4-ebcf89d41b89", "name": "Dr Nyenwe emem", "email": "ememprince82@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-06 17:51:16.405498+00', '2026-07-06 17:52:06.218835+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'authenticated', 'authenticated', 'agent345345@gmail.com', '$2a$10$8hZ8hD9VM.EXNslShd4xP.dE7RwsNDHkr6muy6rWfPW6AV80ygG5W', '2026-07-06 10:26:34.398591+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-07-11 10:03:08.630705+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "7b4fe7f5-3a78-4e8f-896c-ced82f85138d", "name": "Owner", "email": "agent345345@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-06 10:26:00.881671+00', '2026-07-11 10:03:08.650684+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'authenticated', 'authenticated', 'dgreatman1234@gmail.com', '$2a$10$565ClNcbGqmMg4HxGx7X4u8oXiFCwRcc1z3/0p4/zCSdJyUvMcjma', '2026-07-04 11:35:29.655031+00', NULL, '', '2026-07-04 11:35:01.989194+00', '', NULL, '', '', NULL, '2026-07-09 17:00:49.858982+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "bd8fb801-d0c7-4381-90b5-343e5c538a32", "name": "DGREAT", "email": "dgreatman1234@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-04 11:33:54.543675+00', '2026-07-11 09:59:43.068391+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('bd8fb801-d0c7-4381-90b5-343e5c538a32', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '{"sub": "bd8fb801-d0c7-4381-90b5-343e5c538a32", "name": "DGREAT", "email": "dgreatman1234@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-04 11:33:54.572345+00', '2026-07-04 11:33:54.572398+00', '2026-07-04 11:33:54.572398+00', '499b071e-870c-4c7e-b2b5-805dc0add368'),
	('7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '{"sub": "7b4fe7f5-3a78-4e8f-896c-ced82f85138d", "name": "Owner", "email": "agent345345@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-06 10:26:00.895136+00', '2026-07-06 10:26:00.895183+00', '2026-07-06 10:26:00.895183+00', '22704a08-cc87-4f18-a927-8f190f08a13f'),
	('2bb13930-2533-4c22-8da4-ebcf89d41b89', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '{"sub": "2bb13930-2533-4c22-8da4-ebcf89d41b89", "name": "Dr Nyenwe emem", "email": "ememprince82@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-06 17:51:16.439616+00', '2026-07-06 17:51:16.439668+00', '2026-07-06 17:51:16.439668+00', '068884a0-ce70-4165-b9c4-3fb4d69cfa74');


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."sessions" ("id", "user_id", "created_at", "updated_at", "factor_id", "aal", "not_after", "refreshed_at", "user_agent", "ip", "tag", "oauth_client_id", "refresh_token_hmac_key", "refresh_token_counter", "scopes") VALUES
	('1c20b65a-15d8-454b-8883-df5a9cfafd84', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-11 10:03:08.631815+00', '2026-07-11 10:03:08.631815+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '102.90.102.195', NULL, NULL, NULL, NULL, NULL),
	('8817ec22-92c1-41a8-9869-7e1a9515169a', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-06 17:52:06.175948+00', '2026-07-06 17:52:06.175948+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '102.90.102.73', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('8817ec22-92c1-41a8-9869-7e1a9515169a', '2026-07-06 17:52:06.219562+00', '2026-07-06 17:52:06.219562+00', 'otp', '1274b27e-ece6-421f-8264-84d41e5d1427'),
	('1c20b65a-15d8-454b-8883-df5a9cfafd84', '2026-07-11 10:03:08.659024+00', '2026-07-11 10:03:08.659024+00', 'password', '4de074e7-347d-41e5-8e5e-77177ace21d6');


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."refresh_tokens" ("instance_id", "id", "token", "user_id", "revoked", "created_at", "updated_at", "parent", "session_id") VALUES
	('00000000-0000-0000-0000-000000000000', 45, 'cxjbgpadjb4g', '2bb13930-2533-4c22-8da4-ebcf89d41b89', false, '2026-07-06 17:52:06.19972+00', '2026-07-06 17:52:06.19972+00', NULL, '8817ec22-92c1-41a8-9869-7e1a9515169a'),
	('00000000-0000-0000-0000-000000000000', 63, 'alzlnjto3ffl', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, '2026-07-11 10:03:08.647406+00', '2026-07-11 10:03:08.647406+00', NULL, '1c20b65a-15d8-454b-8883-df5a9cfafd84');


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--



--
-- Data for Name: app_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."users" ("id", "name", "email", "chat_code", "avatar_url", "about", "created_at", "avatar_public_id") VALUES
	('bd8fb801-d0c7-4381-90b5-343e5c538a32', 'DGREAT', 'dgreatman1234@gmail.com', 'W4KKY-7CDZG', 'https://res.cloudinary.com/fwgk9xow/image/upload/v1783324196/rilioq7gjzlawbtey1bw.png', 'Hey there! I am using DgreatVerse.', '2026-07-04 11:35:31.344047+00', 'rilioq7gjzlawbtey1bw'),
	('7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Owner', 'agent345345@gmail.com', '2DZTF-VDNXU', 'https://res.cloudinary.com/fwgk9xow/image/upload/v1783356554/jihe8idpnfqpeujp8cdd.png', 'Hey there! I am using DgreatVerse.', '2026-07-06 10:26:35.737711+00', 'jihe8idpnfqpeujp8cdd'),
	('2bb13930-2533-4c22-8da4-ebcf89d41b89', 'Dr Nyenwe emem', 'ememprince82@gmail.com', 'HNBMA-PXFE9', NULL, 'Hey there! I am using DgreatVerse.', '2026-07-06 17:52:08.215712+00', NULL);


--
-- Data for Name: chat_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."chat_requests" ("id", "from_user", "to_user", "status", "created_at") VALUES
	('b1498d82-2d18-410b-9d94-b51962699462', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'accepted', '2026-07-06 10:27:19.370942+00'),
	('b8f4138e-5b40-4a8b-9d07-e8f3e9f4b3ae', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'accepted', '2026-07-06 17:58:32.589503+00');


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."groups" ("id", "name", "description", "avatar_url", "created_by", "created_at", "about", "msg_permission", "invite_code", "invite_enabled", "avatar_public_id") VALUES
	('0de11080-bdc4-47b2-9ca8-389119d491ea', 'Dgreat', NULL, 'https://res.cloudinary.com/fwgk9xow/image/upload/v1783339007/nvwxyhaxe8y5vjzjs4fk.png', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-06 11:56:49.067342+00', 'Cool people', 'all', 'DUXTSKTDHW7', true, 'nvwxyhaxe8y5vjzjs4fk');


--
-- Data for Name: group_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."group_messages" ("id", "group_id", "sender_id", "content", "file_url", "file_type", "reply_to_id", "created_at", "public_id", "expiry_warned") VALUES
	('23a137d8-eb03-4647-b818-efbda485f79d', '0de11080-bdc4-47b2-9ca8-389119d491ea', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hello world', NULL, NULL, NULL, '2026-07-07 08:38:19.638203+00', NULL, false);


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."messages" ("id", "sender_id", "receiver_id", "content", "file_url", "file_type", "reply_to_id", "read_at", "created_at", "public_id", "expiry_warned", "expires_at") VALUES
	('5fabe561-c213-4005-94ac-2cbbe7981395', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 12:10:07.823642+00', NULL, false, NULL),
	('fb8953dc-0191-4e82-a27f-3eb3d511ce77', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hibro', NULL, 'text', NULL, NULL, '2026-07-06 14:31:32.518997+00', NULL, false, '2026-07-07 14:31:30.638+00'),
	('e7064034-d618-422c-bbb0-4ca1d6b0eb3c', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 14:33:58.531533+00', NULL, false, '2026-07-07 14:33:56.723+00'),
	('c5c8b363-8899-48ab-8042-e1d11fb9abcd', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi i', NULL, 'text', NULL, NULL, '2026-07-06 16:26:14.692035+00', NULL, false, '2026-07-07 16:26:12.834+00'),
	('de63a068-8e61-4ba2-9757-a2a421237f0d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 16:49:36.866158+00', NULL, false, NULL),
	('6a7fe646-4334-46c2-9b45-e157004189ff', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 17:58:50.031509+00', NULL, false, NULL),
	('1fa1e6f8-5a50-40dd-aee8-1a0e01c6de59', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'How r u doing b', NULL, 'text', NULL, NULL, '2026-07-06 17:59:25.875727+00', NULL, false, NULL),
	('55043212-d708-4eed-b690-77ad541c566d', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Ok', NULL, 'text', NULL, NULL, '2026-07-06 18:00:30.490851+00', NULL, false, NULL),
	('c89fb0ec-7c24-4528-86d6-6e9855589202', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'Cool', NULL, 'text', NULL, NULL, '2026-07-06 18:01:34.937746+00', NULL, false, NULL),
	('84666e86-89bf-4812-bb0c-6b2db9d994b4', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'How', NULL, 'text', NULL, NULL, '2026-07-06 18:01:51.690079+00', NULL, false, NULL),
	('f6783ff8-92c9-4c55-9cfb-395dbd9d7300', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 19:59:57.306236+00', NULL, false, '2026-07-07 19:59:55.49+00'),
	('0b4e3e97-1323-4d2e-8670-6cc74ae26136', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hi bro', NULL, 'text', NULL, NULL, '2026-07-06 20:00:11.049245+00', NULL, false, NULL),
	('bafd2850-63c8-430d-adfb-cb6075a02624', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hallo', NULL, 'text', NULL, NULL, '2026-07-06 20:23:39.003913+00', NULL, false, NULL),
	('1caa68ab-b493-4dab-913d-9059acb8288d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 21:12:40.343224+00', NULL, false, NULL),
	('bdd7ff62-2a11-4202-b7f5-b036288a00be', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-06 23:18:28.279192+00', NULL, false, '2026-07-07 23:18:26.455+00'),
	('044be065-98a6-4002-9797-4aa520f27ae3', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hello', NULL, 'text', NULL, NULL, '2026-07-06 23:19:58.402029+00', NULL, false, NULL),
	('52ea8d05-bf32-4fe7-a4d1-c744dd0c173c', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Cool notification work', NULL, 'text', NULL, NULL, '2026-07-06 23:20:35.119734+00', NULL, false, '2026-07-07 23:20:33.461+00'),
	('b311e75d-7323-4af5-b7f7-f2b76baf0a89', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-07 08:22:29.268628+00', NULL, false, NULL),
	('5bfe200f-b8e4-4153-be1c-3cb9aba5fa56', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-07 08:23:08.443666+00', NULL, false, NULL),
	('f4a4deb1-e774-47bc-a125-203b50baf299', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-07 08:23:54.320405+00', NULL, false, '2026-07-08 08:23:52.475+00'),
	('eded2e82-965c-4613-b5aa-199672aed8d2', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hallo', NULL, 'text', NULL, NULL, '2026-07-07 08:24:16.481944+00', NULL, false, NULL),
	('02d57595-a7dd-4828-a0d4-fc42db1524b6', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-07 08:24:41.511779+00', NULL, false, '2026-07-08 08:24:39.662+00'),
	('f8237e75-1b29-4cd5-a559-c59e49670d34', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Wow', NULL, 'text', NULL, NULL, '2026-07-07 08:25:05.562934+00', NULL, false, NULL),
	('6855d669-3246-4656-bccb-e5d04e684db1', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Mumu', NULL, 'text', NULL, NULL, '2026-07-07 08:25:25.621565+00', NULL, false, '2026-07-08 08:25:23.785+00'),
	('13bf7daa-a5ab-4e75-bf0d-c0b2e8926747', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-07 08:37:29.141889+00', NULL, false, '2026-07-08 08:37:27.036+00'),
	('91173955-c835-4201-9664-2db9e8bd89ce', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Coo', NULL, 'text', NULL, NULL, '2026-07-07 08:37:50.699189+00', NULL, false, '2026-07-08 08:37:48.803+00'),
	('d069edf5-9f69-4c9e-9b9e-e21a52037824', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Yhh', NULL, 'text', NULL, NULL, '2026-07-07 08:38:00.009154+00', NULL, false, NULL),
	('f9e8a731-3b55-4928-9f69-dab1df14aa2f', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hwfa', NULL, 'text', NULL, NULL, '2026-07-11 10:01:57.569718+00', NULL, false, '2026-07-12 10:01:56.198+00'),
	('bcf98934-67c1-4a81-89d5-c432412bab64', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'I dey', NULL, 'text', NULL, NULL, '2026-07-11 10:03:29.946287+00', NULL, false, NULL),
	('636c693e-45d3-4940-8e6d-120156600e24', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '😁', NULL, 'text', NULL, NULL, '2026-07-11 10:03:59.958266+00', NULL, false, NULL);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: contact_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."contact_settings" ("id", "owner_id", "contact_id", "archived", "hidden", "hide_pin", "blocked", "disappear_seconds", "created_at", "updated_at", "cleared_before") VALUES
	('b1b0ab8c-4bb1-477d-a41f-bcd8d9b5be50', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', false, false, NULL, false, 0, '2026-07-06 12:19:13.530859+00', '2026-07-06 12:19:13.530859+00', NULL),
	('1d073e95-772a-46a8-ad9a-494c4b2c5de6', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, false, NULL, false, 86400, '2026-07-06 14:33:48.353297+00', '2026-07-06 14:33:48.353297+00', NULL);


--
-- Data for Name: contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."contacts" ("id", "user_id", "contact_id", "created_at") VALUES
	('2519ebc4-9d13-46c4-aab1-8c960e882068', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-06 10:27:27.269541+00'),
	('b369ccc8-ebad-4f18-9230-0a30ffdce969', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-06 17:58:39.79472+00');


--
-- Data for Name: group_invites; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."group_invites" ("id", "group_id", "status", "created_at", "from_user", "to_user") VALUES
	('1aac9c2a-73cb-4654-aca4-79713489959f', '0de11080-bdc4-47b2-9ca8-389119d491ea', 'accepted', '2026-07-06 11:56:50.199407+00', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d');


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."group_members" ("id", "group_id", "user_id", "joined_at", "is_admin") VALUES
	('80fa3ade-cdfe-4338-bf86-9413042d128d', '0de11080-bdc4-47b2-9ca8-389119d491ea', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-06 11:56:49.440311+00', true),
	('1a87a1e6-0aa9-4772-83df-372ed8119e9d', '0de11080-bdc4-47b2-9ca8-389119d491ea', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-06 12:06:47.332338+00', false);


--
-- Data for Name: group_polls; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: group_poll_votes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: group_reads; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."group_reads" ("id", "group_id", "user_id", "last_read_at") VALUES
	('3ce68150-f54f-4c09-b993-fbdd306c1b96', '0de11080-bdc4-47b2-9ca8-389119d491ea', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-06 16:49:40.241+00'),
	('c942acb7-845e-4db3-a48d-f8c784f19a36', '0de11080-bdc4-47b2-9ca8-389119d491ea', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-07 08:38:08.527+00');


--
-- Data for Name: hidden_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."hidden_messages" ("id", "owner_id", "message_id", "created_at") VALUES
	('11e13a51-ccb0-492c-9733-7da1cfa30e12', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '5fabe561-c213-4005-94ac-2cbbe7981395', '2026-07-06 12:18:20.785519+00');


--
-- Data for Name: likes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."likes" ("id", "message_id", "group_message_id", "user_id", "created_at", "emoji") VALUES
	('0b1404e7-ccc5-4360-87eb-025efb900ee9', '84666e86-89bf-4812-bb0c-6b2db9d994b4', NULL, 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-06 18:02:22.090359+00', '❤️');


--
-- Data for Name: media_expiry_warnings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: private_reads; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."private_reads" ("id", "user_id", "contact_id", "last_read_at") VALUES
	('d9222e6a-085f-4cf0-b92b-37eb362068ab', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-07 08:24:48.103+00'),
	('6c0266a8-af3f-4b36-aa5b-2a27d84c9320', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-11 10:01:30.698+00'),
	('7d1d0dbc-af1f-4909-b307-2ff40a3843d0', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-06 18:00:58.341+00'),
	('30fc57f3-8976-4d31-87de-4ba3016cff7d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-11 10:01:57.263+00'),
	('0000ce4e-fda1-48a6-8ce8-7406e98c09f2', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-11 10:17:10.367+00');


--
-- Data for Name: push_subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."push_subscriptions" ("id", "user_id", "endpoint", "p256dh", "auth", "created_at") VALUES
	('933b1961-0394-4c09-ad3d-653fde39abf1', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'https://fcm.googleapis.com/fcm/send/fgzsiDOq6O0:APA91bFZ6Xa0-qeN0G8voQy0qoeiD6eQglxYT7JY15ejKogSR60Y8-R7wGO1PkSg1eCI8vGkvb6nnErrDHPSXdsmSq1tgDkUrCgDJNpRUrM5jkHyKUJwftvLUdCtsaIjQarPGCdGW0mc', 'BKM24nBFvqN_CNnACDW2kt5aJAk106oAKyD2zCwSZdWiTA-AZDAQeR3NNkY2bDjOMDBdRFMc5M71BQneogXvEQY', 'PtGKZPjwV4inODYqMIe02g', '2026-07-06 22:42:40.352044+00');


--
-- Data for Name: status_exclusions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: stories; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: story_likes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: story_views; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--



--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

INSERT INTO "supabase_functions"."hooks" ("id", "hook_table_id", "hook_name", "created_at", "request_id") VALUES
	(1, 17660, 'send_notification_on_new_message', '2026-07-06 23:18:28.279192+00', 121),
	(2, 17660, 'send_notification_on_new_message', '2026-07-06 23:19:58.402029+00', 122),
	(3, 17660, 'send_notification_on_new_message', '2026-07-06 23:20:35.119734+00', 124),
	(4, 17660, 'send_notification_on_new_message', '2026-07-07 08:22:29.268628+00', 235),
	(5, 17660, 'send_notification_on_new_message', '2026-07-07 08:23:08.443666+00', 236),
	(6, 17660, 'send_notification_on_new_message', '2026-07-07 08:23:54.320405+00', 237),
	(7, 17660, 'send_notification_on_new_message', '2026-07-07 08:24:16.481944+00', 238),
	(8, 17660, 'send_notification_on_new_message', '2026-07-07 08:24:41.511779+00', 239),
	(9, 17660, 'send_notification_on_new_message', '2026-07-07 08:25:05.562934+00', 241),
	(10, 17660, 'send_notification_on_new_message', '2026-07-07 08:25:25.621565+00', 242),
	(11, 17660, 'send_notification_on_new_message', '2026-07-07 08:37:29.141889+00', 245),
	(12, 17660, 'send_notification_on_new_message', '2026-07-07 08:37:50.699189+00', 246),
	(13, 17660, 'send_notification_on_new_message', '2026-07-07 08:38:00.009154+00', 247),
	(14, 17785, 'send_notification_on_new_group_message', '2026-07-07 08:38:19.638203+00', 248),
	(15, 17660, 'send_notification_on_new_message', '2026-07-11 10:01:57.569718+00', 1426),
	(16, 17660, 'send_notification_on_new_message', '2026-07-11 10:03:29.946287+00', 1427),
	(17, 17660, 'send_notification_on_new_message', '2026-07-11 10:03:59.958266+00', 1428);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 63, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 17, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict uTNBMbNVb6BLvu62w8eczpOIwcZ5t4u9sTzn0tdNfmChwtMi5vIzaRcI33GlyKg

RESET ALL;
