#!/bin/bash
CHEMIN=$1

if [ -z "$CHEMIN" ]; then
  echo "Usage: $0 <chemin_hdfs>"
  exit 1
fi

if hdfs dfs -test -e "$CHEMIN"; then
  echo "Le chemin existe déjà : $CHEMIN"
else
  hdfs dfs -mkdir -p "$CHEMIN"
  echo "Répertoire créé : $CHEMIN"
fi
