/**
 * Gets a summary list of paginated expenses amounts within the paginated date range.
 */


CREATE OR REPLACE FUNCTION get_expense_summary(dttmStart DATE, dttmEnd DATE, expId integer)

    RETURNS json AS $$
    DECLARE
        result json;
    BEGIN

        SELECT row_to_json(t)
        FROM (
            SELECT coalesce(sum(amt), 0) amt, count(amt) cnt
            INTO result 
            FROM expense_items 
            WHERE dttm between dttmStart AND dttmEnd AND expense_id = expId
        ) t;

        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'caught at get_expense_summary';
    END;
    $$ LANGUAGE plpgsql;






