

\! echo "--------------------------------\nPupMoney: Dropping schema\n--------------------------------"

DROP SCHEMA pupmoney CASCADE;
CREATE SCHEMA pupmoney AUTHORIZATION postgres;

-- GRANT ALL ON SCHEMA pupmoney TO postgres;
-- GRANT ALL ON SCHEMA pupmoney TO public;
COMMENT ON SCHEMA pupmoney IS 'pupmoney schema';
