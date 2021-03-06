#!/bin/sh

CMD_PREFIX=""
if [ "$1" = "win" ]; then
  CMD_PREFIX="winpty"
else
  CMD_PREFIX=""
fi


CMD_MYSQL="mysql"
DB_CONTAINER_NAME="otapick_demo_db"
DB_NAME="otapick_demo"
PYTHON_CONTAINER_NAME="otapick_demo_python"

CMD_DOCKER_MYSQL="$CMD_PREFIX docker exec -i $DB_CONTAINER_NAME $CMD_MYSQL -u root -pmysql-password -e"
CMD_DOCKER_MYSQL_DB="$CMD_PREFIX docker exec -i $DB_CONTAINER_NAME $CMD_MYSQL -u root -pmysql-password $DB_NAME -e"
# $CMD_DOCKER_MYSQL_DB "SET foreign_key_checks = 0;" # all_authなどが"Cannot add foreign key constraint"エラーを起こすため

CMD_DOCKER_PYTHON="$CMD_PREFIX docker exec -it $PYTHON_CONTAINER_NAME sh -c"
$CMD_DOCKER_PYTHON "cd otapick"

MIGRATION_PATH_ARRAY=(
  "/var/www/otapick/main/"
  "/var/www/otapick/image/"
  "/var/www/otapick/account/"
  "/var/www/otapick/survey/"
)
CMD_RM_MIGRATIONS="mkdir __migrations__; mv ./migrations/00* ./__migrations__/"
for migration_path in "${MIGRATION_PATH_ARRAY[@]}"
do
  echo "initialize migration files $migration_path."
  $CMD_DOCKER_PYTHON "cd $migration_path && $CMD_RM_MIGRATIONS"
done

$CMD_DOCKER_PYTHON "cd otapick && python manage.py makemigrations"

APP_LIST=(
  "main"
  "custom_account"
  "image"
  "survey"
)
for app in "${APP_LIST[@]}"
do
  $CMD_DOCKER_PYTHON "cd otapick && python manage.py makemigrations $app"
done

$CMD_DOCKER_PYTHON "cd otapick && python manage.py migrate"
