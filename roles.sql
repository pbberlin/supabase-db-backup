
\restrict 6ILhFGUXMsf6XhigOdW6p7AD1XyEo300Kv8pHWJkAHT5ql3YfxZfy0y37DTVaue

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict 6ILhFGUXMsf6XhigOdW6p7AD1XyEo300Kv8pHWJkAHT5ql3YfxZfy0y37DTVaue

RESET ALL;
