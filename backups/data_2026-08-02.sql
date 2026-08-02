SET session_replication_role = replica;

--
-- PostgreSQL database dump
--

-- \restrict n6KRqhGqLBX4dZvf6d6BqNsWb2UWhqK3uElcFfayqaFPzScTyRayXIHuYic8aip

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
	('00000000-0000-0000-0000-000000000000', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'authenticated', 'authenticated', 'agent345345@gmail.com', '$2a$10$8hZ8hD9VM.EXNslShd4xP.dE7RwsNDHkr6muy6rWfPW6AV80ygG5W', '2026-07-06 10:26:34.398591+00', NULL, '', NULL, '', NULL, '', '', NULL, '2026-07-13 11:12:02.11567+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "7b4fe7f5-3a78-4e8f-896c-ced82f85138d", "name": "Owner", "email": "agent345345@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-06 10:26:00.881671+00', '2026-07-13 11:12:02.151411+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'authenticated', 'authenticated', 'ememprince82@gmail.com', '$2a$10$UvE8D8Ml.KF6KHbOvyp9Cuj4lzYb37k3pbr/fz9C/DW6RbcKDwnZK', '2026-07-06 17:52:06.151979+00', NULL, '', '2026-07-06 17:51:16.453046+00', '', NULL, '', '', NULL, '2026-07-19 17:54:13.520255+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "2bb13930-2533-4c22-8da4-ebcf89d41b89", "name": "Dr Nyenwe emem", "email": "ememprince82@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-06 17:51:16.405498+00', '2026-07-28 11:22:27.116795+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'authenticated', 'authenticated', 'dgreatman1234@gmail.com', '$2a$10$565ClNcbGqmMg4HxGx7X4u8oXiFCwRcc1z3/0p4/zCSdJyUvMcjma', '2026-07-04 11:35:29.655031+00', NULL, '', '2026-07-04 11:35:01.989194+00', '', NULL, '', '', NULL, '2026-07-12 13:14:28.501901+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "bd8fb801-d0c7-4381-90b5-343e5c538a32", "name": "DGREAT", "email": "dgreatman1234@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-04 11:33:54.543675+00', '2026-07-13 11:18:41.926437+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false),
	('00000000-0000-0000-0000-000000000000', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', 'authenticated', 'authenticated', 'queenjose86@gmail.com', '$2a$10$V6yBLsZtWNSyzs1zDEhfDuck8LPAs/0QDbbR10nK0n86UBllfLRPS', '2026-07-14 11:53:31.386304+00', NULL, '', '2026-07-14 11:52:47.550954+00', '', NULL, '', '', NULL, '2026-07-14 11:53:31.393078+00', '{"provider": "email", "providers": ["email"]}', '{"sub": "18c62b9f-9666-4ba1-a2ef-71d8c1a3b352", "name": "Queen", "email": "queenjose86@gmail.com", "email_verified": true, "phone_verified": false}', NULL, '2026-07-14 11:52:47.491154+00', '2026-07-14 12:54:30.330877+00', NULL, NULL, '', '', NULL, '', 0, NULL, '', NULL, false, NULL, false);


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."identities" ("provider_id", "user_id", "identity_data", "provider", "last_sign_in_at", "created_at", "updated_at", "id") VALUES
	('bd8fb801-d0c7-4381-90b5-343e5c538a32', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '{"sub": "bd8fb801-d0c7-4381-90b5-343e5c538a32", "name": "DGREAT", "email": "dgreatman1234@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-04 11:33:54.572345+00', '2026-07-04 11:33:54.572398+00', '2026-07-04 11:33:54.572398+00', '499b071e-870c-4c7e-b2b5-805dc0add368'),
	('7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '{"sub": "7b4fe7f5-3a78-4e8f-896c-ced82f85138d", "name": "Owner", "email": "agent345345@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-06 10:26:00.895136+00', '2026-07-06 10:26:00.895183+00', '2026-07-06 10:26:00.895183+00', '22704a08-cc87-4f18-a927-8f190f08a13f'),
	('2bb13930-2533-4c22-8da4-ebcf89d41b89', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '{"sub": "2bb13930-2533-4c22-8da4-ebcf89d41b89", "name": "Dr Nyenwe emem", "email": "ememprince82@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-06 17:51:16.439616+00', '2026-07-06 17:51:16.439668+00', '2026-07-06 17:51:16.439668+00', '068884a0-ce70-4165-b9c4-3fb4d69cfa74'),
	('18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', '{"sub": "18c62b9f-9666-4ba1-a2ef-71d8c1a3b352", "name": "Queen", "email": "queenjose86@gmail.com", "email_verified": true, "phone_verified": false}', 'email', '2026-07-14 11:52:47.537569+00', '2026-07-14 11:52:47.537621+00', '2026-07-14 11:52:47.537621+00', '4d56b9cf-b1e2-4e44-9faf-144d5b2014e1');


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
	('de6b3790-20df-471a-9d92-6cd7f6709480', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-11 20:30:31.247112+00', '2026-07-12 07:38:29.498795+00', NULL, 'aal1', NULL, '2026-07-12 07:38:29.49869', 'Mozilla/5.0 (Linux; Android 10; Infinix X655 Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/150.0.7871.46 Mobile Safari/537.36', '102.90.98.112', NULL, NULL, NULL, NULL, NULL),
	('8817ec22-92c1-41a8-9869-7e1a9515169a', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-06 17:52:06.175948+00', '2026-07-06 17:52:06.175948+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '102.90.102.73', NULL, NULL, NULL, NULL, NULL),
	('1c4e7c17-46f9-4f7f-a023-3b74f3da83f5', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-12 13:14:28.503054+00', '2026-07-12 13:14:28.503054+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; Infinix X655 Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/150.0.7871.46 Mobile Safari/537.36', '102.90.103.3', NULL, NULL, NULL, NULL, NULL),
	('675ac472-8824-40df-aec5-da8c40af5d52', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-13 09:49:30.110038+00', '2026-07-13 09:49:30.110038+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; Infinix X655 Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/150.0.7871.46 Mobile Safari/537.36', '102.90.98.204', NULL, NULL, NULL, NULL, NULL),
	('11fc1d32-57a9-406a-b5e8-d7c0066256d9', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-13 10:11:09.718106+00', '2026-07-13 10:11:09.718106+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; Infinix X655 Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/150.0.7871.46 Mobile Safari/537.36', '102.90.98.204', NULL, NULL, NULL, NULL, NULL),
	('b245c962-ccab-40cb-a47c-003d59d24aaf', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-13 10:44:37.440283+00', '2026-07-13 10:44:37.440283+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; Infinix X655 Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/150.0.7871.46 Mobile Safari/537.36', '102.90.98.204', NULL, NULL, NULL, NULL, NULL),
	('732d7a59-cf87-4e53-a734-6f5f2e6161ab', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-13 11:12:02.116974+00', '2026-07-13 11:12:02.116974+00', NULL, 'aal1', NULL, NULL, 'Mozilla/5.0 (Linux; Android 10; Infinix X655 Build/QP1A.190711.020; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/150.0.7871.46 Mobile Safari/537.36', '102.90.98.204', NULL, NULL, NULL, NULL, NULL),
	('63ed7704-1356-40b7-bc7a-797ae70878d7', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-11 12:10:16.701968+00', '2026-07-13 11:18:41.938591+00', NULL, 'aal1', NULL, '2026-07-13 11:18:41.938488', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/149.0.0.0 Mobile Safari/537.36', '102.90.98.204', NULL, NULL, NULL, NULL, NULL),
	('6a88cd7c-7f92-4174-95f1-1766f3ae8060', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', '2026-07-14 11:53:31.394192+00', '2026-07-14 12:54:30.344986+00', NULL, 'aal1', NULL, '2026-07-14 12:54:30.344874', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '105.116.10.139', NULL, NULL, NULL, NULL, NULL),
	('6d7e5c5a-cc77-4b65-92bf-c447bb323e19', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-18 08:06:58.825087+00', '2026-07-18 09:21:01.897195+00', NULL, 'aal1', NULL, '2026-07-18 09:21:01.897087', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '102.90.97.97', NULL, NULL, NULL, NULL, NULL),
	('73ef5609-cc1c-4c19-b245-5ac134f126e7', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-19 17:54:13.520932+00', '2026-07-28 11:22:27.13444+00', NULL, 'aal1', NULL, '2026-07-28 11:22:27.132475', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/144.0.0.0 Safari/537.36', '102.90.81.28', NULL, NULL, NULL, NULL, NULL);


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

INSERT INTO "auth"."mfa_amr_claims" ("session_id", "created_at", "updated_at", "authentication_method", "id") VALUES
	('8817ec22-92c1-41a8-9869-7e1a9515169a', '2026-07-06 17:52:06.219562+00', '2026-07-06 17:52:06.219562+00', 'otp', '1274b27e-ece6-421f-8264-84d41e5d1427'),
	('63ed7704-1356-40b7-bc7a-797ae70878d7', '2026-07-11 12:10:16.722429+00', '2026-07-11 12:10:16.722429+00', 'password', 'f92776d7-46b6-40de-9f9c-7ff3047056be'),
	('de6b3790-20df-471a-9d92-6cd7f6709480', '2026-07-11 20:30:31.29294+00', '2026-07-11 20:30:31.29294+00', 'password', '61ed0824-7449-4901-96b7-ec62a9437be4'),
	('1c4e7c17-46f9-4f7f-a023-3b74f3da83f5', '2026-07-12 13:14:28.581585+00', '2026-07-12 13:14:28.581585+00', 'password', '7a00322f-eb88-4d36-86d7-beb33e71d87b'),
	('675ac472-8824-40df-aec5-da8c40af5d52', '2026-07-13 09:49:30.172441+00', '2026-07-13 09:49:30.172441+00', 'password', 'e8b6b15a-d51f-452d-8f9b-a96659b3dd07'),
	('11fc1d32-57a9-406a-b5e8-d7c0066256d9', '2026-07-13 10:11:09.796531+00', '2026-07-13 10:11:09.796531+00', 'password', '1cb291b2-1ca6-4ef7-8f0e-5a4347f48710'),
	('b245c962-ccab-40cb-a47c-003d59d24aaf', '2026-07-13 10:44:37.495015+00', '2026-07-13 10:44:37.495015+00', 'password', '53ff0c9a-45b0-46e3-9780-e96e50f6fa02'),
	('732d7a59-cf87-4e53-a734-6f5f2e6161ab', '2026-07-13 11:12:02.157015+00', '2026-07-13 11:12:02.157015+00', 'password', 'dfb03607-6397-42ac-b698-1c244f4e48a9'),
	('6a88cd7c-7f92-4174-95f1-1766f3ae8060', '2026-07-14 11:53:31.422644+00', '2026-07-14 11:53:31.422644+00', 'otp', '0a9e521a-24c3-421c-abb6-17c90088419d'),
	('6d7e5c5a-cc77-4b65-92bf-c447bb323e19', '2026-07-18 08:06:58.891285+00', '2026-07-18 08:06:58.891285+00', 'password', '9ea2c084-ddcc-4288-ab4f-d6b1f100a648'),
	('73ef5609-cc1c-4c19-b245-5ac134f126e7', '2026-07-19 17:54:13.590176+00', '2026-07-19 17:54:13.590176+00', 'password', '472e200b-c319-4bf1-8d45-157f9f9237ee');


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
	('00000000-0000-0000-0000-000000000000', 68, 'tl76kxlvqwsw', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', true, '2026-07-11 14:33:24.961222+00', '2026-07-11 16:09:00.51354+00', 'vubyib26ueoc', '63ed7704-1356-40b7-bc7a-797ae70878d7'),
	('00000000-0000-0000-0000-000000000000', 70, 'vz26b4d3wkzq', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', true, '2026-07-11 16:09:00.534098+00', '2026-07-11 19:22:03.822297+00', 'tl76kxlvqwsw', '63ed7704-1356-40b7-bc7a-797ae70878d7'),
	('00000000-0000-0000-0000-000000000000', 72, 'to4ugzmvi3wc', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', true, '2026-07-11 20:30:31.269603+00', '2026-07-12 07:38:29.454902+00', NULL, 'de6b3790-20df-471a-9d92-6cd7f6709480'),
	('00000000-0000-0000-0000-000000000000', 73, '72iplr4ipqej', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, '2026-07-12 07:38:29.471954+00', '2026-07-12 07:38:29.471954+00', 'to4ugzmvi3wc', 'de6b3790-20df-471a-9d92-6cd7f6709480'),
	('00000000-0000-0000-0000-000000000000', 74, 'desku54a7m3c', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', false, '2026-07-12 13:14:28.539202+00', '2026-07-12 13:14:28.539202+00', NULL, '1c4e7c17-46f9-4f7f-a023-3b74f3da83f5'),
	('00000000-0000-0000-0000-000000000000', 75, 'j2hloxlosxqm', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, '2026-07-13 09:49:30.14194+00', '2026-07-13 09:49:30.14194+00', NULL, '675ac472-8824-40df-aec5-da8c40af5d52'),
	('00000000-0000-0000-0000-000000000000', 76, 'fq5ypwqmom2n', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, '2026-07-13 10:11:09.759445+00', '2026-07-13 10:11:09.759445+00', NULL, '11fc1d32-57a9-406a-b5e8-d7c0066256d9'),
	('00000000-0000-0000-0000-000000000000', 77, '2jzchn7jtgya', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, '2026-07-13 10:44:37.467093+00', '2026-07-13 10:44:37.467093+00', NULL, 'b245c962-ccab-40cb-a47c-003d59d24aaf'),
	('00000000-0000-0000-0000-000000000000', 78, 'yb3iitapsxhj', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, '2026-07-13 11:12:02.138833+00', '2026-07-13 11:12:02.138833+00', NULL, '732d7a59-cf87-4e53-a734-6f5f2e6161ab'),
	('00000000-0000-0000-0000-000000000000', 71, 'jriaxolwbux4', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', true, '2026-07-11 19:22:03.841652+00', '2026-07-13 11:18:41.914412+00', 'vz26b4d3wkzq', '63ed7704-1356-40b7-bc7a-797ae70878d7'),
	('00000000-0000-0000-0000-000000000000', 79, 'dcjcq6piwngw', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', false, '2026-07-13 11:18:41.921445+00', '2026-07-13 11:18:41.921445+00', 'jriaxolwbux4', '63ed7704-1356-40b7-bc7a-797ae70878d7'),
	('00000000-0000-0000-0000-000000000000', 45, 'cxjbgpadjb4g', '2bb13930-2533-4c22-8da4-ebcf89d41b89', false, '2026-07-06 17:52:06.19972+00', '2026-07-06 17:52:06.19972+00', NULL, '8817ec22-92c1-41a8-9869-7e1a9515169a'),
	('00000000-0000-0000-0000-000000000000', 80, 'ruh5lykp4aqt', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', true, '2026-07-14 11:53:31.40571+00', '2026-07-14 12:54:30.306615+00', NULL, '6a88cd7c-7f92-4174-95f1-1766f3ae8060'),
	('00000000-0000-0000-0000-000000000000', 81, 'firkpegxjtjx', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', false, '2026-07-14 12:54:30.323861+00', '2026-07-14 12:54:30.323861+00', 'ruh5lykp4aqt', '6a88cd7c-7f92-4174-95f1-1766f3ae8060'),
	('00000000-0000-0000-0000-000000000000', 82, 'zssqg2grw4yt', '2bb13930-2533-4c22-8da4-ebcf89d41b89', true, '2026-07-18 08:06:58.859156+00', '2026-07-18 09:21:01.850973+00', NULL, '6d7e5c5a-cc77-4b65-92bf-c447bb323e19'),
	('00000000-0000-0000-0000-000000000000', 83, 'ggdlznwfeqlp', '2bb13930-2533-4c22-8da4-ebcf89d41b89', false, '2026-07-18 09:21:01.871231+00', '2026-07-18 09:21:01.871231+00', 'zssqg2grw4yt', '6d7e5c5a-cc77-4b65-92bf-c447bb323e19'),
	('00000000-0000-0000-0000-000000000000', 84, 'j5zj7smhh4ij', '2bb13930-2533-4c22-8da4-ebcf89d41b89', true, '2026-07-19 17:54:13.553854+00', '2026-07-28 11:22:27.096286+00', NULL, '73ef5609-cc1c-4c19-b245-5ac134f126e7'),
	('00000000-0000-0000-0000-000000000000', 85, 'sxwphvju6tw3', '2bb13930-2533-4c22-8da4-ebcf89d41b89', false, '2026-07-28 11:22:27.11146+00', '2026-07-28 11:22:27.11146+00', 'j5zj7smhh4ij', '73ef5609-cc1c-4c19-b245-5ac134f126e7'),
	('00000000-0000-0000-0000-000000000000', 66, 'vubyib26ueoc', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', true, '2026-07-11 12:10:16.714838+00', '2026-07-11 14:33:24.944291+00', NULL, '63ed7704-1356-40b7-bc7a-797ae70878d7');


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
-- Data for Name: app_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."app_info" ("id", "creator_name", "email", "tiktok") VALUES
	(1, 'Greatman Nyenwe', 'dgreatnation83@gmail.com', 'tiktok.com/@officialdgreatverse');


--
-- Data for Name: app_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."users" ("id", "name", "email", "chat_code", "avatar_url", "about", "created_at", "avatar_public_id") VALUES
	('bd8fb801-d0c7-4381-90b5-343e5c538a32', 'DGREAT', 'dgreatman1234@gmail.com', 'W4KKY-7CDZG', 'https://res.cloudinary.com/fwgk9xow/image/upload/v1783324196/rilioq7gjzlawbtey1bw.png', 'Hey there! I am using DgreatVerse.', '2026-07-04 11:35:31.344047+00', 'rilioq7gjzlawbtey1bw'),
	('7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Owner', 'agent345345@gmail.com', '2DZTF-VDNXU', 'https://res.cloudinary.com/fwgk9xow/image/upload/v1783356554/jihe8idpnfqpeujp8cdd.png', 'Hey there! I am using DgreatVerse.', '2026-07-06 10:26:35.737711+00', 'jihe8idpnfqpeujp8cdd'),
	('2bb13930-2533-4c22-8da4-ebcf89d41b89', 'Dr Nyenwe emem', 'ememprince82@gmail.com', 'HNBMA-PXFE9', NULL, 'Hey there! I am using DgreatVerse.', '2026-07-06 17:52:08.215712+00', NULL),
	('18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', 'Queen', 'queenjose86@gmail.com', 'Z4ZFY-XTDSZ', NULL, 'Hey there! I am using DgreatVerse.', '2026-07-14 11:53:33.647451+00', NULL);


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
	('636c693e-45d3-4940-8e6d-120156600e24', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '😁', NULL, 'text', NULL, NULL, '2026-07-11 10:03:59.958266+00', NULL, false, NULL),
	('6ff22dcd-2516-4012-be81-40c322bf4008', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'U there', NULL, 'text', NULL, NULL, '2026-07-11 12:06:57.191506+00', NULL, false, NULL),
	('9e45d9fb-e474-46f0-8b06-b846b9a2f59c', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Hi', NULL, 'text', NULL, NULL, '2026-07-11 12:10:35.814308+00', NULL, false, '2026-07-12 12:10:34.423+00'),
	('b9ca1a43-e2eb-41e5-87be-850e46a773c1', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hi', NULL, 'text', NULL, NULL, '2026-07-11 12:11:14.863691+00', NULL, false, NULL),
	('0bf9b6c2-8a59-45cb-beb4-a9795c04e224', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Sup', NULL, 'text', NULL, NULL, '2026-07-11 12:11:30.677324+00', NULL, false, '2026-07-12 12:11:29.468+00'),
	('6a4e3838-4dd6-42ab-b829-96225d71eb89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'Sup', NULL, 'text', NULL, NULL, '2026-07-11 12:11:44.828136+00', NULL, false, '2026-07-12 12:11:43.619+00'),
	('2a7310e7-a8f5-4f7e-b5f0-07a169c2ee3d', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'U thet', NULL, 'text', NULL, NULL, '2026-07-11 12:12:14.935015+00', NULL, false, NULL),
	('0ef8129b-b6c7-47db-8000-cbb2de62832b', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'I dey', NULL, 'text', NULL, NULL, '2026-07-11 12:12:27.538303+00', NULL, false, '2026-07-12 12:12:26.319+00'),
	('740b3ef4-92e5-4863-974b-40cdb64da3ca', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'What''s up', NULL, 'text', NULL, NULL, '2026-07-13 11:19:26.04513+00', NULL, false, '2026-07-14 11:19:24.535+00'),
	('2c63866f-4275-43a4-b4ad-cc3719d164c7', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hi', NULL, 'text', NULL, NULL, '2026-07-13 11:21:58.477962+00', NULL, false, NULL),
	('6440b82e-b887-480c-9a4f-3fea75e6f8f6', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'I good', NULL, 'text', NULL, NULL, '2026-07-13 11:22:16.848583+00', NULL, false, '2026-07-14 11:22:15.497+00'),
	('59bb407c-8384-4ee5-ab56-ec9521a2d326', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hi', NULL, 'text', NULL, NULL, '2026-07-18 08:07:20.723575+00', NULL, false, NULL),
	('df149b90-4592-4c2f-a8fe-20e9aa9826dc', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'Hi😟😤😝😭', NULL, 'text', NULL, NULL, '2026-07-28 11:23:23.987268+00', NULL, false, NULL);


--
-- Data for Name: comments; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: contact_settings; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."contact_settings" ("id", "owner_id", "contact_id", "archived", "hidden", "hide_pin", "blocked", "disappear_seconds", "created_at", "updated_at", "cleared_before") VALUES
	('1d073e95-772a-46a8-ad9a-494c4b2c5de6', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', false, false, NULL, false, 86400, '2026-07-06 14:33:48.353297+00', '2026-07-06 14:33:48.353297+00', NULL),
	('eb8c39af-5e3b-4f17-861a-69d40be14ccb', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', false, true, '1234', false, 0, '2026-07-12 13:16:15.895519+00', '2026-07-12 13:16:15.895519+00', NULL),
	('b1b0ab8c-4bb1-477d-a41f-bcd8d9b5be50', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', false, false, NULL, false, 0, '2026-07-06 12:19:13.530859+00', '2026-07-06 12:19:13.530859+00', NULL),
	('aa665b36-8684-4034-9d31-b215350abda8', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', false, false, NULL, false, 0, '2026-07-18 08:07:44.887354+00', '2026-07-18 08:07:44.887354+00', NULL);


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
	('30fc57f3-8976-4d31-87de-4ba3016cff7d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', '2026-07-13 11:22:16.414+00'),
	('0000ce4e-fda1-48a6-8ce8-7406e98c09f2', '7b4fe7f5-3a78-4e8f-896c-ced82f85138d', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-13 11:22:17.002+00'),
	('7d1d0dbc-af1f-4909-b307-2ff40a3843d0', '2bb13930-2533-4c22-8da4-ebcf89d41b89', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2026-07-28 11:23:24.765+00'),
	('6c0266a8-af3f-4b36-aa5b-2a27d84c9320', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', '2bb13930-2533-4c22-8da4-ebcf89d41b89', '2026-07-12 13:16:02.607+00');


--
-- Data for Name: push_subscriptions; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."push_subscriptions" ("id", "user_id", "endpoint", "p256dh", "auth", "created_at") VALUES
	('933b1961-0394-4c09-ad3d-653fde39abf1', 'bd8fb801-d0c7-4381-90b5-343e5c538a32', 'https://fcm.googleapis.com/fcm/send/fgzsiDOq6O0:APA91bFZ6Xa0-qeN0G8voQy0qoeiD6eQglxYT7JY15ejKogSR60Y8-R7wGO1PkSg1eCI8vGkvb6nnErrDHPSXdsmSq1tgDkUrCgDJNpRUrM5jkHyKUJwftvLUdCtsaIjQarPGCdGW0mc', 'BKM24nBFvqN_CNnACDW2kt5aJAk106oAKyD2zCwSZdWiTA-AZDAQeR3NNkY2bDjOMDBdRFMc5M71BQneogXvEQY', 'PtGKZPjwV4inODYqMIe02g', '2026-07-06 22:42:40.352044+00'),
	('e791d8bc-2b3a-4d8f-8aea-a12467c21535', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', 'https://fcm.googleapis.com/fcm/send/cUl7xWoMXEs:APA91bH2L71yOXV3TL1ETRrkLH2fK6QyHHTXFzFzJQ1AbQEM2uIatoPiqQmAb-nooy6x0W3vHFzswa7H_UdEyGalSW5wszqukjvs6eiO4MdjGu0G889T-9w8PlizqkvjutCd1zMYLoIC', 'BJG96s2Tje8mv-rdHDX54sVmFrrLb1V6hn568c050LTH8Z5CdIrGxLlVBn_Vqcmm6La0NDj0iWFEKMUFl8cjLSo', '28J0sScD8CEIg1iefy1cXQ', '2026-07-14 11:53:57.907861+00');


--
-- Data for Name: status_exclusions; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: stories; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."stories" ("id", "user_id", "media_url", "media_type", "caption", "created_at", "expires_at", "public_id") VALUES
	('59016c7a-0b4f-4e03-bf8f-cfe7aebd8cd0', '18c62b9f-9666-4ba1-a2ef-71d8c1a3b352', 'https://res.cloudinary.com/fwgk9xow/image/upload/v1784030141/cveqe2drenvorkqepugb.png', 'image', NULL, '2026-07-14 11:55:42.034535+00', '2026-07-15 11:55:40.31+00', 'cveqe2drenvorkqepugb');


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
	(17, 17660, 'send_notification_on_new_message', '2026-07-11 10:03:59.958266+00', 1428),
	(18, 17660, 'send_notification_on_new_message', '2026-07-11 12:06:57.191506+00', 1454),
	(19, 17660, 'send_notification_on_new_message', '2026-07-11 12:10:35.814308+00', 1456),
	(20, 17660, 'send_notification_on_new_message', '2026-07-11 12:11:14.863691+00', 1457),
	(21, 17660, 'send_notification_on_new_message', '2026-07-11 12:11:30.677324+00', 1458),
	(22, 17660, 'send_notification_on_new_message', '2026-07-11 12:11:44.828136+00', 1459),
	(23, 17660, 'send_notification_on_new_message', '2026-07-11 12:12:14.935015+00', 1460),
	(24, 17660, 'send_notification_on_new_message', '2026-07-11 12:12:27.538303+00', 1461),
	(25, 17660, 'send_notification_on_new_message', '2026-07-13 11:19:26.04513+00', 2031),
	(26, 17660, 'send_notification_on_new_message', '2026-07-13 11:21:58.477962+00', 2033),
	(27, 17660, 'send_notification_on_new_message', '2026-07-13 11:22:16.848583+00', 2034),
	(28, 17660, 'send_notification_on_new_message', '2026-07-18 08:07:20.723575+00', 3446),
	(29, 17660, 'send_notification_on_new_message', '2026-07-28 11:23:23.987268+00', 6386);


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('"auth"."refresh_tokens_id_seq"', 85, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('"supabase_functions"."hooks_id_seq"', 29, true);


--
-- PostgreSQL database dump complete
--

-- \unrestrict n6KRqhGqLBX4dZvf6d6BqNsWb2UWhqK3uElcFfayqaFPzScTyRayXIHuYic8aip

RESET ALL;
