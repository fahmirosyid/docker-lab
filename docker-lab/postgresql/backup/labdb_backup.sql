--
-- PostgreSQL database dump
--

\restrict DRLlCFS9kfVCkMCvHZlg02ke7DRhQcEpdlVbnkij1cUR0CKFCgwpb9dJouSAXue

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

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

--
-- Name: app; Type: SCHEMA; Schema: -; Owner: labuser
--

CREATE SCHEMA app;


ALTER SCHEMA app OWNER TO labuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_log; Type: TABLE; Schema: app; Owner: labuser
--

CREATE TABLE app.activity_log (
    id bigint NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    level character varying(10) DEFAULT 'INFO'::character varying,
    source character varying(50),
    message text,
    metadata jsonb
);


ALTER TABLE app.activity_log OWNER TO labuser;

--
-- Name: activity_log_id_seq; Type: SEQUENCE; Schema: app; Owner: labuser
--

CREATE SEQUENCE app.activity_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE app.activity_log_id_seq OWNER TO labuser;

--
-- Name: activity_log_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: labuser
--

ALTER SEQUENCE app.activity_log_id_seq OWNED BY app.activity_log.id;


--
-- Name: mahasiswa; Type: TABLE; Schema: app; Owner: labuser
--

CREATE TABLE app.mahasiswa (
    id integer NOT NULL,
    nrp character varying(15) NOT NULL,
    nama character varying(100) NOT NULL,
    kelas character(1),
    kelompok integer,
    email character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT mahasiswa_kelas_check CHECK ((kelas = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar]))),
    CONSTRAINT mahasiswa_kelompok_check CHECK (((kelompok >= 1) AND (kelompok <= 10)))
);


ALTER TABLE app.mahasiswa OWNER TO labuser;

--
-- Name: mahasiswa_id_seq; Type: SEQUENCE; Schema: app; Owner: labuser
--

CREATE SEQUENCE app.mahasiswa_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE app.mahasiswa_id_seq OWNER TO labuser;

--
-- Name: mahasiswa_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: labuser
--

ALTER SEQUENCE app.mahasiswa_id_seq OWNED BY app.mahasiswa.id;


--
-- Name: matakuliah; Type: TABLE; Schema: app; Owner: labuser
--

CREATE TABLE app.matakuliah (
    id integer NOT NULL,
    kode character varying(10) NOT NULL,
    nama character varying(100) NOT NULL,
    sks integer,
    CONSTRAINT matakuliah_sks_check CHECK (((sks >= 1) AND (sks <= 6)))
);


ALTER TABLE app.matakuliah OWNER TO labuser;

--
-- Name: matakuliah_id_seq; Type: SEQUENCE; Schema: app; Owner: labuser
--

CREATE SEQUENCE app.matakuliah_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE app.matakuliah_id_seq OWNER TO labuser;

--
-- Name: matakuliah_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: labuser
--

ALTER SEQUENCE app.matakuliah_id_seq OWNED BY app.matakuliah.id;


--
-- Name: nilai; Type: TABLE; Schema: app; Owner: labuser
--

CREATE TABLE app.nilai (
    id integer NOT NULL,
    mahasiswa_id integer,
    matakuliah_id integer,
    nilai_angka numeric(5,2),
    grade character(2),
    semester character varying(10),
    CONSTRAINT nilai_nilai_angka_check CHECK (((nilai_angka >= (0)::numeric) AND (nilai_angka <= (100)::numeric)))
);


ALTER TABLE app.nilai OWNER TO labuser;

--
-- Name: nilai_id_seq; Type: SEQUENCE; Schema: app; Owner: labuser
--

CREATE SEQUENCE app.nilai_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE app.nilai_id_seq OWNER TO labuser;

--
-- Name: nilai_id_seq; Type: SEQUENCE OWNED BY; Schema: app; Owner: labuser
--

ALTER SEQUENCE app.nilai_id_seq OWNED BY app.nilai.id;


--
-- Name: activity_log id; Type: DEFAULT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.activity_log ALTER COLUMN id SET DEFAULT nextval('app.activity_log_id_seq'::regclass);


--
-- Name: mahasiswa id; Type: DEFAULT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.mahasiswa ALTER COLUMN id SET DEFAULT nextval('app.mahasiswa_id_seq'::regclass);


--
-- Name: matakuliah id; Type: DEFAULT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.matakuliah ALTER COLUMN id SET DEFAULT nextval('app.matakuliah_id_seq'::regclass);


--
-- Name: nilai id; Type: DEFAULT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.nilai ALTER COLUMN id SET DEFAULT nextval('app.nilai_id_seq'::regclass);


--
-- Data for Name: activity_log; Type: TABLE DATA; Schema: app; Owner: labuser
--

COPY app.activity_log (id, "timestamp", level, source, message, metadata) FROM stdin;
\.


--
-- Data for Name: mahasiswa; Type: TABLE DATA; Schema: app; Owner: labuser
--

COPY app.mahasiswa (id, nrp, nama, kelas, kelompok, email, created_at) FROM stdin;
1	3122600001	Ahmad Fauzi	A	1	ahmad@student.pens.ac.id	2026-05-10 16:49:40.331798
2	3122600002	Budi Santoso	A	1	budi@student.pens.ac.id	2026-05-10 16:49:40.331798
3	3122600003	Citra Dewi	B	2	citra@student.pens.ac.id	2026-05-10 16:49:40.331798
4	3122600004	Dian Pratama	B	2	dian@student.pens.ac.id	2026-05-10 16:49:40.331798
5	3122600005	Eka Putra	C	3	eka@student.pens.ac.id	2026-05-10 16:49:40.331798
\.


--
-- Data for Name: matakuliah; Type: TABLE DATA; Schema: app; Owner: labuser
--

COPY app.matakuliah (id, kode, nama, sks) FROM stdin;
1	JAR01	Administrasi Jaringan	3
2	SBD01	Sistem Basis Data	3
3	SO01	Sistem Operasi	2
4	WEB01	Pemrograman Web	3
\.


--
-- Data for Name: nilai; Type: TABLE DATA; Schema: app; Owner: labuser
--

COPY app.nilai (id, mahasiswa_id, matakuliah_id, nilai_angka, grade, semester) FROM stdin;
1	1	1	85.50	A 	2025-1
2	1	2	78.00	B+	2025-1
3	2	1	92.00	A 	2025-1
4	3	1	70.25	B 	2025-1
5	4	3	88.75	A 	2025-1
\.


--
-- Name: activity_log_id_seq; Type: SEQUENCE SET; Schema: app; Owner: labuser
--

SELECT pg_catalog.setval('app.activity_log_id_seq', 1, false);


--
-- Name: mahasiswa_id_seq; Type: SEQUENCE SET; Schema: app; Owner: labuser
--

SELECT pg_catalog.setval('app.mahasiswa_id_seq', 33, true);


--
-- Name: matakuliah_id_seq; Type: SEQUENCE SET; Schema: app; Owner: labuser
--

SELECT pg_catalog.setval('app.matakuliah_id_seq', 33, true);


--
-- Name: nilai_id_seq; Type: SEQUENCE SET; Schema: app; Owner: labuser
--

SELECT pg_catalog.setval('app.nilai_id_seq', 33, true);


--
-- Name: activity_log activity_log_pkey; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.activity_log
    ADD CONSTRAINT activity_log_pkey PRIMARY KEY (id);


--
-- Name: mahasiswa mahasiswa_nrp_key; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.mahasiswa
    ADD CONSTRAINT mahasiswa_nrp_key UNIQUE (nrp);


--
-- Name: mahasiswa mahasiswa_pkey; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.mahasiswa
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (id);


--
-- Name: matakuliah matakuliah_kode_key; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.matakuliah
    ADD CONSTRAINT matakuliah_kode_key UNIQUE (kode);


--
-- Name: matakuliah matakuliah_pkey; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.matakuliah
    ADD CONSTRAINT matakuliah_pkey PRIMARY KEY (id);


--
-- Name: nilai nilai_mahasiswa_id_matakuliah_id_semester_key; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.nilai
    ADD CONSTRAINT nilai_mahasiswa_id_matakuliah_id_semester_key UNIQUE (mahasiswa_id, matakuliah_id, semester);


--
-- Name: nilai nilai_pkey; Type: CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.nilai
    ADD CONSTRAINT nilai_pkey PRIMARY KEY (id);


--
-- Name: idx_activity_log_level; Type: INDEX; Schema: app; Owner: labuser
--

CREATE INDEX idx_activity_log_level ON app.activity_log USING btree (level);


--
-- Name: idx_activity_log_metadata; Type: INDEX; Schema: app; Owner: labuser
--

CREATE INDEX idx_activity_log_metadata ON app.activity_log USING gin (metadata);


--
-- Name: idx_activity_log_timestamp; Type: INDEX; Schema: app; Owner: labuser
--

CREATE INDEX idx_activity_log_timestamp ON app.activity_log USING btree ("timestamp");


--
-- Name: idx_mahasiswa_kelas; Type: INDEX; Schema: app; Owner: labuser
--

CREATE INDEX idx_mahasiswa_kelas ON app.mahasiswa USING btree (kelas);


--
-- Name: idx_mahasiswa_nrp; Type: INDEX; Schema: app; Owner: labuser
--

CREATE INDEX idx_mahasiswa_nrp ON app.mahasiswa USING btree (nrp);


--
-- Name: idx_nilai_semester; Type: INDEX; Schema: app; Owner: labuser
--

CREATE INDEX idx_nilai_semester ON app.nilai USING btree (semester);


--
-- Name: nilai nilai_mahasiswa_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.nilai
    ADD CONSTRAINT nilai_mahasiswa_id_fkey FOREIGN KEY (mahasiswa_id) REFERENCES app.mahasiswa(id) ON DELETE CASCADE;


--
-- Name: nilai nilai_matakuliah_id_fkey; Type: FK CONSTRAINT; Schema: app; Owner: labuser
--

ALTER TABLE ONLY app.nilai
    ADD CONSTRAINT nilai_matakuliah_id_fkey FOREIGN KEY (matakuliah_id) REFERENCES app.matakuliah(id) ON DELETE CASCADE;


--
-- Name: SCHEMA app; Type: ACL; Schema: -; Owner: labuser
--

GRANT USAGE ON SCHEMA app TO app_reader;


--
-- Name: TABLE activity_log; Type: ACL; Schema: app; Owner: labuser
--

GRANT SELECT ON TABLE app.activity_log TO app_reader;


--
-- Name: TABLE mahasiswa; Type: ACL; Schema: app; Owner: labuser
--

GRANT SELECT ON TABLE app.mahasiswa TO app_reader;


--
-- Name: TABLE matakuliah; Type: ACL; Schema: app; Owner: labuser
--

GRANT SELECT ON TABLE app.matakuliah TO app_reader;


--
-- Name: TABLE nilai; Type: ACL; Schema: app; Owner: labuser
--

GRANT SELECT ON TABLE app.nilai TO app_reader;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: app; Owner: labuser
--

ALTER DEFAULT PRIVILEGES FOR ROLE labuser IN SCHEMA app GRANT SELECT ON TABLES TO app_reader;


--
-- PostgreSQL database dump complete
--

\unrestrict DRLlCFS9kfVCkMCvHZlg02ke7DRhQcEpdlVbnkij1cUR0CKFCgwpb9dJouSAXue

