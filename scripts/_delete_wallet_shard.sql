

CREATE OR REPLACE FUNCTION delete_wallet_shard(walletId integer) 
    RETURNS boolean AS $$
    DECLARE
        --r_Return record;
    BEGIN

        DELETE FROM assets where wallet_id = walletId;

        DELETE FROM expenses where wallet_id = walletId;

        DELETE FROM vendors where wallet_id = walletId;

        return TRUE;
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'caught at finalize_wallet';
    END;
    $$ LANGUAGE plpgsql;




