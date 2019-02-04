DROP FUNCTION delete_Wallet(u_id integer, wallet_id integer, OUT success bool);


CREATE OR REPLACE FUNCTION delete_Wallet(u_id integer, wallet_id integer, OUT success bool) 
    RETURNS bool AS $$
    DECLARE
        r_Return record;
        r_Cnt integer;
    BEGIN
        -- This serves as two things.
        -- 1) Makes sure one wallet is left
        -- 2) Will be 0 if the user is trying to access someone elses wallet
        --    since the user_id is guaranteed to be true by JWT
        SELECT count(*) INTO r_Cnt FROM WALLETS WHERE user_id = u_id;
        IF r_Cnt < 2 THEN
            RAISE 'One wallet must remain: wallet_id: %', wallet_id USING ERRCODE = '23505'; -- 23505 one must remain
        ELSE
            EXECUTE format('
                DELETE FROM WALLETS
                WHERE user_id = $1 AND id = $2
                RETURNING TRUE')
            USING   u_id, wallet_id
            INTO    success;
        END IF;
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'caught at delete_Wallet';
    END;
    $$ LANGUAGE plpgsql;


