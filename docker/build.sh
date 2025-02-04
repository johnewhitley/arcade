#!/bin/bash

set -o errexit

# Builds the base image including the solver dependencies
build_and_publish_image(){
    GOOS=linux GOARCH=amd64 go build cmd/arcade/arcade.go
    GCR_TAG="oshomedepot/arcade:${TAG_VERSION}"
    docker build . -f docker/Dockerfile -t ${GCR_TAG}
    echo "Image ${GCR_TAG} built..."
    docker push ${GCR_TAG}
}

print_help(){
    echo ""
    echo "docker/build.sh -v [VERSION] - Builds the docker image"
    echo ""
    echo "FLAGS"
    echo "    -v [version]"
    echo "        The version to be used in the docker tag"
    echo ""
}

if [[ $# -eq 0 ]]; then
    print_help
    exit 1
fi

# Check for arguments
while [[ $# -gt 0 ]]; do
    key="${1}"
    case ${key} in
        -v)
            shift
            if [ -z "${1}" ]; then
                print_help
            else
                echo "Building base image with version: [${1}]"
                TAG_VERSION="${1}"
                build_and_publish_image
            fi
            exit 0
            ;;
        --help)
            shift
            print_help
            exit 0
            ;;
        *)
            echo "ERROR: Unrecognized argument ${key}"
            print_help
            exit 1
            ;;
    esac
done
