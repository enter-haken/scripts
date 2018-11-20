#!/bin/bash

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -u|--user)
            USER="$2"
            shift 2 # shift to next parameter
            ;;
        -d|--database)
            DATABASE="$2"
            shift 2 # shift to next parameter
            ;;
        -s|--schema)
            SCHEMA="$2"
            shift 2 # shift to next parameter
            ;;
        -h|--help)
            HELP="HELP"
            shift 1 # shift to next parameter
            ;;
 
    esac
done
set -- "$POSITIONAL[@]"

if [ ! -z "$HELP" ]; then
    echo "db_init"
    echo "======="
    echo ""
    echo "This script generates a scaffold for creating a database from scratch."
    echo ""
    echo "parameters:"
    echo "-s | --schema: database schema (mandatory)"
    echo "-u | --user: database user name" 
    echo "-d | --database: database name, where the schema is created (database must exist, default \"postgres\")"
    echo ""
    echo "This script creates the following files:"
    echo ""
    echo "clean.sql"
    echo "- drops schema"
    echo ""
    echo "init.sql"
    echo "- recreate schema (drops everything related to the schema)"
    echo "- creates pgcrypto extension if not exists."
    echo ""
    echo "tables.sql"
    echo "- this file contains DDL related stuff like CREATE TABLE ..."
    echo ""
    echo "postcreate.sql"
    echo "- add additional COLUMNS like created_at to every table of the new database schema"
    echo "- add UPDATE TRIGGER for every table"
    echo ""
    echo "seed.sql"
    echo "- add some start values for the newly created tables"
    echo ""
    echo "Makefile"
    echo "- (re)create the database schema"
    exit 0
fi

if [ -z "$USER" ]; then
    USER="postgres"
fi

if [ -z "$SCHEMA" ]; then
    echo "missing mandatory -s | --schema"
    echo "when the Makefile is executed, the schema will be dropped if it exists!"
    exit 1
fi

if [ -z "$DATABASE" ]; then
    DATABASE="postgres"
fi
cat <<EOT >clean.sql
DROP SCHEMA IF EXISTS $SCHEMA CASCADE;
EOT

cat <<EOT >init.sql
CREATE SCHEMA $SCHEMA;

-- this is needed for gen_random_uuid();
-- the gen_random_uuid function will be created in the first schema
-- wich appears in the search path
-- the default is the public schema 
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- when postgres is compiled with python support
-- CREATE OR REPLACE LANGUAGE plpython3u;
EOT

cat <<EOT > tables.sql
SET search_path TO $SCHEMA,public;

-- Database tables can be added here
-- note: if more than one sql file is needed, it has to be added to the Makefile

--CREATE TABLE user_acccount(
--	id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
--    first_name VARCHAR(254),
--    last_name VARCHAR(254),
--    email_address VARCHAR(254),
--    password VARCHAR(254),
--    login VARCHAR(254),
--    signature VARCHAR(254)
--);
--
--CREATE TYPE role_level AS ENUM ('admin','user','guest');
--
--CREATE TABLE role(
--	id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
--    name VARCHAR(254) NOT NULL,
--    description VARCHAR(254),
--    role_level role_level NOT NULL DEFAULT 'guest'
--);
--
--CREATE TABLE user_in_role(
--    id_user_account UUID NOT NULL REFERENCES user_acccount(id),
--    id_role UUID NOT NULL REFERENCES role(id),
--    PRIMARY KEY(id_user_account, id_role)
--);
--
--CREATE TABLE privilege(
--	id UUID NOT NULL PRIMARY KEY DEFAULT gen_random_uuid(),
--    name VARCHAR(80),
--    description VARCHAR(254)
--);
--
--CREATE TABLE role_privilege(
--    id_role UUID NOT NULL REFERENCES role(id),
--    id_privilege UUID NOT NULL REFERENCES privilege(id),
--    PRIMARY KEY (id_role, id_privilege)
--);

EOT

cat <<EOT >postcreate.sql
SET search_path TO $SCHEMA,public;

-- this script should be executed after all DDL stuff is done.

CREATE FUNCTION metadata_trigger() RETURNS TRIGGER AS \$\$
BEGIN
    IF NEW.deleted = true THEN
        RAISE EXCEPTION 'can not update the deleted record %', NEW.id::text;
    END IF;

    NEW.updated_at := now();
    RETURN NEW;
END
\$\$ LANGUAGE plpgsql;

-- add created_at and updated_at columns to every table
-- and add update trigger to every table

DO \$\$
DECLARE
    row record;
BEGIN
    FOR row IN SELECT tablename FROM pg_tables WHERE schemaname = '$SCHEMA' LOOP
        EXECUTE 'ALTER TABLE ' || row.tablename ||
            ' ADD COLUMN created_at timestamp NOT NULL DEFAULT NOW();';

        EXECUTE 'ALTER TABLE ' || row.tablename ||
            ' ADD COLUMN updated_at timestamp NOT NULL DEFAULT NOW();';

        EXECUTE 'ALTER TABLE ' || row.tablename ||
            ' ADD COLUMN deleted boolean NOT NULL DEFAULT false';

        EXECUTE 'CREATE TRIGGER ' || row.tablename || '_trigger BEFORE UPDATE ON ' || row.tablename ||
            ' FOR EACH ROW EXECUTE PROCEDURE metadata_trigger();';
    END LOOP;
END
\$\$ LANGUAGE plpgsql
EOT

cat <<EOT > seed.sql
SET search_path TO $SCHEMA,public;

-- any seed operations can be added here

-- INSERT INTO test (test) VALUES ('TEST');
EOT

cat <<EOT > Makefile
.PHONY: help clean generate seed createdb
help:
	@echo "clean - drops schema $SCHEMA"
	@echo "generate - create schema, insert tables..."
	@echo "seed - insert inital values for tables"
	@echo "createdb - creates database $DATABASE, if not exists"
	@echo "all - target for: createdb, clean, generate, seed"

clean:
	psql -U $USER -d $DATABASE -f clean.sql

generate:
	psql -U $USER -d $DATABASE -f init.sql
	psql -U $USER -d $DATABASE -f tables.sql
	psql -U $USER -d $DATABASE -f postcreate.sql

seed:
	psql -U $USER -d $DATABASE -f seed.sql

createdb:
	if [ \`psql -U $USER -c "SELECT * from pg_database WHERE datname='$DATABASE'" | grep row | cut -c2\` -eq "0" ]; then \\
	    createdb -U postgres $DATABASE; \\
	fi;

all: createdb clean generate seed
EOT
