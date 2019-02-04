/**
 * ASSET_ITEMS
 * The dttm date column must always have a DAY value of 01. 
 * Asset items can only have one unique entry per month. 
 */


CREATE OR REPLACE FUNCTION check_asset_item_dttm() RETURNS trigger AS $asset_item_check$
    DECLARE
        cnt int;
    BEGIN
        -- Check that the day in dttm is always 01
        IF EXTRACT(DAY FROM NEW.dttm) != 01 THEN
            RAISE EXCEPTION 'day in dttm must be 01';
        END IF;

        -- The asset_item cannot duplicate the dttm for its for all items under 
        -- a single assetId.
        -- Checking NEW before the update to be sure there are none already for the dttm.
        SELECT count(*) into cnt FROM asset_items WHERE id != NEW.id AND dttm = NEW.dttm and asset_id = NEW.asset_id;
        IF cnt != 0 THEN
            RAISE EXCEPTION 'duplicate dttm, only one entry per month for asset_items per asset';
        END IF;
        RETURN NEW;
    END;
$asset_item_check$ LANGUAGE plpgsql;



CREATE TRIGGER check_asset_item_dttm
    BEFORE INSERT or UPDATE ON asset_items
    FOR EACH ROW EXECUTE PROCEDURE check_asset_item_dttm();
    
    
    

