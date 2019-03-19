/**
 * Deletes all wallet child records from the wallet shard.
 */


CREATE OR REPLACE FUNCTION delete_wallet_shard(walletId integer) 
    RETURNS boolean AS $$
    DECLARE
    BEGIN

        DELETE FROM categories where wallet_id = walletId;

        return TRUE;

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'caught at finalize_wallet - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;




