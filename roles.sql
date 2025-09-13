
\restrict iNyEZKxfBV8w60S9ae7RtgELKzznaArkqP8X2m2RlkwQDCIBNl7dxA5dey3TnzG

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict iNyEZKxfBV8w60S9ae7RtgELKzznaArkqP8X2m2RlkwQDCIBNl7dxA5dey3TnzG

RESET ALL;
