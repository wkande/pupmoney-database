/**
 * Get the asset_items for an asset. The row count is also included.
 * @TODO - There may be a need in the future to add pagination.
 */


CREATE OR REPLACE FUNCTION get_asset_items(walletId integer, assetId integer, skip integer)

    RETURNS items AS $$
    DECLARE
        result items;
    BEGIN
        
        SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
        from (  
            SELECT i.id, i.asset_id, a.wallet_id, a.liability, i.amt, i.dttm
            FROM asset_items i JOIN assets a 
            ON i.asset_id = a.id
            WHERE a.wallet_id = walletId AND i.asset_id = assetId 
            ORDER BY i.dttm DESC LIMIT 50 OFFSET skip
        ) t;

        SELECT count(*) cnt into result.total_cnt 
        FROM asset_items i JOIN assets a
        ON i.asset_id = a.id
        WHERE a.wallet_id = walletId AND i.asset_id = assetId;

        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'caught at get_asset_items';
    END;
    $$ LANGUAGE plpgsql;






