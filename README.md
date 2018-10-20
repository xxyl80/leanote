docker leanote based centos 7

run:
    docker-compose -f docker-compose.yml run --rm initdb
    docker-compose -f docker-compose.yml up -d leanote
