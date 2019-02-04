/**
 * EXPENSE_ITEMS
 * Once an expense_item has been created it can never leave its wallet. This function 
 * checks to make sure that any change to the expense_id stays within the original wallet. 
 */


CREATE OR REPLACE FUNCTION check_expense_item_expense_id() RETURNS trigger AS $expense_item_check_expense_id$
    DECLARE
        oldWalletId integer;
        newWalletId integer;
    BEGIN

        SELECT wallet_id INTO oldWalletId FROM expenses WHERE id = OLD.expense_id;

        select wallet_id into newWalletID from expenses where id = NEW.expense_id;

        IF oldWalletId != newWalletId THEN
            RAISE EXCEPTION 'you cannot move an expense_item into an expense from another wallet';
        END IF;
        RETURN NEW;
    END;
$expense_item_check_expense_id$ LANGUAGE plpgsql;



CREATE TRIGGER expense_item_check_expense_id
    BEFORE UPDATE ON expense_items
    FOR EACH ROW EXECUTE PROCEDURE check_expense_item_expense_id();
    
    
    

