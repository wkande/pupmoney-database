/**
 * Creates child rows (default values) for a wallet in expenses and expense/vendors.
 */


CREATE OR REPLACE FUNCTION finalize_wallet(walletId integer) 
    RETURNS boolean AS $$
    DECLARE
        exp_id integer;
    BEGIN


        /*INSERT INTO assets (wallet_id, name) 
        VALUES  (walletId, 'Brokerage'),
                (walletId, 'Cash'),
                (walletId, 'Checking'),
                (walletId, 'Certificate Deposit'),
                (walletId, 'Savings'),
                (walletId, 'House'),
                (walletId, 'Vehicle #1'),
                (walletId, 'Vehicle #2');

        INSERT INTO assets (wallet_id, name, liability) 
        VALUES  (walletId, 'House Mortgage', 1),
                (walletId, 'Vehicle #1 Car Loan', 1);
        */


        -- Groceries
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Groceries') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Albertsons');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Safeway');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Harris Teeter');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Target');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walmart');

        -- Vehicles
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Vehicles') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');

        -- Vehicles Gas
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Vehicles Gas') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Sams Club');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Maverick');

        -- Home Maintenance
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Home Maintenance') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Home Depot');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Lowes');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Menards');

        -- Clothing
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Clothing') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Amazon');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Dillard''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walmart');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Target');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Famous Footwear');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'DSW');

        -- Restaurants
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Restaurants') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Chili''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'MacDonald''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Subway');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Jimmy John''s');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Burger King');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Dairy Queen');

        -- Insurance
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Insurance') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'State Farm');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Alstate');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Nationwide');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Progressive');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Farmers');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Geico');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Liberty Mutual');

        -- Interest & Fees
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Interest & Fees') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Wells Fargo');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Bank of America');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Capital One');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Live Oak');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Ally');

        -- Taxes
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Taxes') RETURNING id INTO exp_id;

        -- Gambling
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Gambling') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Powerbal');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'MegaMillions');

        -- Other
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Other') RETURNING id INTO exp_id;

        -- Transport
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Transport') RETURNING id INTO exp_id;

        -- Beauty
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Beauty') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Sephora');
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Dillard''s');

        -- Charity
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Charity') RETURNING id INTO exp_id;
 
        -- Utilities
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Utilities') RETURNING id INTO exp_id;
 
        -- Entertainment
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Entertainment') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Carmike Cinemas');

        -- Healthcare
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Healthcare') RETURNING id INTO exp_id;
        INSERT INTO vendors(expense_id, name) VALUES(exp_id, 'Walgreens');

        -- Education
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Education') RETURNING id INTO exp_id;

        -- Cleaning
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Cleaning') RETURNING id INTO exp_id;

        -- Gifts
        INSERT INTO expenses (wallet_id, name) VALUES  (walletId, 'Gifts') RETURNING id INTO exp_id;
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




