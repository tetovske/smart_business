app-build:
	docker-compose build

app-up:
	docker-compose up

app-bundle:
	docker-compose run --rm smart-business-service bundle install

app-console:
	docker-compose run --rm smart-business-service bundle exec rails console

app-ash:
	docker-compose run --rm smart-business-service ash

app-db-create:
	docker-compose run --rm smart-business-service bundle exec rails db:create

app-db-migrate:
	docker-compose run --rm smart-business-service bundle exec rails db:migrate

app-db-rollback:
	docker-compose run --rm smart-business-service bundle exec rails db:rollback

app-db-ash:
	docker-compose run --rm smart-business-db psql