/**
 * ASSET_ITEMS
 * If the expense is a credit then the amt in the expense_items table can only be negative. 
 */


CREATE OR REPLACE FUNCTION check_expense_item_credit_amt() RETURNS trigger AS $expense_item_credit_amt$
    DECLARE

    BEGIN
    
        IF NEW.credit = 1 AND NEW.amt > 0 THEN
            RAISE EXCEPTION 'Credits must have a negative amt.';
        END IF;

        RETURN NEW;
    END;
$expense_item_credit_amt$ LANGUAGE plpgsql;



CREATE TRIGGER expense_item_credit_amt
    BEFORE INSERT OR UPDATE ON expense_items
    FOR EACH ROW EXECUTE PROCEDURE check_expense_item_credit_amt();
    
    
    

