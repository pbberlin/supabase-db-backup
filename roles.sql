
\restrict NGYRQaCyJpRHbSgKmEpJbmaec5Czc75smGRh9MdpxdumzoqC0n8iB8hWWQV4uW5

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict NGYRQaCyJpRHbSgKmEpJbmaec5Czc75smGRh9MdpxdumzoqC0n8iB8hWWQV4uW5

RESET ALL;
