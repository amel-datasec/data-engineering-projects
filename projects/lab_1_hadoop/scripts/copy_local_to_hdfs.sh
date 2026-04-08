#!/bin/bash
SOURCE_LOCAL=$1
DEST_HDFS=$2

if [ -z "$SOURCE_LOCAL" ] || [ -z "$DEST_HDFS" ]; then
  echo "Usage: $0 <source_local> <destination_hdfs>"
  exit 1
fi

if [ -f "$SOURCE_LOCAL" ]; then
  hdfs dfs -put "$SOURCE_LOCAL" "$DEST_HDFS"
  echo "Copie effectuée de $SOURCE_LOCAL vers $DEST_HDFS"
else
  echo "Le fichier local n'existe pas : $SOURCE_LOCAL"
fi
