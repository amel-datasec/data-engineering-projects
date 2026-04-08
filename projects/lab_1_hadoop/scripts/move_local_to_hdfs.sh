#!/bin/bash
SRC_LOCAL=$1
DEST_HDFS=$2

if [ -z "$SRC_LOCAL" ] || [ -z "$DEST_HDFS" ]; then
  echo "Usage: $0 <source_local> <destination_hdfs>"
  exit 1
fi

if [ -f "$SRC_LOCAL" ]; then
  hdfs dfs -put "$SRC_LOCAL" "$DEST_HDFS" && rm -f "$SRC_LOCAL"
  echo "Déplacement local vers HDFS effectué"
else
  echo "Le fichier local n'existe pas : $SRC_LOCAL"
fi
