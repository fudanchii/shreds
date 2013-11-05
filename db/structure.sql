--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: feeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE feeds (
    id integer NOT NULL,
    url text NOT NULL,
    meta text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    category_id integer,
    feed_url text
);


--
-- Name: feeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE feeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: feeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE feeds_id_seq OWNED BY feeds.id;


--
-- Name: itemhashes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE itemhashes (
    id integer NOT NULL,
    urlhash character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: itemhashes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE itemhashes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: itemhashes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE itemhashes_id_seq OWNED BY itemhashes.id;


--
-- Name: newsitems; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE newsitems (
    id integer NOT NULL,
    permalink text,
    unread boolean DEFAULT true,
    feed_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    content text,
    author text,
    title text,
    published timestamp without time zone DEFAULT now() NOT NULL,
    summary text
);


--
-- Name: newsitems_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE newsitems_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: newsitems_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE newsitems_id_seq OWNED BY newsitems.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY feeds ALTER COLUMN id SET DEFAULT nextval('feeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY itemhashes ALTER COLUMN id SET DEFAULT nextval('itemhashes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsitems ALTER COLUMN id SET DEFAULT nextval('newsitems_id_seq'::regclass);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: itemhashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY itemhashes
    ADD CONSTRAINT itemhashes_pkey PRIMARY KEY (id);


--
-- Name: newsitems_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY newsitems
    ADD CONSTRAINT newsitems_pkey PRIMARY KEY (id);


--
-- Name: index_feeds_on_category_id_and_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_feeds_on_category_id_and_id ON feeds USING btree (category_id, id);


--
-- Name: index_feeds_on_feed_url; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_feeds_on_feed_url ON feeds USING btree (feed_url);


--
-- Name: index_itemhashes_on_urlhash; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_itemhashes_on_urlhash ON itemhashes USING btree (urlhash);


--
-- Name: index_newsitems_on_feed_id_and_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_newsitems_on_feed_id_and_id ON newsitems USING btree (feed_id, id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20130314095131');

INSERT INTO schema_migrations (version) VALUES ('20130315070325');

INSERT INTO schema_migrations (version) VALUES ('20130328071422');

INSERT INTO schema_migrations (version) VALUES ('20130328072452');

INSERT INTO schema_migrations (version) VALUES ('20130601080434');

INSERT INTO schema_migrations (version) VALUES ('20130601103759');

INSERT INTO schema_migrations (version) VALUES ('20130601104234');

INSERT INTO schema_migrations (version) VALUES ('20130601165823');

INSERT INTO schema_migrations (version) VALUES ('20130602085609');

INSERT INTO schema_migrations (version) VALUES ('20130609103401');

INSERT INTO schema_migrations (version) VALUES ('20130615083726');

INSERT INTO schema_migrations (version) VALUES ('20130615131116');

INSERT INTO schema_migrations (version) VALUES ('20130629061243');

INSERT INTO schema_migrations (version) VALUES ('20130727063916');

INSERT INTO schema_migrations (version) VALUES ('20130802224642');

INSERT INTO schema_migrations (version) VALUES ('20130914184411');

INSERT INTO schema_migrations (version) VALUES ('20130915064117');

INSERT INTO schema_migrations (version) VALUES ('20130915203217');

INSERT INTO schema_migrations (version) VALUES ('20131019025806');

INSERT INTO schema_migrations (version) VALUES ('20131023135940');

INSERT INTO schema_migrations (version) VALUES ('20131105101218');
