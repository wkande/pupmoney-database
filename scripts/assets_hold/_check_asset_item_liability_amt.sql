/**
 * ASSET_ITEMS
 * If the asset is a liability then the amt in the asset_items table can only be negative. 
 */


CREATE OR REPLACE FUNCTION check_asset_item_liability_amt() RETURNS trigger AS $asset_item_liability_amt$
    DECLARE
        currLiability integer;
    BEGIN
    
        SELECT liability INTO currLiability FROM assets WHERE id = NEW.asset_id;

        IF currLiability = 1 AND NEW.amt > 0 THEN
            RAISE EXCEPTION 'Liabilities must have a negative amt.';
        END IF;

        RETURN NEW;
    END;
$asset_item_liability_amt$ LANGUAGE plpgsql;



CREATE TRIGGER asset_item_liability_amt
    BEFORE INSERT OR UPDATE ON asset_items
    FOR EACH ROW EXECUTE PROCEDURE check_asset_item_liability_amt();
    
    
    

