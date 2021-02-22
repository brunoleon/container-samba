#!/usr/bin/env bash

set -o nounset

usage() { echo "Usage: $0 -u USER:PASSWORD" 1>&2; exit 1; }

while getopts "u:" OPTION; do
    case $OPTION in
    u)
        users+=("$OPTARG")
        ;;
    *)
        usage
        exit 1
        ;;
    esac
done

for user in "${users[@]}"; do
  LOGIN=$(echo $user | cut -d':' -f 1)
  PASS=$(echo $user | cut -d':' -f 2)
  useradd --no-create-home $LOGIN
  printf "$PASS\n$PASS\n" | smbpasswd -s -a $LOGIN
done

exec smbd --foreground --no-process-group --log-stdout
