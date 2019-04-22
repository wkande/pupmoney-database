-- \i   ~/Development/_pupmoney/database/scripts/_create.sql;

\! echo "\n\n\n*****************************************************************"
\! echo "    PupMoney: START SCRIPT _create.sql"
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



SELECT count(*) = 0 as not_master FROM information_schema.tables WHERE table_schema='pupmoney' AND table_name='users'; \gset
--\echo :not_master

\if :not_master
    \! echo "------------------------------"
    \! echo "Dropping and re-creating schema"
    \! echo "------------------------------"
    do $$
    DECLARE tbl text;
    BEGIN
        DROP SCHEMA if exists pupmoney CASCADE;
        CREATE SCHEMA pupmoney;
        --GRANT ALL ON SCHEMA pupmoney TO postgres;
        --GRANT ALL ON SCHEMA pupmoney TO public;
        COMMENT ON SCHEMA pupmoney IS 'pupmoney schema';
    END;
    $$ LANGUAGE plpgsql;
\endif


\! echo "\n-------------------------"
\! echo "Create tables and indexes"
\! echo "-------------------------"


-- CATEGORIES --
CREATE TABLE CATEGORIES (
    id serial PRIMARY KEY,
    wallet_id integer NOT NULL,
    name text NOT NULL,
    vendors text[] DEFAULT array[]::text[] NOT NULL,
    dttm DATE DEFAULT current_date
);
CREATE INDEX _categories_dttm_idx ON CATEGORIES (dttm);
CREATE INDEX _categories_wallet_id_idx ON CATEGORIES (wallet_id);
CREATE UNIQUE INDEX _categories_wallet_id_name_idx ON CATEGORIES (wallet_id, name);


-- EXPENSES --
-- Max amt 9,999,999,999.9999 or 10 billion
CREATE TABLE EXPENSES (
    id serial PRIMARY KEY,
    category_id integer REFERENCES CATEGORIES (id) ON DELETE CASCADE NOT NULL, 
    vendor text,
    note text,
    document tsvector,
    image_ref text, -- google cloud storage reference for image, ex: /user/2/expense/345/expense_item/4557
    imported text, -- if not null then this record came from a competitor's import
    amt numeric(14,4) not null,
    dttm DATE not null
);
CREATE INDEX _expenses_dttm_idx ON EXPENSES (dttm);
CREATE INDEX _expenses_category_id_idx ON EXPENSES (category_id);
CREATE INDEX _expenses_text_search_idx ON EXPENSES USING gin(document);


\! echo "\n-----------------------------------"
\! echo "Create development grants if needed"
\! echo "-----------------------------------"

SELECT current_user = 'warren' AS is_warren; \gset
--\echo :is_warren

\if :is_warren
    do $$
    BEGIN
        --grant all on vendors_id_seq to warren;
        --grant all on vendors to warren;
        grant all on categories_id_seq to warren;
        grant all on categories to warren;
        grant all on expenses_id_seq to warren;
        grant all on expenses to warren;
    END;
    $$ LANGUAGE plpgsql;
\endif





\! echo "\n----------------"
\! echo "Create functions"
\! echo "----------------"

\i   ~/Development/_pupmoney/database/scripts/_finalize_wallet.sql;
\i   ~/Development/_pupmoney/database/scripts/_delete_wallet_shard.sql;
\i   ~/Development/_pupmoney/database/scripts/_items_type.sql;
\i   ~/Development/_pupmoney/database/scripts/_get_expenses_by_category.sql;
\i   ~/Development/_pupmoney/database/scripts/_get_expenses.sql;
\i   ~/Development/_pupmoney/database/scripts/_get_expenses_text_search.sql;
\i   ~/Development/_pupmoney/database/scripts/_get_category_summary.sql;
\i   ~/Development/_pupmoney/database/scripts/_check_expense_category_id.sql;
\i   ~/Development/_pupmoney/database/scripts/_create_expense_document.sql;



SET client_min_messages TO NOTICE;