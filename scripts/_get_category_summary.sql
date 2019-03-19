/**
 * Gets a summary list of category amounts within a date range and an optional text search.
 */


CREATE OR REPLACE FUNCTION get_category_summary(q TEXT, dttmStart DATE, dttmEnd DATE, catId integer)

    RETURNS json AS $$
    DECLARE
        result json;
    BEGIN
        IF length(q) = 0 THEN
            SELECT row_to_json(t)
            FROM (
                SELECT coalesce(sum(amt), 0) amt, count(amt) cnt
                INTO result 
                FROM expenses 
                WHERE dttm between dttmStart AND dttmEnd AND category_id = catId
            ) t;
        ELSE
            SELECT row_to_json(t)
            FROM (
                SELECT coalesce(sum(amt), 0) amt, count(amt) cnt
                INTO result 
                FROM expenses 
                WHERE document @@ to_tsquery(q)
                AND dttm between dttmStart AND dttmEnd AND category_id = catId
            ) t;
        END IF;

        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'get_category_summary - % %', SQLERRM, SQLSTATE;
    END;
    $$ LANGUAGE plpgsql;






