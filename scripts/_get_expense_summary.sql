/**
 * Gets a summary list of expenses amounts within a date range and an optional text search.
 */


CREATE OR REPLACE FUNCTION get_expense_summary(q TEXT, dttmStart DATE, dttmEnd DATE, expId integer)

    RETURNS json AS $$
    DECLARE
        result json;
    BEGIN
        IF length(q) = 0 THEN
            SELECT row_to_json(t)
            FROM (
                SELECT coalesce(sum(amt), 0) amt, count(amt) cnt
                INTO result 
                FROM expense_items 
                WHERE dttm between dttmStart AND dttmEnd AND expense_id = expId
            ) t;
        ELSE
            SELECT row_to_json(t)
            FROM (
                SELECT coalesce(sum(amt), 0) amt, count(amt) cnt
                INTO result 
                FROM expense_items 
                WHERE document @@ to_tsquery(q)
                AND dttm between dttmStart AND dttmEnd AND expense_id = expId
            ) t;
        END IF;

        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'get_expense_summary - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;






