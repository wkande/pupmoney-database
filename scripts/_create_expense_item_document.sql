/**
 * EXPENSE_ITEMS
 * Set the text search document. 
 */


CREATE OR REPLACE FUNCTION create_expense_item_document() RETURNS trigger AS $expense_item_document$
    DECLARE
        expName text;
        amtChar text := TO_CHAR(NEW.amt, 'FM999999999999999999.9999');
    BEGIN

        SELECT name INTO expName FROM expenses WHERE id = NEW.expense_id;

        NEW.document :=
            to_tsvector('english', COALESCE(new.note,'')) ||
            to_tsvector('english', COALESCE(new.vendor,'')) ||
            to_tsvector('english',  COALESCE(amtChar,'')) ||
            to_tsvector('english', COALESCE(expName,''));

        RETURN NEW;
    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'could not set the text search document';
    END;
$expense_item_document$ LANGUAGE plpgsql;



CREATE TRIGGER expense_item_document
    BEFORE INSERT OR UPDATE ON expense_items
    FOR EACH ROW EXECUTE PROCEDURE create_expense_item_document();
    
    
    

