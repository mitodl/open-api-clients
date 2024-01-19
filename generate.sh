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

GENERATOR_VERSION=v7.2.0
GENERATOR_IMAGE=openapitools/openapi-generator-cli:${GENERATOR_VERSION}

pushd $OPEN_CLONE_DIR

git clone --filter=blob:none $OPEN_REPO $OPEN_CLONE_DIR
git checkout release

popd

for cfile in ./config/*.yaml; do
	echo "Generating: $cfile"
	docker run --rm \
		-v "${PWD}:/local" \
		-v "${OPEN_CLONE_DIR}:/open" \
		$GENERATOR_IMAGE \
		generate \
		--ignore-file-override "/local/.openapi-generator-ignore" \
		-c "/local/$cfile"
done

# set permissions to host permissions so that we can modify files
docker run --rm \
	-v "${PWD}:/local" \
	alpine \
	sh -c "chown \"\$(stat -c '%u:%g' /local)\" -R /local/src/"

rm -rf $OPEN_CLONE_DIR
