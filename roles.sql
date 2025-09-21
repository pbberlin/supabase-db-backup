
\restrict toIbBOxV27eRhqKxFymKNofauX5LNBFoS16ahv19j11aCo36duNsQYGdY7zGkXB

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict toIbBOxV27eRhqKxFymKNofauX5LNBFoS16ahv19j11aCo36duNsQYGdY7zGkXB

RESET ALL;
