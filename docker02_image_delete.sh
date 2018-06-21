#!/usr/bin/env bash

ACCEPT_HEADER="Accept: application/vnd.docker.distribution.manifest.v2+json"
DOCKER_REGISTRY="docker02:35000/v2"
AUTH="-uxxx:xxx"
REPOSITORY=$1

TAGS=`curl --silent -X GET -k $AUTH $DOCKER_REGISTRY/$REPOSITORY/tags/list | jq -r '."tags"[]'`
echo image $REPOSITORY has tags: $TAGS

for TAG in ${TAGS[@]}
do
	echo  "i am going to delete $REPOSITORY:$TAG"
	digest_value=`curl -X GET -k --head --silent -H "Accept: application/vnd.docker.distribution.manifest.v2+json" $AUTH $DOCKER_REGISTRY/$REPOSITORY/manifests/$TAG 2>&1 | grep Docker-Content-Digest | awk '{print $2}'`

	digest_url="$DOCKER_REGISTRY/$REPOSITORY/manifests/$digest_value"
	echo $digest_url
	URL=${digest_url%$'\r'}
	curl -X DELETE -k -H  "Accept: application/vnd.docker.distribution.manifest.v2+json" $AUTH  $URL
done

#docker exec -it registry bin/registry garbage-collect /etc/docker/registry/config.yml

#REPOSITORY_PATH="/var/lib/registry/docker/registry/v2/repositories"
#docker exec -it registry rm -rf $REPOSITORY_PATH/$REPOSITORY
