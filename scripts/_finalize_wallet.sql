/**
 * Creates Categories with a vendors list for each.
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


        -- Vehicles
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Vehicles',
            '{"Amazon"}'
        ) RETURNING id INTO cat_id;


        -- Vehicles Gas
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Vehicles Gas',
            '{"Maverick", "Sams Club"}'
        ) RETURNING id INTO cat_id;


        -- Home Maintenance
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Home Maintenance',
            '{"Amazon", "Home Depot", "Lowes", "Menards"}'
        ) RETURNING id INTO cat_id;


        -- Clothing
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Clothing',
            '{"Amazon", "Dillard''s", "DSW", "Famous Footwear", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;


        -- Restaurants
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Restaurants',
            '{"Chili''s", "MacDonald''s", "Subway", "Jimmy John''s", "Burger King", "Dairy Queen"}'
        ) RETURNING id INTO cat_id;


        -- Insurance
        INSERT INTO pupmoney.categories (wallet_id, name, vendors) VALUES  (walletId, 'Insurance',
            '{"Alstate", "Farmers", "Geico", "Liberty Mutual", "State Farm", "Nationwide", "Progressive"}'
        ) RETURNING id INTO cat_id;
  

        -- Interest & Fees
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Interest & Fees',
            '{"Wells Fargo", "Bank of America", "Capitol One", "Ally", "Live Oak"}'
        ) RETURNING id INTO cat_id;
 

        -- Taxes
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Taxes') RETURNING id INTO cat_id;


        -- Gambling
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Gambling',
            '{"Powerbal", "MegaMillions"}'
        ) RETURNING id INTO cat_id;


        -- Other
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Other',
            '{"Amazon", "Target", "Walamrt"}'
        ) RETURNING id INTO cat_id;


        -- Transport
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Transport',
            '{"Uber", "Lyft", "Municipal Bus"}'
        ) RETURNING id INTO cat_id;


        -- Beauty
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Beauty',
            '{"Sephora", "Dillard''s", "Macy''s"}'
        ) RETURNING id INTO cat_id;


        -- Charity
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Charity',
            '{"St. Jude Children''s Hospital"}'
        ) RETURNING id INTO cat_id;

 
        -- Utilities
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Utilities',
            '{"Water Company", "Power Company.", "Gas Company."}'
        ) RETURNING id INTO cat_id;

 
        -- Entertainment
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Entertainment',
            '{"Amazon", "Carmike Cinemas", "AMC", "Regal Cinemas", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;


        -- Healthcare
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Healthcare',
            '{"Amazon", "Walgreens", "Walmart"}'
        ) RETURNING id INTO cat_id;


        -- Education
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Education') RETURNING id INTO cat_id;


        -- Cleaning
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Cleaning') RETURNING id INTO cat_id;


        -- Gifts
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Gifts',
            '{"Amazon", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;

  
        return TRUE;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'caught at finalize_wallet - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;




