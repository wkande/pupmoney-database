/**
 * EXPENSES
 * Once an expense has been created it can never leave its wallet. This function 
 * checks to make sure that any change to the expense_id stays within the original wallet. 
 */


CREATE OR REPLACE FUNCTION check_expense_category_id() RETURNS trigger AS $check_expense_category_id$
    DECLARE
        oldWalletId integer;
        newWalletId integer;
    BEGIN

        SELECT wallet_id INTO oldWalletId FROM categories WHERE id = OLD.category_id;

        select wallet_id into newWalletID from categories where id = NEW.category_id;

        IF oldWalletId != newWalletId THEN
            RAISE EXCEPTION 'you cannot move an expense into a category from another wallet';
        END IF;

        RETURN NEW;

    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'caught at check_expense_category_id - % %', SQLERRM, SQLSTATE;
    END;
$check_expense_category_id$ LANGUAGE plpgsql;



CREATE TRIGGER expense_category_id
    BEFORE UPDATE ON expenses
    FOR EACH ROW EXECUTE PROCEDURE check_expense_category_id();
    
    
    

