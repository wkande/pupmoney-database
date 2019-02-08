/**
 * Creates child rows (default values) for a wallet in assets, expenses and expense/vendors.
 */


CREATE OR REPLACE FUNCTION finalize_wallet(walletId integer) 
    RETURNS boolean AS $$
    DECLARE
        --r_Return record;
        exp_id integer;
    BEGIN


        INSERT INTO assets (wallet_id, name) 
        VALUES  (walletId, 'Brokerage'),
                (walletId, 'Cash'),
                (walletId, 'Checking'),
                (walletId, 'Certificate Deposit'),
                (walletId, 'Savings'),
                (walletId, 'House'),
                (walletId, 'Vehicle #1'),
                (walletId, 'Vehicle #2');


        -- Groceries
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Groceries', 'nutrition') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Albertsons');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Safeway');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Harris Teeter');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Target');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walmart');

        -- Vehicles
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Vehicles', 'car') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');

        -- Vehicles
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Vehicles Gas', 'analytics') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Sams Club');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Maverick');

        -- Home Maintenance
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Home Maintenance', 'home') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Home Depot');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Lowes');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Menards');

        -- Clothing
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Clothing', 'shirt') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Dillard''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walmart');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Target');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Famous Footwear');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'DSW');

        -- Restaurants
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Restaurants', 'restaurant') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Chili''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'MacDonald''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Subway');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Jimmy John''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Burger King');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Dairy Queen');

        -- Insurance
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Insurance', 'analytics') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'State Farm');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Alstate');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Nationwide');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Progressive');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Farmers');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Geico');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Liberty Mutual');

        -- Interest & Fees
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Interest & Fees', 'cash') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Wells Fargo');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Bank of America');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Capital One');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Live Oak');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Ally');

        -- Taxes
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Taxes', 'analytics') RETURNING id INTO exp_id;

        -- Lotteries
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Lotteries', 'ribbon') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Powerbal');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'MegaMillions');

        -- Other
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Other', 'star') RETURNING id INTO exp_id;

        -- Transport
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Transport', 'subway') RETURNING id INTO exp_id;

        -- Beauty
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Beauty', 'analytics') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Sephora');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Dillard''s');

        -- Charity
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Charity', 'analytics') RETURNING id INTO exp_id;
 
        -- Utilities
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Utilities', 'bulb') RETURNING id INTO exp_id;
 
        -- Entertainment
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Entertainment', 'musical-notes') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Carmike Cinemas');

        -- Healthcare
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Healthcare', 'medical') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walgreens');

        -- Education
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Education', 'leaf') RETURNING id INTO exp_id;

        -- Cleaning
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Cleaning', 'analytics') RETURNING id INTO exp_id;

        -- Gifts
        INSERT INTO expenses (wallet_id, name, icon) VALUES  (walletId, 'Gifts', 'snow') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walmart');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Target');

  




        --SELECT u.id, u.email, u.name, u.member_since, u.sub_expires, u.sys_admin
        --INTO r_Return FROM WALLETS u WHERE id = wallet_id;

        return TRUE;
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'caught at finalize_wallet';
    END;
    $$ LANGUAGE plpgsql;




