/*
This function is used to find the asset_items record that has the newest dttm value. 
This is considered the "current_value" of the asset. If the is no asset_items record
for the asset then a zero balance record is generated for the asset.
*/


/*
 * @param assetId - the asset to find the current_value for
 * @param dttm - the date the asset was created, used to compute a zero value record if needed
 */
CREATE OR REPLACE FUNCTION get_asset_summary(assetId integer, assetDttm date)

    RETURNS json AS $$
    DECLARE
        result json;
    BEGIN
        
        -- There can only be one amt per date due to the unique index on asset_item_id and dttm
        SELECT row_to_json(t)
        FROM (
            SELECT id asset_item_id, dttm, max(amt) amt
            INTO result 
            FROM asset_items 
            WHERE dttm = (select max(dttm) from asset_items where asset_id = assetId)
            AND asset_id = assetId
            GROUP BY id, dttm
        ) t;

        IF (result is NULL) THEN
            WITH r AS (
                SELECT  0 AS asset_item_id, assetDttm AS dttm, 0 AS amt
                )
            SELECT row_to_json(r.*) into result
            FROM r;
        END IF;

        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'caught at get_asset_summary';
    END;
    $$ LANGUAGE plpgsql;






