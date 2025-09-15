
\restrict EsYRYp38iEmwKLbBw0EDOtc6kvhMAfKYKjN4oSGIdb7qfEncJbNpdnC5NuwqifU

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

ALTER ROLE "anon" SET "statement_timeout" TO '3s';

ALTER ROLE "authenticated" SET "statement_timeout" TO '8s';

ALTER ROLE "authenticator" SET "statement_timeout" TO '8s';

\unrestrict EsYRYp38iEmwKLbBw0EDOtc6kvhMAfKYKjN4oSGIdb7qfEncJbNpdnC5NuwqifU

RESET ALL;
