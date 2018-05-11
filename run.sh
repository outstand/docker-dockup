#!/bin/bash
export PATH=$PATH:/usr/bin:/usr/local/bin:/bin

: ${BACKUP_PATH:=/backup}
: ${SOURCE_PATH:=/source}
: ${COMPRESS:=true}
VOLUMES=$(ls $SOURCE_PATH)

if [ "$COMPRESS" != 'true' ]; then
  backup_flags='cf'
  restore_flags='xf'
  tar_extension=tar
else
  backup_flags='zcf'
  restore_flags='zxf'
  tar_extension=tar.gz
fi

while read -r line; do
  name=$line
  src=${SOURCE_PATH}/${name}
  tarball=${BACKUP_PATH}/${name}.$tar_extension
  if [ -z "$RESTORE" ]; then
    echo "Backing up ${name} from ${src} as ${tarball}"
    tar -C ${SOURCE_PATH} -$backup_flags ${tarball} ${name}
  else
    echo "Restoring ${name} to ${src} from ${tarball}"
    if [ -f ${tarball} ]; then
      tar -C ${src} --strip-components 1 -$restore_flags ${tarball}
    else
      echo ${tarball} does not exist, skipping.
    fi
  fi
done <<< "$VOLUMES"
