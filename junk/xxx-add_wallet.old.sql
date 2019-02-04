



DROP function add_wallet;

CREATE OR REPLACE FUNCTION add_wallet(userId integer, walletId integer, walletName text, shard integer, defaultWallet int default 0) 
    RETURNS json AS $$
    DECLARE
        -- user_id bigint = nextval('users_id_seq');
        -- wallet_id bigint = nextval('wallets_id_seq');
        vendor_id bigint = nextval('vendors_id_seq');
        --default_wallet_name text = 'Default Wallet';
        r_Return record;
    BEGIN

        INSERT INTO wallets (id, user_id, name, default_wallet) VALUES (walletId, user_id, walletName, defaultWallet);

        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Amazon');
        vendor_id := nextval('vendors_id_seq');
        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Home Depot');
        vendor_id := nextval('vendors_id_seq');
        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Lowes');
        vendor_id := nextval('vendors_id_seq');
        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Office Depot');
        vendor_id := nextval('vendors_id_seq');
        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Target');
        vendor_id := nextval('vendors_id_seq');
        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Walgreens');
        vendor_id := nextval('vendors_id_seq');
        INSERT INTO vendors (id, wallet_id, name) VALUES (vendor_id, walletId, 'Walmart');

        INSERT INTO assets (wallet_id, name) 
        VALUES  (wallet_id, 'Cash'),
                (wallet_id, 'Checking'),
                (wallet_id, 'Savings'),
                (wallet_id, 'House'),
                (wallet_id, 'Vehicle #1'),
                (wallet_id, 'Vehicle #2');

        INSERT INTO expenses (wallet_id, name, icon) 
        VALUES  (wallet_id, 'Vehicles', 'car'),
                (wallet_id, 'Vehicle Gas', 'analytics'),
                (wallet_id, 'Groceries', 'cart'),
                (wallet_id, 'Home Improvement', 'home'),
                (wallet_id, 'Yard Maintenance', 'analytics'),
                (wallet_id, 'Clothing', 'shirt'),
                (wallet_id, 'Restaurants', 'restaurant'),
                (wallet_id, 'Insurance', 'analytics'),
                (wallet_id, 'Bank/Credit Card Fees', 'cash'),
                (wallet_id, 'Transport', 'subway'),
                (wallet_id, 'Beauty', 'analytics'),
                (wallet_id, 'Charity', 'analytics'),
                (wallet_id, 'Utilities', 'bulb'),
                (wallet_id, 'Entertainment', 'musical-notes'),
                (wallet_id, 'Healthcare', 'medical'),
                (wallet_id, 'Education', 'leaf'),
                (wallet_id, 'Insurance', 'analytics'),
                (wallet_id, 'Other', 'star'),
                (wallet_id, 'Taxes', 'analytics'),
                (wallet_id, 'Lotteries', 'ribbon'),
                (wallet_id, 'Cleaning', 'analytics'),
                (wallet_id, 'Gifts', 'snow');

        SELECT u.id, u.email, u.name, u.member_since, u.sub_expires, u.sys_admin
        INTO r_Return FROM WALLETS u WHERE id = wallet_id;

        RETURN row_to_json(r_Return);
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'caught at add_user';
    END;
    $$ LANGUAGE plpgsql;




