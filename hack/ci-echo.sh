#!/usr/bin/env bash

repository="gcr.io/echoapp-320414/echoappv2"
branch="master"
version="latest"
commit=$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1 | awk '{print tolower($0)}')

while getopts :r:b:v: o; do
    case "${o}" in
        r)
            repository=${OPTARG}
            ;;
        b)
            branch=${OPTARG}
            ;;
        v)
            version=${OPTARG}
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${version}" ]; then
    image="${repository}:${branch}-${commit}"
    version="0.4.0"
else
    image="${repository}:${version}"
fi

echo ">>>> Building image ${image} <<<<"

docker build -t echoapp -f $PWD/echo/Dockerfile .

docker tag echoapp ${image}

docker push ${image}

