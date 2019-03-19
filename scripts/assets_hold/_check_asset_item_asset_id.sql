/**
 * ASSET_ITEMS
 * Once an asset_item has been created it can never leave its wallet. This function 
 * checks to make sure that any change to the asset_id stays within the original wallet. 
 */


CREATE OR REPLACE FUNCTION check_asset_item_asset_id() RETURNS trigger AS $asset_item_check_asset_id$
    DECLARE
        oldWalletId integer;
        newWalletId integer;
    BEGIN
    
        SELECT wallet_id INTO oldWalletId FROM assets WHERE id = OLD.asset_id;

        select wallet_id into newWalletID from assets where id = NEW.asset_id;

        IF oldWalletId != newWalletId THEN
            RAISE EXCEPTION 'You cannot move an asset_item into an asset from another wallet';
        END IF;
        RETURN NEW;
    END;
$asset_item_check_asset_id$ LANGUAGE plpgsql;



CREATE TRIGGER asset_item_check_asset_id
    BEFORE UPDATE ON asset_items
    FOR EACH ROW EXECUTE PROCEDURE check_asset_item_asset_id();
    
    
    

