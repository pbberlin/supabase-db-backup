
\restrict BcJUzbeRMPN5X2pXudvRZZkvOfFa9xiDVg23ix8Cih4KnSKhhy6a7qZoHhjQpC2

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict BcJUzbeRMPN5X2pXudvRZZkvOfFa9xiDVg23ix8Cih4KnSKhhy6a7qZoHhjQpC2

RESET ALL;
