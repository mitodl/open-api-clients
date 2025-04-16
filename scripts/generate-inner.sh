#!/usr/bin/env bash
#
script_dir=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
script_parent_dir=$(dirname "$script_dir")
find ${script_parent_dir} -regex ".*config/.*.yaml" -print0 | while IFS= read -r -d $'\0' cfile; do
    echo "Generating: $cfile"
    /usr/local/bin/docker-entrypoint.sh generate -c "$cfile"
done
