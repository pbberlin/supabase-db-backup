
\restrict SZJsJ4IFhEZvVSjhSdcF9qXmU9fzogdsgm6CrCDrlwqeJp5Lekqer71xAs4XuNI

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict SZJsJ4IFhEZvVSjhSdcF9qXmU9fzogdsgm6CrCDrlwqeJp5Lekqer71xAs4XuNI

RESET ALL;
