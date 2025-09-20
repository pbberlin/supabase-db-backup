
\restrict 2i5rDQq2nn9JPLum7w5OksE49MaSFNMIW71TIF5vSgZ5E828ooVHCKrFM4FXceQ

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict 2i5rDQq2nn9JPLum7w5OksE49MaSFNMIW71TIF5vSgZ5E828ooVHCKrFM4FXceQ

RESET ALL;
