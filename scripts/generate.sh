#!/usr/bin/env bash
#
# This script generates the API implementations based off the current production API schemas.
#
set -eo pipefail
shopt -u nullglob

if [ -z "$(which docker)" ]; then
	echo "Error: Docker must be available in order to run this script"
	exit 1
fi

OPEN_CLONE_DIR=$(mktemp -d)
OPEN_REPO="https://github.com/mitodl/mit-open.git"

GENERATOR_VERSION="$(cat OPENAPI-GENERATOR-VERSION)"
GENERATOR_IMAGE=openapitools/openapi-generator-cli:${GENERATOR_VERSION}

pushd $OPEN_CLONE_DIR

git clone --filter=blob:none $OPEN_REPO $OPEN_CLONE_DIR
git checkout release

popd

docker run --rm \
  -v "${PWD}:/tmp/mit-open-api-clients" \
  -v "${OPEN_CLONE_DIR}:/tmp/mit-open" \
  -w /tmp \
  $GENERATOR_IMAGE \
  ./mit-open-api-clients/scripts/generate-inner.sh


# set permissions to host permissions so that we can modify files
docker run --rm \
	-v "${PWD}:/local" \
	alpine \
	sh -c "chown \"\$(stat -c '%u:%g' /local)\" -R /local/src/"

rm -rf $OPEN_CLONE_DIR
