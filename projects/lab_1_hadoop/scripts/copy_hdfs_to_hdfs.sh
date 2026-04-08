#!/bin/bash
SRC_HDFS=$1
DEST_HDFS=$2

if [ -z "$SRC_HDFS" ] || [ -z "$DEST_HDFS" ]; then
  echo "Usage: $0 <source_hdfs> <destination_hdfs>"
  exit 1
fi

if hdfs dfs -test -e "$SRC_HDFS"; then
  hdfs dfs -cp "$SRC_HDFS" "$DEST_HDFS"
  echo "Copie HDFS effectuée"
else
  echo "La source HDFS n'existe pas : $SRC_HDFS"
fi
