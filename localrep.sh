#!/bin/bash
docker-compose pull
docker images | awk '{print $1}' > pullimage
for line in $(cat pullimage); do
  if [[ $line == "registry.gitlab.com/megacam.dev/meta/meta-egsv" ]]; then
    docker tag $line:latest localhost:5000/$line:latest
    docker push localhost:5000/$line:latest
    echo $line
  elif [[ $line == "yandex/clickhouse-server" ]]; then
    docker tag $line:latest localhost:5000/$line:latest
    docker push localhost:5000/$line:latest
    echo $line
  elif [[ $line == "mongo" ]]; then
    docker tag $line:latest localhost:5000/$line:latest
    docker push localhost:5000/$line:latest
    echo $line
  elif [[ $line == "mariadb" ]]; then
    docker tag $line:latest localhost:5000/$line:latest
    docker push localhost:5000/$line:latest
    echo $line
  fi
done
docker images | awk '{print $2}' > pullimage

for line in $(cat pullimage); do
  if [[ $line == "latest-php-site" ]]; then
    docker tag registry.gitlab.com/megacam.dev/megacam:$line localhost:5000/registry.gitlab.com/megacam.dev/megacam:$line
    docker push localhost:5000/registry.gitlab.com/megacam.dev/megacam:$line
  elif [[ $line == "latest-nginx" ]]; then
    docker tag registry.gitlab.com/megacam.dev/megacam:$line localhost:5000/registry.gitlab.com/megacam.dev/megacam:$line
    docker push localhost:5000/registry.gitlab.com/megacam.dev/megacam:$line
  fi
done
rm -rf pullimage
