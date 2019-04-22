-- \i   ~/Development/_pupmoney/database/scripts/_create_meta.sql;


\! echo "\n\n\n*****************************************************************"
\! echo "    PupMoney: START SCRIPT _create_meta.sql"
\! echo "    Copyright 2019 Wyoming Software, Inc. All rights reserved"
\! echo "*****************************************************************"


\! echo "\n-------------------------------"
\! echo "Setup ENV"
\! echo "-------------------------------"
-- Set the search path to the pupmoney schema so all objects are created there.
-- https://stackoverflow.com/questions/34098326/how-to-select-a-schema-in-postgres-when-using-psql 
-- SHOW search_path;
SET client_min_messages TO WARNING;
-- SET search_path TO pupmoney;
-- SHOW search_path;
-- \dt


\! echo "\n------------------------------"
\! echo "Dropping and re-creating schema"
\! echo "------------------------------"

DROP SCHEMA if exists pupmoney CASCADE;
CREATE SCHEMA pupmoney;
COMMENT ON SCHEMA pupmoney IS 'pupmoney schema';



\! echo "\n-------------------------"
\! echo "Create tables and indexes"
\! echo "-------------------------"

-- CODE --
create table CODES( -- For registration and login
  email text NOT NULL,
  code text NOT NULL,
  dttm DATE NOT NULL default CURRENT_DATE -- MM/DD/YYYY used to purge codes by cron after 1 day
);
ALTER TABLE codes ADD CONSTRAINT email_check CHECK ( length(email) > 5 AND length(code) = 5 );
CREATE UNIQUE INDEX codes_email_idx ON CODES (email);


-- USERS --
CREATE TABLE USERS (
    id serial PRIMARY KEY,
    email text NOT NULL,
    name text,
    member_since DATE DEFAULT current_date,
    sub_expires DATE DEFAULT current_date + 120,
    sys_admin smallint CHECK (sys_admin = null OR sys_admin = 1) DEFAULT null  -- sys_admin for in-house privs
);
CREATE UNIQUE INDEX _users_email_idx ON USERS (email);
/** @TODO Add a text search on users */


-- WALLETS --
CREATE TABLE WALLETS (
    id serial PRIMARY KEY,
    user_id integer REFERENCES USERS (id) NOT NULL, -- NO CASCADE DELETE
    shard integer NOT NULL, -- 0, 1, 2, ...
    shares integer[] DEFAULT array[]::integer[],
    name text NOT NULL,
    currency JSONB DEFAULT '{"curId":2, "symbol":"", "separator":",", "decimal":".", "precision": 2}' NOT NULL,
    default_wallet smallint NOT NULL DEFAULT 0, --0=false , 1=true default wallets cannot be deleted, each user has 1
    dttm DATE DEFAULT current_date
);
CREATE INDEX _wallet_shares_idx on WALLETS USING GIN ("shares");
CREATE INDEX _wallets_user_id_idx ON WALLETS (user_id);


CREATE TABLE PAYMENTS (
    id serial PRIMARY KEY,
    amt numeric(4,2) not null,
    user_id integer REFERENCES USERS (id) NOT NULL, -- NO CASCADE DELETE
    dttm DATE DEFAULT current_date
);
CREATE INDEX _payments_user_id_idx ON PAYMENTS (user_id);


\! echo "\n-------------------------"
\! echo "Create development grants"
\! echo "-------------------------"

SELECT current_user = 'warren' AS is_warren; \gset
--\echo :is_warren

\if :is_warren
    do $$
    BEGIN
        grant all on codes to warren;
        grant all on users_id_seq to warren;
        grant all on users to warren;
        grant all on wallets_id_seq to warren;
        grant all on wallets to warren;
        grant all on payments_id_seq to warren;
        grant all on payments to warren;
    END;
    $$ LANGUAGE plpgsql;
\endif


\i   ~/Development/_pupmoney/database/scripts/_add_user.sql;
\i   ~/Development/_pupmoney/database/scripts/_create.sql;




