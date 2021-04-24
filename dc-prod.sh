echo docker-compose -f docker-compose.yml -f docker-compose.prod.yml "$@"
docker-compose -f docker-compose.yml -f docker-compose.prod.yml "$@"