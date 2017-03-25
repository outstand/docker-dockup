#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

: ${BACKUP_PATH:=/backup}
VOLUMES=$(docker inspect -f '{{range .Mounts}}{{.Source}}:{{.Destination}}{{"\n"}}{{end}}' $HOSTNAME)

while read -r line; do
  regex="^/var/lib/docker/volumes/([a-zA-Z0-9_\-]+)/_data:(.+)$"
  if [[ $line =~ $regex ]]; then
    name=${BASH_REMATCH[1]}
    dest=${BASH_REMATCH[2]}
    tarball=${BACKUP_PATH}/${name}.tar.gz
    if [ -z "$RESTORE" ]; then
      echo "Backing up ${name} from ${dest} as ${tarball}"
      tar -C ${dest}/.. -zcf ${tarball} $(basename ${dest})
    else
      echo "Restoring ${name} to ${dest} from ${tarball}"
      if [ -f ${tarball} ]; then
        tar -C ${dest} --strip-components 1 -zxf ${tarball}
      else
        echo ${tarball} does not exist, skipping.
      fi
    fi
  else
    continue
  fi
done <<< "$VOLUMES"
