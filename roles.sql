
\restrict mapCB1sA03ZAYA4Yfwj4TmyaZHgRX43FaeqFzcxdYl0ueFA5Bwqi9tj9321dX5I

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict mapCB1sA03ZAYA4Yfwj4TmyaZHgRX43FaeqFzcxdYl0ueFA5Bwqi9tj9321dX5I

RESET ALL;
