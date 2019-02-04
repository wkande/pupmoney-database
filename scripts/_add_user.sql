

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

      
      -- Placeholder for the the shard in the return results (wallet_shard) included
        SELECT u.id, u.email, u.name, u.member_since, u.sub_expires, u.sys_admin --, 0 wallet_shard
        INTO r_Return 
        FROM USERS u 
        WHERE u.id = user_id;

        -- ??? Place the function parameter for the shard in the return results
        -- r_Return.wallet_shard = shardNumb;

        RETURN row_to_json(r_Return);
    EXCEPTION
        WHEN division_by_zero THEN
            RAISE NOTICE 'caught at add_user';
    END;
    $$ LANGUAGE plpgsql;


--\! echo "--------------------------------\nPupMoney: Add user warren\n--------------------------------"
--SELECT * from add_user('Warren Anderson', 'warren@wyoming.cc', '8cf90eba82926e8a0cf760846ef327052c5c2de1d18f05795ea7b24127adfae2', 0);
--SELECT * from add_user('Betsy Anderson', 'betsy@wyoming.cc', '8cf90eba82926e8a0cf760846ef327052c5c2de1d18f05795ea7b24127adfae2', 0);
--UPDATE users set sys_admin = 1 where id = 1;
--UPDATE wallets SET shares = ARRAY[1] WHERE user_id = 2;




