/**
 * Creates a new user and a default wallet both in shard 0. The wallet shard parameter 
 * is stored with the wallet.
 */


CREATE OR REPLACE FUNCTION add_user(fullname TEXT, email text, shardNumb integer) 
    RETURNS json AS $$
    DECLARE
        user_id bigint = nextval('users_id_seq');
        wallet_id bigint = nextval('wallets_id_seq');
        default_wallet_name text = 'Default Wallet';
        r_Return record;
    BEGIN
        INSERT INTO users (id, name, email) VALUES (user_id, fullname, email);

        INSERT INTO wallets (id, user_id, name, default_wallet, shard) VALUES (wallet_id, user_id, default_wallet_name, 1, shardNumb);

        SELECT u.id, u.email, u.name, u.member_since, u.sub_expires, u.sys_admin
        INTO r_Return 
        FROM USERS u 
        WHERE u.id = user_id;

        RETURN row_to_json(r_Return);
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'caught at add_user';
    END;
    $$ LANGUAGE plpgsql;





