#!/usr/bin/env bash

CCA_FVP_IMAGE="cca-cpu/fvp-feature:latest"
CCA_FVP_DOCKERFILE="/opt/cca/Dockerfile"

if ! docker info > /dev/null 2>&1; then
    echo "User is fucked"
fi

if ! docker image inspect $CCA_FVP_IMAGE > /dev/null; then
    echo "Need to rebuild image"
    docker build -t $CCA_FVP_IMAGE $CCA_FVP_DOCKERFILE
fi

# TODO: Add auto-detection of native run possibilites
check 

echo Starting FVP...hit ^a-d to exit
docker run -i -t --rm --privileged --name fvp $CCA_FVP_IMAGE /opt/cca/start-fvp-cpud-stage2.bash
echo Done.
