 # Database Migrations

[Flyway](https://documentation.red-gate.com/fd/postgresql-184127604.html) is a database migration tool. We will use the flyway migration scripts that will migrate our database from our local workstation to a container running an `init container`, which will run the migration scripts before starting our REST API.

We will work with `PostgreSQL ^14` as our primary database, so we would need to setup our local environment accordingly.

## Local `PostgreSQL` setup

> NOTE: The steps mentioned below are only for MacOS.

- Install `postgres` locally:

```bash
brew install postgresql@15
# validate installation
psql --version
```

- After `postgres` is installed, we need the postgres service up and running:

```bash
brew service start postgres@15
```

- Let's start by connecting to the default `postgres` database:

```bash
psql postgres
```

- Create a role in postgres and assign permissions:

```bash
CREATE ROLE <user> WITH LOGIN PASSWORD <user_password>;
ALTER ROLE <user> CREATEDB;
# if required, add other permissions as well: REPLICATION, CREATEROLE, etc
\du # to list all users and permissions
\q # quit postgres cli
```

- Connect to `postgres` db using new role created, create and connect to a new database:

```bash
# connect to db using new user
psql -d postgres -U <user>
# create a database
CREATE DATABASE <db_name>;
\c <db_name> # connect to new db
```

## Working with Flyway

