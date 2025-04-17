#!/usr/bin/env bash
#
# This script generates the API implementations based off the current production API schemas.
#
set -eo pipefail
shopt -u nullglob

script_dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
script_parent_dir=$(dirname "$script_dir")

if [ -z "$(which docker)" ]; then
	echo "Error: Docker must be available in order to run this script"
	exit 1
fi

OPEN_CLONE_DIR=$(mktemp -d)
OPEN_REPO="https://github.com/mitodl/mit-learn.git"

GENERATOR_VERSION="$(cat OPENAPI-GENERATOR-VERSION)"
GENERATOR_IMAGE=openapitools/openapi-generator-cli:${GENERATOR_VERSION}

pushd $OPEN_CLONE_DIR

git clone --filter=blob:none $OPEN_REPO $OPEN_CLONE_DIR
git checkout release

popd

docker run --rm \
	-v "${PWD}:${script_parent_dir}" \
	-v "${OPEN_CLONE_DIR}:/tmp/mit-learn" \
	-w /tmp \
	$GENERATOR_IMAGE \
	.${script_dir}/generate-inner.sh

# set permissions to host permissions so that we can modify files
docker run --rm \
	-v "${PWD}:/local" \
	alpine \
	sh -c "chown \"\$(stat -c '%u:%g' /local)\" -R /local/src/"

rm -rf $OPEN_CLONE_DIR
