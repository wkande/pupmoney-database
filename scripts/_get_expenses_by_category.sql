/**
 * Gets a list of expenses within a date range, by cat_id and an optional text search.
 */


CREATE OR REPLACE FUNCTION get_expenses_by_category(q TEXT, dttmStart DATE, dttmEnd DATE, walletId integer, catID integer, skip integer)

    RETURNS items AS $$
    DECLARE
        result items;
    BEGIN


    IF length(q) = 0 THEN
            SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
            from (  
                SELECT e.id, e.category_id, c.id c_id, c.name c_name, c.wallet_id, e.document, e.amt, e.dttm, e.note, e.vendor
                FROM expenses e JOIN categories c
                ON e.category_id = c.id
                WHERE e.dttm between dttmStart AND dttmEnd AND c.wallet_id = walletId AND e.category_id = catId 
                ORDER BY e.dttm DESC, e.id DESC LIMIT 50 OFFSET skip
            ) t;

            SELECT count(*) cnt into result.total_cnt 
            FROM expenses e JOIN categories c
            ON e.category_id = c.id
            WHERE e.dttm between dttmStart AND dttmEnd AND c.wallet_id = walletId AND e.category_id = catID;

        ELSE
            SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
            from (  
                SELECT e.id, e.category_id, c.id c_id, c.name c_name, c.wallet_id, e.document, e.amt, e.dttm, e.note, e.vendor
                FROM expenses e JOIN categories c
                ON e.category_id = c.id
                WHERE e.document @@ to_tsquery(q)
                AND e.dttm between dttmStart AND dttmEnd AND c.wallet_id = walletId AND e.category_id = catId 
                ORDER BY e.dttm DESC, e.id DESC LIMIT 50 OFFSET skip
            ) t;

            SELECT count(*) cnt into result.total_cnt 
            FROM expenses e JOIN categories c
            ON e.category_id = c.id
            WHERE e.document @@ to_tsquery(q)
            AND e.dttm between dttmStart AND dttmEnd AND c.wallet_id = walletId AND e.category_id = catID;

        END IF;


        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'get_expenses_by_category - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;






