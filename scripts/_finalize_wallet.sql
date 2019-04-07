/**
 * Creates Categories and Vendors for each.
 */


CREATE OR REPLACE FUNCTION finalize_wallet(walletId integer) 
    RETURNS boolean AS $$
    DECLARE
        cat_id integer;
    BEGIN

        -- Groceries
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Groceries',
            '{"Albertsons", "Amazon", "Safeway", "Harris Teeter", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Albertsons');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Safeway');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Harris Teeter');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Target');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Walmart');*/

        -- Vehicles
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Vehicles',
            '{"Amazon"}'
        ) RETURNING id INTO cat_id;
                    --INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Amazon');

        -- Vehicles Gas
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Vehicles Gas',
            '{"Maverick", "Sams Club"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Sams Club');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Maverick');*/

        -- Home Maintenance
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Home Maintenance',
            '{"Amazon", "Home Depot", "Lowes", "Menards"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Amazon');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Home Depot');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Lowes');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Menards');*/

        -- Clothing
        /*INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Clothing',
            '{"Amazon", "Dillard''s", "DSW", "Famous Footwear", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;*/
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Amazon');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Dillard''s');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Walmart');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Target');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Famous Footwear');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'DSW');*/

        -- Restaurants
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Restaurants',
            '{"Chili''s", "MacDonald''s", "Subway", "Jimmy John''s", "Burger King", "Dairy Queen"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Chili''s');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'MacDonald''s');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Subway');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Jimmy John''s');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Burger King');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Dairy Queen');*/

        -- Insurance
        INSERT INTO pupmoney.categories (wallet_id, name, vendors) VALUES  (walletId, 'Insurance',
            '{"Alstate", "Farmers", "Geico", "Liberty Mutual", "State Farm", "Nationwide", "Progressive"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'State Farm');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Alstate');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Nationwide');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Progressive');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Farmers');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Geico');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Liberty Mutual');*/

        -- Interest & Fees
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Interest & Fees',
            '{"Wells Fargo", "Bank of America", "Capital One", "Ally", "Live Oak"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Wells Fargo');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Bank of America');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Capital One');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Live Oak');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Ally');*/

        -- Taxes
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Taxes') RETURNING id INTO cat_id;

        -- Gambling
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Gambling',
            '{"Powerbal", "MegaMillions"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Powerbal');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'MegaMillions');*/

        -- Other
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Other',
            '{"Amazon", "Target", "Walamrt"}'
        ) RETURNING id INTO cat_id;

        -- Transport
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Transport',
            '{"Uber", "Lyft", "Municipal Bus"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Uber');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Lyft');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Municipal Bus');*/

        -- Beauty
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Beauty',
            '{"Sephora", "Dillard''s", "Macy''s"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Sephora');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Dillard''s');*/

        -- Charity
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Charity',
            '{"St. Jude Children''s Hospital"}'
        ) RETURNING id INTO cat_id;
                    --INSERT INTO vendors(category_id, name) VALUES(cat_id, 'St. Jude Children''s Hospital');
 
        -- Utilities
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Utilities',
            '{"Water Company", "Power Company.", "Gas Company."}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Water Co.');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Electric Co.');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Gas Co.');*/
 
        -- Entertainment
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Entertainment',
            '{"Amazon", "Carmike Cinemas", "AMC", "Regal Cinemas", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;
                    --INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Carmike Cinemas');

        -- Healthcare
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Healthcare',
            '{"Amazon", "Walgreens", "Walmart"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Walgreens');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Walmart');*/

        -- Education
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Education') RETURNING id INTO cat_id;

        -- Cleaning
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Cleaning') RETURNING id INTO cat_id;

        -- Gifts
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Gifts',
            '{"Amazon", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;
                    /*INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Amazon');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Walmart');
                    INSERT INTO vendors(category_id, name) VALUES(cat_id, 'Target');*/

  
        return TRUE;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'caught at finalize_wallet - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;




