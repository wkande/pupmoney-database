/**
 * Gets a list of paginated expense-items. The pagination is based on a date range. The total row count 
 * is included for all records outside the pagination range.
 */


CREATE OR REPLACE FUNCTION get_expense_items(q TEXT, dttmStart DATE, dttmEnd DATE, walletId integer, expID integer, skip integer)

    RETURNS items AS $$
    DECLARE
        result items;
    BEGIN


    IF length(q) = 0 THEN
            SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
            from (  
                SELECT i.id, i.expense_id, e.wallet_id, i.document, i.amt, i.dttm, i.note, i.vendor
                FROM expense_items i JOIN expenses e
                ON i.expense_id = e.id
                WHERE i.dttm between dttmStart AND dttmEnd AND e.wallet_id = walletId AND i.expense_id = expId 
                ORDER BY i.dttm DESC LIMIT 50 OFFSET skip
            ) t;

            SELECT count(*) cnt into result.total_cnt 
            FROM expense_items i JOIN expenses e
            ON i.expense_id = e.id
            WHERE i.dttm between dttmStart AND dttmEnd AND e.wallet_id = walletId AND i.expense_id = expID;

        ELSE
            /*SELECT row_to_json(t)
            FROM (
                SELECT coalesce(sum(amt), 0) amt, count(amt) cnt
                INTO result 
                FROM expense_items 
                WHERE document @@ to_tsquery(q)
                AND dttm between dttmStart AND dttmEnd AND expense_id = expId
            ) t;*/

            SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
            from (  
                SELECT i.id, i.expense_id, e.wallet_id, i.document, i.amt, i.dttm, i.note, i.vendor
                FROM expense_items i JOIN expenses e
                ON i.expense_id = e.id
                WHERE i.document @@ to_tsquery(q)
                AND i.dttm between dttmStart AND dttmEnd AND e.wallet_id = walletId AND i.expense_id = expId 
                ORDER BY i.dttm DESC LIMIT 50 OFFSET skip
            ) t;

            SELECT count(*) cnt into result.total_cnt 
            FROM expense_items i JOIN expenses e
            ON i.expense_id = e.id
            WHERE i.document @@ to_tsquery(q)
            AND i.dttm between dttmStart AND dttmEnd AND e.wallet_id = walletId AND i.expense_id = expID;

        END IF;


        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'get_expense_items - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;






