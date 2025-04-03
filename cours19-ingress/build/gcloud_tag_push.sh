#!/bin/bash

PROJECT_ID="h25-4d4-24" # TODO: remplacer par votre projet
REPOSITORY_ID="test-repo"

NGINX_VERSION=1.0
NODE1_VERSION=1.0
NODE2_VERSION=1.0

docker tag build-nginx us-east1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/nginx:$NGINX_VERSION
docker tag build-node1 us-east1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/node1:$NODE1_VERSION
docker tag build-node2 us-east1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/node2:$NODE2_VERSION

docker push us-east1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/nginx:$NGINX_VERSION
docker push us-east1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/node1:$NODE1_VERSION
docker push us-east1-docker.pkg.dev/$PROJECT_ID/$REPOSITORY_ID/node2:$NODE2_VERSION