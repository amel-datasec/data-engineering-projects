#!/bin/bash
SRC_HDFS=$1
DEST_LOCAL=$2

if [ -z "$SRC_HDFS" ] || [ -z "$DEST_LOCAL" ]; then
  echo "Usage: $0 <source_hdfs> <destination_local>"
  exit 1
fi

if hdfs dfs -test -e "$SRC_HDFS"; then
  hdfs dfs -get "$SRC_HDFS" "$DEST_LOCAL"
  echo "Copie HDFS vers local effectuée"
else
  echo "La source HDFS n'existe pas : $SRC_HDFS"
fi
