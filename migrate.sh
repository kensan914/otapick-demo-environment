#!/bin/sh

CMD_PREFIX=""
if [ "$1" = "win" ]; then
  CMD_PREFIX="winpty"
else
  CMD_PREFIX=""
fi

DB_NAME="otapick_demo"
CMD_MYSQL="mysql"
DROP_SQL="DROP DATABASE $DB_NAME;"
CREATE_SQL="CREATE DATABASE $DB_NAME;"

CMD_DOCKER_MYSQL="$CMD_PREFIX docker exec -i otapick_demo_db $CMD_MYSQL -u root -pmysql-password -e"


$CMD_DOCKER_MYSQL "$DROP_SQL"
$CMD_DOCKER_MYSQL "$CREATE_SQL"

SHOW_SQL="show databases;"
$CMD_DOCKER_MYSQL "$SHOW_SQL"


CMD_DOCKER_PYTHON="$CMD_PREFIX docker exec -it otapick_demo_python sh -c"
$CMD_DOCKER_PYTHON "cd otapick && python manage.py showmigrations"

MIGRATION_PATH_ARRAY=(
  "/usr/local/lib/python3.7/site-packages/allauth/account"
  "/usr/local/lib/python3.7/site-packages/allauth/socialaccount"
  "/usr/local/lib/python3.7/site-packages/django/contrib/admin/"
  "/usr/local/lib/python3.7/site-packages/rest_framework/authtoken"
  "/usr/local/lib/python3.7/site-packages/django/contrib/contenttypes"
  "/usr/local/lib/python3.7/site-packages/django/contrib/auth/"
  "/usr/local/lib/python3.7/site-packages/django/contrib/sessions/"
  "/usr/local/lib/python3.7/site-packages/django/contrib/sites/"
  "/var/www/otapick/main/"
  "/var/www/otapick/image/"
  "/var/www/otapick/account/"
  "/var/www/otapick/survey/"
)
CMD_RM_MIGRATIONS="rm -f ./migrations/00*"
for migration_path in "${MIGRATION_PATH_ARRAY[@]}"
do
  echo "initialize migration files $migration_path."
  $CMD_DOCKER_PYTHON "cd $migration_path && $CMD_RM_MIGRATIONS"
done

$CMD_DOCKER_PYTHON "cd otapick && python manage.py showmigrations"
$CMD_DOCKER_PYTHON "cd otapick && python manage.py makemigrations"
$CMD_DOCKER_PYTHON "cd otapick && python manage.py migrate"
