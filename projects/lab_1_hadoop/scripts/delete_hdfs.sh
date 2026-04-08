#!/bin/bash
CHEMIN=$1

if [ -z "$CHEMIN" ]; then
  echo "Usage: $0 <chemin_hdfs>"
  exit 1
fi

if hdfs dfs -test -e "$CHEMIN"; then
  hdfs dfs -rm -r "$CHEMIN"
  echo "Supprimé : $CHEMIN"
else
  echo "Le chemin n'existe pas : $CHEMIN"
fi
