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
            '{"Albertsons", "Amazon", "Harris Teeter", "Safeway",  "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;


        -- Vehicles
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Vehicles',
            '{"Amazon"}'
        ) RETURNING id INTO cat_id;


        -- Vehicles Gas
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Vehicles Gas',
            '{"Maverick", "Sams Club"}'
        ) RETURNING id INTO cat_id;


        -- Household
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Household',
            '{"Amazon", "Home Depot", "Lowes", "Menards"}'
        ) RETURNING id INTO cat_id;


        -- Clothing
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Clothing',
            '{"Amazon", "Dillard''s", "DSW", "Famous Footwear", "Target", "Walmart"}'
        ) RETURNING id INTO cat_id;


        -- Restaurants
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Restaurants',
            '{"Chili''s", "Burger King", "Dairy Queen", "Jimmy John''s", "MacDonald''s", "Subway"}'
        ) RETURNING id INTO cat_id;


        -- Insurance
        INSERT INTO pupmoney.categories (wallet_id, name, vendors) VALUES  (walletId, 'Insurance',
            '{"Allstate", "Farmers", "Geico", "Liberty Mutual", "Nationwide", "Progressive", "State Farm"}'
        ) RETURNING id INTO cat_id;
  

        -- Interest & Fees
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Interest & Fees',
            '{"Ally", "Bank of America", "Capitol One", "Live Oak", "Wells Fargo"}'
        ) RETURNING id INTO cat_id;
 

        -- Taxes
        INSERT INTO categories (wallet_id, name) VALUES  (walletId, 'Taxes') RETURNING id INTO cat_id;


        -- Lotteries
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Lotteries',
            '{ "MegaMillions", "Powerbal"}'
        ) RETURNING id INTO cat_id;


        -- Other
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Other',
            '{"Amazon", "Target", "Walamrt"}'
        ) RETURNING id INTO cat_id;


        -- Transport
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Transport',
            '{"Lyft", "Municipal Bus", "Uber"}'
        ) RETURNING id INTO cat_id;


        -- Beauty
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Beauty',
            '{"Dillard''s",  "Macy''s", "Sephora"}'
        ) RETURNING id INTO cat_id;


        -- Charity
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Charity',
            '{"St. Jude Children''s Hospital"}'
        ) RETURNING id INTO cat_id;

 
        -- Utilities
        INSERT INTO categories (wallet_id, name, vendors) VALUES  (walletId, 'Utilities',
            '{"Electric Company", "Gas Company", "Water Company"}'
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




