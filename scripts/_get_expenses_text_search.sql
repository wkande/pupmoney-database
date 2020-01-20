/**
 * Gets a summary list of expenses by text search for all categories.
 */


CREATE OR REPLACE FUNCTION get_expenses_text_search(lang TEXT, q TEXT, walletId integer,  skip integer)

    RETURNS items AS $$
    DECLARE
        result items;
    BEGIN

        SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
        from (  
            SELECT e.id, e.category_id, c.wallet_id, c.id c_id, c.name c_name, e.document, e.amt, e.dttm, e.note, e.vendor
            FROM expenses e JOIN categories c
            ON e.category_id = c.id
            WHERE e.document @@ to_tsquery('english', q)
            AND c.wallet_id = walletId  
            ORDER BY e.dttm DESC, e.id DESC LIMIT 50 OFFSET skip
        ) t;

        SELECT count(*) cnt into result.total_cnt 
        FROM expenses e JOIN categories c
        ON e.category_id = c.id
        WHERE e.document @@ to_tsquery('english', q)
        AND c.wallet_id = walletId;


        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'get_expenses_text_search - %; %; %', SQLERRM, SQLSTATE, lang;
    END;
    $$ LANGUAGE plpgsql;






