# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

# Docker and Docker Compose

### `docker-compose build`

Will build containers that are based on Dockerfile
- `... service_name` will run the build for specific container

### `docker-compose up`

Will spin up the containers and make the services availble (ctrl-c to break and stop service)
- `... -d`:  will run the process dettached, freeing the terminal for commands
- `... -d service_name`: will run just a specific service

### `docker-compose logs`

List the logs from the services (web, db)
- `... service_name` will list logs only for the specific service
- `... --tail 100 service_name` limit the output to the last 100 lines (useful when logs are huge)
- `... --tail 100 --follow service_name` will keep listening the service for new log entries (ctrl+c to break and stop listening)

### `docker-compose ps`

Will list all services of the project listed, inside current `docker-compose.yml`.
To list all docker containers, we can use `docker ps`.

### `docker-compose stop`

Will stop all services, we can specify a service `docker-compose stop web`

## `docker ps`

Will list all containers that are running on docker, it contains useful information like creation date, ports mapped, container id and container name.

## `docker stop container_name/container_id`

Will stop a container



# Gems:

- mongoid: Connects to mongodb and replace active record (https://docs.mongodb.com/mongoid/current/)
           To visualize the database we can do it using Mongo Compass (https://www.mongodb.com/products/compass)

- mongoid_search: Full text search on documents, it creates indexes that permit the search in multiple fields (https://github.com/mongoid/mongoid_search)

# Env

* Ruby version

* System dependencies

* Configuration

* Database creation

run rails db:setup

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
