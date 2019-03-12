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
--SET search_path TO pupmoney;
--SHOW search_path;
--\dt



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


-- ASSETS --
/*CREATE TABLE pupmoney.ASSETS (
    id serial PRIMARY KEY,
    wallet_id integer NOT NULL,
    name text NOT NULL,
    liability smallint NOT NULL DEFAULT 0, -- 0=asset, 1=liability, if liability ASSET_ITEMS.amt must be negative, otherwise positive
    dttm DATE DEFAULT current_date
);
ALTER TABLE pupmoney.ASSETS ADD CONSTRAINT liability_check CHECK ( liability = 0 OR liability = 1 );
CREATE INDEX _assets_dttm_idx ON pupmoney.ASSETS (dttm);
CREATE INDEX _assets_wallet_id_idx ON pupmoney.ASSETS (wallet_id);
*/

-- ASSET_ITEMS --
-- Max amt 9,999,999,999,999.9999 or 10 trillion
/*CREATE TABLE pupmoney.ASSET_ITEMS (
    id serial PRIMARY KEY,
    asset_id integer REFERENCES ASSETS (id) ON DELETE CASCADE NOT NULL, 
    amt numeric(17,4) not null,
    dttm DATE not null      -- unique for each asset_id
);
CREATE INDEX _asset_items_dttm_idx ON pupmoney.ASSET_ITEMS (dttm);
CREATE INDEX _asset_items_asset_id_idx ON pupmoney.ASSET_ITEMS (asset_id);
-- Need a unique index on asset_id and dttm
CREATE UNIQUE INDEX _asset_items_asset_item_id_dttm_idx ON pupmoney.ASSET_ITEMS (asset_id, dttm);
*/

-- EXPENSES --
CREATE TABLE pupmoney.EXPENSES (
    id serial PRIMARY KEY,
    wallet_id integer NOT NULL,
    name text NOT NULL,
    dttm DATE DEFAULT current_date
);
CREATE INDEX _expenses_dttm_idx ON pupmoney.EXPENSES (dttm);
CREATE INDEX _expenses_wallet_id_idx ON pupmoney.EXPENSES (wallet_id);


-- EXPENSE_ITEMS --
-- Max amt 9,999,999,999.9999 or 10 billion
CREATE TABLE pupmoney.EXPENSE_ITEMS (
    id serial PRIMARY KEY,
    expense_id integer REFERENCES EXPENSES (id) ON DELETE CASCADE NOT NULL, 
    vendor text,
    note text,
    document tsvector,
    image_ref text, -- google cloud storage reference for image, ex: /user/2/expense/345/expense_item/4557
    imported text, -- if not null then this record came from a competitor's import
    --credit smallint NOT NULL DEFAULT 0, -- 0=expense, 1=credit, if credit must be negative amt, otherwise positive amt
    amt numeric(14,4) not null,
    dttm DATE not null
);
--ALTER TABLE pupmoney.EXPENSE_ITEMS ADD CONSTRAINT credit_check CHECK ( credit = 0 OR credit = 1 );
CREATE INDEX _expense_items_dttm_idx ON pupmoney.EXPENSE_ITEMS (dttm);
CREATE INDEX _expense_items_expense_id_idx ON pupmoney.EXPENSE_ITEMS (expense_id);
CREATE INDEX _expense_items_text_search_idx ON pupmoney.EXPENSE_ITEMS USING gin(document);


-- VENDORS --
CREATE TABLE pupmoney.VENDORS (
    id serial PRIMARY KEY,
    expense_id integer REFERENCES EXPENSES (id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL
);
CREATE INDEX _vendors_expense_id_idx ON pupmoney.VENDORS (expense_id);


\! echo "\n-----------------------------------"
\! echo "Create development grants if needed"
\! echo "-----------------------------------"

SELECT current_user = 'warren' AS is_warren; \gset
--\echo :is_warren

\if :is_warren
    do $$
    BEGIN
        grant all on pupmoney.vendors_id_seq to warren;
        grant all on pupmoney.vendors to warren;
        --grant all on pupmoney.assets_id_seq to warren;
        --grant all on pupmoney.assets to warren;
        --grant all on pupmoney.asset_items_id_seq to warren;
        --grant all on pupmoney.asset_items to warren;
        grant all on pupmoney.expenses_id_seq to warren;
        grant all on pupmoney.expenses to warren;
        grant all on pupmoney.expense_items_id_seq to warren;
        grant all on pupmoney.expense_items to warren;
    END;
    $$ LANGUAGE plpgsql;
\endif





\! echo "\n----------------"
\! echo "Create functions"
\! echo "----------------"

\i   ~/Development/_pupmoney/database/scripts/_finalize_wallet.sql;
\i   ~/Development/_pupmoney/database/scripts/_delete_wallet_shard.sql;
\i   ~/Development/_pupmoney/database/scripts/_items_type.sql;
--\i   ~/Development/_pupmoney/database/scripts/_get_asset_items.sql;
\i   ~/Development/_pupmoney/database/scripts/_get_expense_items.sql;
\i   ~/Development/_pupmoney/database/scripts/_get_expense_summary.sql;
--\i   ~/Development/_pupmoney/database/scripts/_get_asset_summary.sql;
--\i   ~/Development/_pupmoney/database/scripts/_check_asset_item_liability_amt.sql
--\i   ~/Development/_pupmoney/database/scripts/_check_expense_item_credit_amt.sql
--\i   ~/Development/_pupmoney/database/scripts/_check_asset_item_dttm.sql;
--\i   ~/Development/_pupmoney/database/scripts/_check_asset_item_asset_id.sql;

\i   ~/Development/_pupmoney/database/scripts/_check_expense_item_expense_id.sql;
\i   ~/Development/_pupmoney/database/scripts/_create_expense_item_document.sql;



SET client_min_messages TO NOTICE;