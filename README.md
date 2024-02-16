# Test Task for Geo position by IP or Host

## Intro

Note: *This repo was created as test task and do not used in production.*

Test task requirements was:

Need to write a simple API backed by any kind of database. The application should be able to store geolocation data in the database, based on IP address or URL. You can use [https://ipstack.com/](https://ipstack.com/) as a service provider for geolocation data. The API should be able to add, delete or provide geolocation data on the base of ip address or URL.

Application specification:

It should be a RESTful API
Keep it mind that the geolocation module should be written in the way that in the future it should be easy to change the service provider.
It is preferable that the API operates using JSON (for both input and output). Ideally it should follow JSON API standard.
The solution should also include base specs/tests coverage. If you don’t have enough time, write complete specs for selected endpoint or module.
As a bonus you can make all endpoints secure, not available to public.

## Setup

* Create network: `$ docker network create geo_test_task`
* Build image: `$ docker compose build`
* Go to container: `$ docker compose run app /bin/sh`
* Create database for development: `$ bin/rails db:create`
* Create database for test env: `$ RAILS_ENV=test bin/rails db:create`
* Load database schema: `$ bin/rails db:schema:load`
* Seed development database: `$ bin/rails db:seed` and copy client API key from output for future use in requests to service.
* Exit from container: `$ exit`
* Create file `.env.development.local` and fill it with your `IPSTACK_API_KEY` for IpStack service requests.

## Development

Run service `docker compose up`

Open browser [http://localhost:3000/api-docs/index.html](http://localhost:3000/api-docs/index.html) for test endpoints. Use API key from seed command.

## Testing

Run tests: `$ docker compose run app rspec spec`

## What can be improved?

* Add possibility to update cached record by PATCH request.
* In next version of API use JSON API spec when relations will be introduced.
* Implement JWT tokens for auth instead of standalone API keys.
* Extract common shared examples in tests when it will be needed.
* Move duplicated data to relation Models (Redions, Countries).
