# 🗄️ Database Migrations

[Flyway](https://documentation.red-gate.com/fd/postgresql-184127604.html) is a database migration tool. We will use the flyway migration scripts that will migrate our database from our local workstation to a container running an `init container`, which will run the migration scripts before starting our REST API.

We will work with `PostgreSQL ^14` as our primary database, so we would need to setup our local environment accordingly.

## ⏬ Local _PostgreSQL_ setup

> NOTE: The steps mentioned below are only for MacOS. For other distros, please refer to the [official Postgresql documentation](https://www.postgresql.org/download/).

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

## 🚚 Working with Flyway

> NOTE: The steps mentioned below are only for MacOS. For other distros, please refer to the [official Flyway documentation](https://www.red-gate.com/products/flyway/editions).

- Install `flyway` locally:

  ```bash
  brew install flyway
  # verify installation
  flyway version
  ```

- Creating migration scripts:
  Migration scripts ending with `.sql` are the scripts used to migrate/setup our database using `flyway` for SQL based migrations. These should be placed in a folder called `sql`, with proper naming conventions as mentioned in the [documentation](https://documentation.red-gate.com/fd/migrations-184127470.html).

- Create a `flyway.conf` migration configuration file:
  This file contains the database connection URL, which connects to our database instance/service. It also contains the `username` and `password` for the database we connect to and run the migrations on. For more details on the configuration file, refer [this documentation](https://documentation.red-gate.com/fd/configuration-files-184127472.html).
  Alternatively, you can also follow the [`example.flyway.conf`](./example.flyway.conf) file for configuration options.

- Using environment variables:
  Since we will use the kubernetes `Secret` resource to configure our flyway environment variables, we just need to follow the naming convention for the variables in the `flyway.conf` configuration file:

  ```ini
  flyway.url=${DB_FLYWAY_CONNECTION_URL}
  flyway.user=${DB_FLYWAY_USERNAME}
  flyway.password=${DB_FLYWAY_PASSWORD}
  ```

- To run migrations locally on a postgres service, we can configure the migration options in the `flyway.conf` file and run the `migrate command`.

  ```bash
  flyway migrate
  ```

> NOTE: If the migrations are already performed, or there are no migrations to be performed, flyway returns a no-op.

## 🐳 Containerize migrations

Here, we containerize the migration scripts and configuration files into a docker image. Since this image will run within an `initContainer` in a k8s deployment, this docker image does not need to run any _CMD_ to run the migrations (since this will be done within the `initContainer`). A `.dockerignore` file is also needed to prevent copying files and folders that are not required in the final build image.
