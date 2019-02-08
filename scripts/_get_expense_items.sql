/**
 * Gets a list of paginated expense-items. The pagination is based on a date range. The total row count 
 * is included for all records outside the pagination range.
 */


CREATE OR REPLACE FUNCTION get_expense_items(dttmStart DATE, dttmEnd DATE, walletId integer, expID integer, skip integer)

    RETURNS items AS $$
    DECLARE
        result items;
    BEGIN
        
        SELECT array_to_json(array_agg(row_to_json(t))) INTO result.items 
        from (  
            SELECT i.id, i.expense_id, e.wallet_id, i.amt, i.dttm, i.note, i.vendor
            FROM expense_items i JOIN expenses e
            ON i.expense_id = e.id
            WHERE i.dttm between dttmStart AND dttmEnd AND wallet_id = walletId AND i.expense_id = expId 
            ORDER BY i.dttm DESC LIMIT 50 OFFSET SKIP
        ) t;

        SELECT count(*) cnt into result.total_cnt 
        FROM expense_items i JOIN expenses e
        ON i.expense_id = e.id
        WHERE i.dttm between dttmStart AND dttmEnd AND e.wallet_id = walletId AND i.expense_id = expID;

        RETURN result;
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'caught at get_expense_items';
    END;
    $$ LANGUAGE plpgsql;






