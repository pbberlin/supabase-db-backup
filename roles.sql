
\restrict xr1Q9v9cw0yEFVM0hLqghLArKDFyMewEW24PV0NGndjnI3ytH51Ry0WTLkEATyj

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict xr1Q9v9cw0yEFVM0hLqghLArKDFyMewEW24PV0NGndjnI3ytH51Ry0WTLkEATyj

RESET ALL;
