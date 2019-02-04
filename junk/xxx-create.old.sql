-- \i   ~/Development/_pupmoney/database/_create.sql;

-- Get the data directory for PostgreSQL
-- SHOW data_directory;

drop table CODES;
drop table ASSET_ITEMS;
drop table ASSETS;
drop table EXPENSE_ITEMS;
drop table EXPENSES;
drop table VENDORS;
drop table WALLETS;
drop table USERS;


create table CODES( -- For registration and forgotten pswds
  email text NOT NULL,
  code text NOT NULL,
  dttm DATE NOT NULL default CURRENT_DATE -- MM/DD/YYYY used to purge codes after 1 day
);
ALTER TABLE codes ADD CONSTRAINT email_check CHECK ( length(email) > 4 AND length(code) = 5 );
CREATE UNIQUE INDEX codes_email_idx ON CODES (email);


-- USERS --
CREATE TABLE USERS (
    id serial PRIMARY KEY,
    email text NOT NULL,
    pswd text NOT NULL,
    name text NOT NULL,
    member_since DATE DEFAULT current_date,
    sub_expires DATE DEFAULT current_date + 120,
    sys_admin smallint CHECK (sys_admin = 0 OR sys_admin = 1) DEFAULT 0  -- sys_admin for in-house privs
);
CREATE UNIQUE INDEX _users_email_idx ON USERS (email);


-- WALLETS --
CREATE TABLE WALLETS (
    id serial PRIMARY KEY,
    user_id integer REFERENCES USERS (id) NOT NULL, -- NO CASCADE DELETE
    shares integer[] DEFAULT array[]::integer[],
    name text NOT NULL,
    country_code text not null DEFAULT 'en-US',
    currency_options json not null DEFAULT '{"style": "currency", "currency": "USD", "minimumFractionDigits": 2}',
    default_wallet smallint NOT NULL DEFAULT 0, --0=false , 1=true default wallets cannot be deleted, each user has 1
    dttm DATE DEFAULT current_date
);
CREATE INDEX wallet_shares_idx on WALLETS USING GIN ("shares");
CREATE INDEX _wallets_user_id_idx ON WALLETS (user_id);


-- VENDORS --
CREATE TABLE VENDORS (
    id serial PRIMARY KEY,
    wallet_id integer REFERENCES WALLETS (id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL
);
CREATE INDEX _vendors_wallet_id_idx ON VENDORS (wallet_id);


-- ASSETS --
CREATE TABLE ASSETS (
    id serial PRIMARY KEY,
    wallet_id integer REFERENCES WALLETS (id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL,
    dttm DATE DEFAULT current_date
);
CREATE INDEX _assets_dttm_idx ON ASSETS (dttm);
CREATE INDEX _assets_wallet_id_idx ON ASSETS (wallet_id);


-- ASSET_ITEMS --
-- Max amt 9,999,999,999,999.9999 or 10 trillion
CREATE TABLE ASSET_ITEMS (
    id serial PRIMARY KEY,
    asset_id integer REFERENCES ASSETS (id) ON DELETE CASCADE NOT NULL, 
    amt numeric(17,4) not null,
    dttm DATE not null -- The day of the month will always be "01" as per trigger check_asset_dttm
);
CREATE INDEX _asset_items_dttm_idx ON ASSET_ITEMS (dttm);
CREATE INDEX _asset_items_asset_id_idx ON ASSET_ITEMS (asset_id);
-- Need a unique index on asset_id and dttm
CREATE UNIQUE INDEX _asset_items_asset_item_id_dttm_idx ON ASSET_ITEMS (asset_id, dttm);


-- EXPENSES --
CREATE TABLE EXPENSES (
    id serial PRIMARY KEY,
    wallet_id integer REFERENCES WALLETS (id) ON DELETE CASCADE NOT NULL,
    name text NOT NULL,
    icon text NOT NULL DEFAULT 'logo-usd',
    dttm DATE DEFAULT current_date
);
CREATE INDEX _expenses_dttm_idx ON EXPENSES (dttm);
CREATE INDEX _expenses_wallet_id_idx ON EXPENSES (wallet_id);


-- EXPENSE_ITEMS --
-- Max amt 9,999,999,999.9999 or 10 billion
CREATE TABLE EXPENSE_ITEMS (
    id serial PRIMARY KEY,
    expense_id integer REFERENCES EXPENSES (id) ON DELETE CASCADE NOT NULL, 
    vendor text,
    note text,
    image text,
    amt numeric(14,4) not null,
    dttm DATE not null
);
CREATE INDEX _expense_items_dttm_idx ON EXPENSE_ITEMS (dttm);
CREATE INDEX _expense_items_expense_id_idx ON EXPENSE_ITEMS (expense_id);


grant all on codes to warren;
grant all on users_id_seq to warren;
grant all on users to warren;
grant all on wallets_id_seq to warren;
grant all on wallets to warren;
grant all on vendors_id_seq to warren;
grant all on vendors to warren;
grant all on assets_id_seq to warren;
grant all on assets to warren;
grant all on asset_items_id_seq to warren;
grant all on asset_items to warren;
grant all on expenses_id_seq to warren;
grant all on expenses to warren;
grant all on expense_items_id_seq to warren;
grant all on expense_items to warren;


\i   ~/Development/_pupmoney/database/_add_user.sql;
\i   ~/Development/_pupmoney/database/_items_type.sql;
\i   ~/Development/_pupmoney/database/_get_asset_items.sql;
\i   ~/Development/_pupmoney/database/_get_expense_items.sql;
\i   ~/Development/_pupmoney/database/_get_expense_summary.sql;
\i   ~/Development/_pupmoney/database/_get_asset_summary.sql;
\i   ~/Development/_pupmoney/database/_check_asset_item_dttm.sql;
\i   ~/Development/_pupmoney/database/_check_asset_item_asset_id.sql;
\i   ~/Development/_pupmoney/database/_check_expense_item_expense_id.sql;



