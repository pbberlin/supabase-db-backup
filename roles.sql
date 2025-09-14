
\restrict U5iEuWljSYBbsTtHVmAG0ljmf5dz8VyKJxp2zady1tJNPg0Mh9d9ucW6sbng9zv

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict U5iEuWljSYBbsTtHVmAG0ljmf5dz8VyKJxp2zady1tJNPg0Mh9d9ucW6sbng9zv

RESET ALL;
