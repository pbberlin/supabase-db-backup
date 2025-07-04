

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


CREATE EXTENSION IF NOT EXISTS "pg_net" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgsodium";






CREATE EXTENSION IF NOT EXISTS "plv8" WITH SCHEMA "pg_catalog";






CREATE EXTENSION IF NOT EXISTS "moddatetime" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pg_graphql" WITH SCHEMA "graphql";






CREATE EXTENSION IF NOT EXISTS "pg_stat_statements" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "pgjwt" WITH SCHEMA "extensions";






CREATE EXTENSION IF NOT EXISTS "supabase_vault" WITH SCHEMA "vault";






CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA "extensions";






CREATE TYPE "public"."rec" AS (
	"i" integer,
	"t" "text"
);


ALTER TYPE "public"."rec" OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."pool_add_account"("arg_num" integer) RETURNS bigint
    LANGUAGE "plpgsql"
    AS $$
  DECLARE
    new_account_id bigint;
  BEGIN
    INSERT INTO public.pool(id, provider)
        VALUES ( pool_add_account.arg_num, CONCAT( 'ChatGPT #', pool_add_account.arg_num::varchar )  )
        RETURNING contract INTO new_account_id;
    RETURN new_account_id;
  END;
$$;


ALTER FUNCTION "public"."pool_add_account"("arg_num" integer) OWNER TO "postgres";

SET default_tablespace = '';

SET default_table_access_method = "heap";


CREATE UNLOGGED TABLE "public"."pool" (
    "id" integer DEFAULT 0 NOT NULL,
    "provider" "text",
    "description" "text",
    "rpm" integer DEFAULT 0 NOT NULL,
    "rpm_max" integer DEFAULT 0 NOT NULL,
    "rpd" integer DEFAULT 0 NOT NULL,
    "rpd_max" integer DEFAULT 0 NOT NULL,
    "tpm" integer DEFAULT 0 NOT NULL,
    "tpm_max" integer DEFAULT 0 NOT NULL,
    "tpr_max" integer DEFAULT 0 NOT NULL,
    "updated_m" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "updated_d" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "updated" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    CONSTRAINT "constr_rpm_max" CHECK (("rpm" <= "rpm_max")),
    CONSTRAINT "constr_rpm_min" CHECK (("rpm" >= 0))
);


ALTER TABLE "public"."pool" OWNER TO "postgres";


COMMENT ON TABLE "public"."pool" IS 'accounts with ChatGPT and other providers. Keeping rate limits';



COMMENT ON COLUMN "public"."pool"."id" IS 'primay';



COMMENT ON COLUMN "public"."pool"."provider" IS 'for instance: ChatGPT #1';



COMMENT ON COLUMN "public"."pool"."description" IS 'start date 01.06.2023 - one year';



COMMENT ON COLUMN "public"."pool"."rpm" IS 'requests per minute';



COMMENT ON COLUMN "public"."pool"."rpm_max" IS 'requests per minute - allowed';



COMMENT ON COLUMN "public"."pool"."rpd" IS 'requests per day';



COMMENT ON COLUMN "public"."pool"."rpd_max" IS 'requests per day - allowed';



COMMENT ON COLUMN "public"."pool"."tpm" IS 'tokens   per minute';



COMMENT ON COLUMN "public"."pool"."tpm_max" IS 'tokens   per minute - allowed';



COMMENT ON COLUMN "public"."pool"."tpr_max" IS 'max_tokens per request - for instance 2048';



COMMENT ON COLUMN "public"."pool"."updated_m" IS 'last reset of the *minutely* limit';



COMMENT ON COLUMN "public"."pool"."updated_d" IS 'last reset of the *daily*    limit';



COMMENT ON COLUMN "public"."pool"."updated" IS 'last update of any column';



CREATE OR REPLACE FUNCTION "public"."pool_upate"("arg_id" integer, "decr" boolean) RETURNS SETOF "public"."pool"
    LANGUAGE "plpgsql"
    AS $$
  BEGIN
    -- IF EXISTS (SELECT FROM orders) THEN
    IF decr THEN
      UPDATE public.pool
      SET    rpm       = rpm - 1,
             updated_m = now()
      WHERE  id = arg_id;
    ELSE
      UPDATE public.pool
      SET    rpm       = rpm + 1,
             updated_m = now()
      WHERE  id = arg_id;
    END IF;


    RETURN QUERY
      SELECT * FROM public.pool;
  END
$$;


ALTER FUNCTION "public"."pool_upate"("arg_id" integer, "decr" boolean) OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."set_of_records"() RETURNS SETOF "public"."rec"
    LANGUAGE "plv8"
    AS $$
    // plv8.return_next() stores records in an internal tuplestore,
    // and return all of them at the end of function.
    plv8.return_next( { "i": 1, "t": "a" } );
    plv8.return_next( { "i": 2, "t": "b" } );

    // You can also return records with an array of JSON.
    return [ { "i": 3, "t": "c" }, { "i": 4, "t": "d" } ];
$$;


ALTER FUNCTION "public"."set_of_records"() OWNER TO "postgres";


CREATE OR REPLACE FUNCTION "public"."sync_users"() RETURNS "trigger"
    LANGUAGE "plpgsql" SECURITY DEFINER
    SET "search_path" TO 'public'
    AS $$
BEGIN
  INSERT INTO public.users (
    id, 
    email, 
    avatar_url
  )
  VALUES (	
    new.id, 
		new.email,
		new.raw_user_meta_data ->> 'avatar_url'
   );
  return new;
END;
$$;


ALTER FUNCTION "public"."sync_users"() OWNER TO "postgres";


CREATE TABLE IF NOT EXISTS "public"."dialogs" (
    "id" "uuid" DEFAULT "extensions"."uuid_generate_v4"() NOT NULL,
    "id2" integer NOT NULL,
    "user_id" "uuid" NOT NULL,
    "inserted" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "updated" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "name" character varying(255) NOT NULL,
    "text" "text",
    "messages" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL
);


ALTER TABLE "public"."dialogs" OWNER TO "postgres";


COMMENT ON TABLE "public"."dialogs" IS 'a single chatGPT dialog - with reference to a user';



COMMENT ON COLUMN "public"."dialogs"."id2" IS 'an auto increment for convenience';



COMMENT ON COLUMN "public"."dialogs"."user_id" IS 'foreign key ref to users.id';



COMMENT ON COLUMN "public"."dialogs"."messages" IS 'messages in jsonb';



ALTER TABLE "public"."dialogs" ALTER COLUMN "id2" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."dialogs_id2_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



CREATE TABLE IF NOT EXISTS "public"."users" (
    "id" "uuid" NOT NULL,
    "id2" integer NOT NULL,
    "inserted" timestamp with time zone DEFAULT "timezone"('utc'::"text", "now"()) NOT NULL,
    "updated" timestamp with time zone,
    "email" character varying(128) NOT NULL,
    "username" character varying(255),
    "source" character varying(255),
    "firstname" character varying(64),
    "lastname" "text",
    "avatar_url" "text",
    "attrs" "jsonb" DEFAULT '{}'::"jsonb" NOT NULL,
    "assignmentid" "text",
    "hitid" "text",
    "turksubmitto" "text",
    "workerid" "text",
    CONSTRAINT "email_min_length" CHECK (("char_length"(("email")::"text") >= 3))
);


ALTER TABLE "public"."users" OWNER TO "postgres";


COMMENT ON TABLE "public"."users" IS 'extended columns for table auth.users';



COMMENT ON COLUMN "public"."users"."id" IS 'copy of auth.users.id';



COMMENT ON COLUMN "public"."users"."id2" IS 'an auto increment for convenience';



COMMENT ON COLUMN "public"."users"."username" IS 'should be unique - but cant because of insert trigger from auth.users';



COMMENT ON COLUMN "public"."users"."source" IS 'mechanial turk or company name of expert';



ALTER TABLE "public"."users" ALTER COLUMN "id2" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME "public"."users_id2_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);



ALTER TABLE ONLY "public"."dialogs"
    ADD CONSTRAINT "dialogs_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."pool"
    ADD CONSTRAINT "pool_pkey" PRIMARY KEY ("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_email_key" UNIQUE ("email");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_pkey" PRIMARY KEY ("id");



CREATE INDEX "idx_fk_user_id" ON "public"."dialogs" USING "btree" ("user_id");



CREATE OR REPLACE TRIGGER "update_timestamp_1" BEFORE UPDATE ON "public"."users" FOR EACH ROW EXECUTE FUNCTION "extensions"."moddatetime"('updated');



CREATE OR REPLACE TRIGGER "update_timestamp_2" BEFORE UPDATE ON "public"."dialogs" FOR EACH ROW EXECUTE FUNCTION "extensions"."moddatetime"('updated');



CREATE OR REPLACE TRIGGER "update_timestamp_3" BEFORE UPDATE ON "public"."pool" FOR EACH ROW EXECUTE FUNCTION "extensions"."moddatetime"('updated');



ALTER TABLE ONLY "public"."dialogs"
    ADD CONSTRAINT "fk_user" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id");



ALTER TABLE ONLY "public"."users"
    ADD CONSTRAINT "users_id_fkey" FOREIGN KEY ("id") REFERENCES "auth"."users"("id") ON DELETE CASCADE;



ALTER TABLE "public"."dialogs" ENABLE ROW LEVEL SECURITY;


CREATE POLICY "public.dialogs-delete" ON "public"."dialogs" FOR DELETE USING (("auth"."uid"() = "user_id"));



CREATE POLICY "public.dialogs-insert" ON "public"."dialogs" FOR INSERT WITH CHECK (("auth"."uid"() = "user_id"));



CREATE POLICY "public.dialogs-select" ON "public"."dialogs" FOR SELECT USING (("auth"."uid"() = "user_id"));



CREATE POLICY "public.dialogs-update" ON "public"."dialogs" FOR UPDATE USING (("auth"."uid"() = "user_id"));





ALTER PUBLICATION "supabase_realtime" OWNER TO "postgres";


ALTER PUBLICATION "supabase_realtime" ADD TABLE ONLY "public"."dialogs";






REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";



































































































































































































GRANT ALL ON FUNCTION "public"."pool_add_account"("arg_num" integer) TO "anon";
GRANT ALL ON FUNCTION "public"."pool_add_account"("arg_num" integer) TO "authenticated";
GRANT ALL ON FUNCTION "public"."pool_add_account"("arg_num" integer) TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."pool" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."pool" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."pool" TO "service_role";



GRANT ALL ON FUNCTION "public"."pool_upate"("arg_id" integer, "decr" boolean) TO "anon";
GRANT ALL ON FUNCTION "public"."pool_upate"("arg_id" integer, "decr" boolean) TO "authenticated";
GRANT ALL ON FUNCTION "public"."pool_upate"("arg_id" integer, "decr" boolean) TO "service_role";



GRANT ALL ON FUNCTION "public"."set_of_records"() TO "anon";
GRANT ALL ON FUNCTION "public"."set_of_records"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."set_of_records"() TO "service_role";



GRANT ALL ON FUNCTION "public"."sync_users"() TO "anon";
GRANT ALL ON FUNCTION "public"."sync_users"() TO "authenticated";
GRANT ALL ON FUNCTION "public"."sync_users"() TO "service_role";


















GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."dialogs" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."dialogs" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."dialogs" TO "service_role";



GRANT ALL ON SEQUENCE "public"."dialogs_id2_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."dialogs_id2_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."dialogs_id2_seq" TO "service_role";



GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."users" TO "anon";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."users" TO "authenticated";
GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE "public"."users" TO "service_role";



GRANT ALL ON SEQUENCE "public"."users_id2_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."users_id2_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."users_id2_seq" TO "service_role";



ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS TO "service_role";






ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLES TO "service_role";






























RESET ALL;
