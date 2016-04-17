--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

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
-- Name: articles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE articles (
    id integer NOT NULL,
    permalink text,
    content text,
    author text,
    title text,
    published timestamp without time zone DEFAULT now() NOT NULL,
    summary text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    feed_id integer
);


--
-- Name: articles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE articles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: articles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE articles_id_seq OWNED BY articles.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying,
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
-- Name: entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE entries (
    id integer NOT NULL,
    subscription_id integer,
    newsitem_id integer,
    unread boolean DEFAULT true,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    article_id integer
);


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE entries_id_seq OWNED BY entries.id;


--
-- Name: feeds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE feeds (
    id integer NOT NULL,
    url text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    feed_url text,
    title text DEFAULT '( Untitled )'::text NOT NULL,
    etag character varying,
    last_status character varying
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
-- Name: feeds_subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE feeds_subscriptions (
    feed_id integer,
    subscription_id integer
);


--
-- Name: itemhashes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE itemhashes (
    id integer NOT NULL,
    urlhash character varying NOT NULL,
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
-- Name: newsitems; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE newsitems (
    id integer NOT NULL,
    permalink text,
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
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    user_id integer,
    category_id integer,
    feed_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    username character varying,
    email character varying,
    uid character varying,
    provider character varying,
    token character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles ALTER COLUMN id SET DEFAULT nextval('articles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries ALTER COLUMN id SET DEFAULT nextval('entries_id_seq'::regclass);


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
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: articles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: feeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY feeds
    ADD CONSTRAINT feeds_pkey PRIMARY KEY (id);


--
-- Name: itemhashes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY itemhashes
    ADD CONSTRAINT itemhashes_pkey PRIMARY KEY (id);


--
-- Name: newsitems_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY newsitems
    ADD CONSTRAINT newsitems_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_articles_on_feed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_articles_on_feed_id ON articles USING btree (feed_id);


--
-- Name: index_categories_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_on_name ON categories USING btree (name);


--
-- Name: index_entries_on_article_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_article_id ON entries USING btree (article_id);


--
-- Name: index_entries_on_newsitem_id_and_subscription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_entries_on_newsitem_id_and_subscription_id ON entries USING btree (newsitem_id, subscription_id);


--
-- Name: index_entries_on_unread; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_entries_on_unread ON entries USING btree (unread) WHERE unread;


--
-- Name: index_feeds_on_feed_url; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_feeds_on_feed_url ON feeds USING btree (feed_url);


--
-- Name: index_feeds_subscriptions_on_feed_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feeds_subscriptions_on_feed_id ON feeds_subscriptions USING btree (feed_id);


--
-- Name: index_feeds_subscriptions_on_subscription_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_feeds_subscriptions_on_subscription_id ON feeds_subscriptions USING btree (subscription_id);


--
-- Name: index_itemhashes_on_urlhash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_itemhashes_on_urlhash ON itemhashes USING btree (urlhash);


--
-- Name: index_newsitems_on_feed_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_newsitems_on_feed_id_and_id ON newsitems USING btree (feed_id, id);


--
-- Name: index_subscriptions_on_feed_id_and_category_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_feed_id_and_category_id_and_user_id ON subscriptions USING btree (feed_id, category_id, user_id);


--
-- Name: index_subscriptions_on_feed_id_and_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_feed_id_and_user_id ON subscriptions USING btree (feed_id, user_id);


--
-- Name: index_subscriptions_on_user_id_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_subscriptions_on_user_id_and_id ON subscriptions USING btree (user_id, id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_token ON users USING btree (token);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_2712fd6c86; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY entries
    ADD CONSTRAINT fk_rails_2712fd6c86 FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- Name: fk_rails_e6cd8c99b9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT fk_rails_e6cd8c99b9 FOREIGN KEY (feed_id) REFERENCES feeds(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

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

INSERT INTO schema_migrations (version) VALUES ('20131221193702');

INSERT INTO schema_migrations (version) VALUES ('20131221194141');

INSERT INTO schema_migrations (version) VALUES ('20131221195859');

INSERT INTO schema_migrations (version) VALUES ('20140418184312');

INSERT INTO schema_migrations (version) VALUES ('20140419070111');

INSERT INTO schema_migrations (version) VALUES ('20140419072208');

INSERT INTO schema_migrations (version) VALUES ('20140419081706');

INSERT INTO schema_migrations (version) VALUES ('20140419084809');

INSERT INTO schema_migrations (version) VALUES ('20140608084200');

INSERT INTO schema_migrations (version) VALUES ('20140615155241');

INSERT INTO schema_migrations (version) VALUES ('20141125171709');

INSERT INTO schema_migrations (version) VALUES ('20141125172438');

INSERT INTO schema_migrations (version) VALUES ('20141211062051');

INSERT INTO schema_migrations (version) VALUES ('20141211084434');

INSERT INTO schema_migrations (version) VALUES ('20160206122259');

INSERT INTO schema_migrations (version) VALUES ('20160208060335');

INSERT INTO schema_migrations (version) VALUES ('20160208060816');

INSERT INTO schema_migrations (version) VALUES ('20160208063729');

INSERT INTO schema_migrations (version) VALUES ('20160409184504');

INSERT INTO schema_migrations (version) VALUES ('20160410104028');

INSERT INTO schema_migrations (version) VALUES ('20160417010128');

INSERT INTO schema_migrations (version) VALUES ('20160417034451');

