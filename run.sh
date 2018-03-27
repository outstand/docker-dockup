#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

: ${BACKUP_PATH:=/backup}
: ${SOURCE_PATH:=/source}
VOLUMES=$(ls $SOURCE_PATH)

while read -r line; do
  name=$line
  src=${SOURCE_PATH}/${name}
  tarball=${BACKUP_PATH}/${name}.tar.gz
  if [ -z "$RESTORE" ]; then
    echo "Backing up ${name} from ${src} as ${tarball}"
    tar -C ${SOURCE_PATH} -zcf ${tarball} ${name}
  else
    echo "Restoring ${name} to ${src} from ${tarball}"
    if [ -f ${tarball} ]; then
      tar -C ${src} --strip-components 1 -zxf ${tarball}
    else
      echo ${tarball} does not exist, skipping.
    fi
  fi
done <<< "$VOLUMES"
