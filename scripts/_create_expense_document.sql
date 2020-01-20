/**
 * EXPENSES
 * Set the text search document. 
 */


CREATE OR REPLACE FUNCTION create_expense_document() RETURNS trigger AS $expense_document$
    DECLARE
        catName text;
        amtChar text := TO_CHAR(NEW.amt, 'FM999999999999999999.9999');
    BEGIN

        SELECT name INTO catName FROM categories WHERE id = NEW.category_id;

        NEW.document :=
            to_tsvector('english', COALESCE(new.note,'')) ||
            to_tsvector('english', COALESCE(new.vendor,'')) ||
            to_tsvector('english', COALESCE(amtChar,'')) ||
            to_tsvector('english', COALESCE(catName,''));

        RETURN NEW;
    EXCEPTION
        WHEN others THEN
            RAISE EXCEPTION 'caught at create_expense_document - % %', SQLERRM, SQLSTATE;
    END;
$expense_document$ LANGUAGE plpgsql;



CREATE TRIGGER expense_document
    BEFORE INSERT OR UPDATE ON expenses
    FOR EACH ROW EXECUTE PROCEDURE create_expense_document();
    
    
    

