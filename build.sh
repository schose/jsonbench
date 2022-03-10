#!/bin/sh
echo Building schose/jsonbench:build

docker buildx build --platform linux/arm/v8  -t schose/jsonbench:build -f Dockerfile.build .

# build app for arm
docker container create --name extract schose/jsonbench:build
docker container cp extract:/build/json ./json

docker container rm -f extract

# build app for x86
docker buildx build -t schose/jsonbench:buildx86 -f Dockerfile.build . --platform linux/x86_64

docker container create --name extractx86 schose/jsonbench:buildx86
docker container cp extractx86:/build/json ./jsonx86

docker container rm -f extractx86

# create container for upload
echo Building schose/jsonbench:0.0.3
docker buildx build --platform linux/arm64/v8 -t schose/jsonbench:arm -f Dockerfile .
docker buildx build --platform linux/x86_64 -t schose/jsonbench:x86 -f Dockerfilex86 .

docker push schose/jsonbench:arm
docker push schose/jsonbench:x86 

docker manifest create schose/jsonbench:0.0.5 schose/jsonbench:arm schose/jsonbench:x86
docker manifest push schose/jsonbench:0.0.5

### run
### docker run --rm schose/jsonbench:0.0.2
### 