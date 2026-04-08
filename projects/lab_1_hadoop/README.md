# Lab 1 — Hadoop, Hive, HBase

## Objectif
Ce rendu présente une mise en œuvre simple du TP HDFS demandé, avec un seul fichier de test au lieu d'un dataset complet. Le but est de :
- démarrer l'environnement Docker Hadoop/Hive/HBase ;
- manipuler HDFS avec les commandes de base ;
- écrire des scripts Bash pour créer, supprimer, copier et déplacer des fichiers/répertoires dans HDFS ;
- préparer les fichiers nécessaires du lab dans une structure propre, prête à pousser sur GitHub.

## Arborescence du projet
```text
lab_1_hadoop_rendu/
├── README.md
├── docker-compose.yml
├── hadoop.env
├── hadoop-hive.env
├── hbase-standalone.env
├── query_1.hql
├── query_2.hql
├── TP HDFS (1).pdf
├── dataset/
│   └── test.txt
└── scripts/
    ├── create_hdfs.sh
    ├── delete_hdfs.sh
    ├── copy_local_to_hdfs.sh
    ├── copy_hdfs_to_hdfs.sh
    ├── copy_hdfs_to_local.sh
    ├── move_local_to_hdfs.sh
    └── move_hdfs_to_hdfs.sh
```

## Fichiers fournis
- `docker-compose.yml` : orchestration des services Hadoop, Hive et HBase.
- `hadoop.env` : configuration Hadoop/YARN.
- `hadoop-hive.env` : configuration Hive + Metastore.
- `hbase-standalone.env` : configuration HBase.
- `query_1.hql` et `query_2.hql` : requêtes Hive fournies.
- `TP HDFS (1).pdf` : sujet HDFS.
- `dataset/test.txt` : fichier local de test utilisé à la place d'un dataset complet.

## Prérequis
- Docker et Docker Compose installés.
- Les ports requis libres, en particulier : `9870`, `9864`, `8088`, `2181`, `16010`, `16030`.

## Démarrage du lab
Depuis le dossier du projet :

```bash
cd ~/lab_1_hadoop
/docker compose down
/docker compose up -d
```

Si votre commande Docker attend la syntaxe classique :

```bash
docker-compose down
docker-compose up -d
```

## Vérification des conteneurs
```bash
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

Services attendus :
- `namenode`
- `datanode`
- `resourcemanager`
- `nodemanager`
- `historyserver`
- `hive-server`
- `hive-metastore`
- `hive-metastore-postgresql`
- `hbase`

## Interfaces Web de monitoring
- NameNode : <http://localhost:9870>
- DataNode : <http://localhost:9864>
- YARN : <http://localhost:8088>
- Hive Server : `localhost:10002`
- HBase : <http://localhost:16010> ou <http://localhost:16030>

## Partie 1 — Commandes HDFS

### 1. Entrer dans le conteneur NameNode
```bash
docker exec -it namenode bash
```

### 2. Créer le répertoire HDFS
```bash
hdfs dfs -mkdir -p /tp_hdfs/fichiers
hdfs dfs -mkdir -p /tp_hdfs/archive
```

### 3. Vérifier l'arborescence HDFS
```bash
hdfs dfs -ls /
hdfs dfs -ls /tp_hdfs
```

### 4. Copier le fichier local de test dans le conteneur
Depuis la machine hôte :
```bash
docker cp dataset namenode:/tmp/dataset
```

### 5. Charger le fichier vers HDFS
Dans le conteneur `namenode` :
```bash
hdfs dfs -put /tmp/dataset/test.txt /tp_hdfs/fichiers/
```

### 6. Vérifier le fichier dans HDFS
```bash
hdfs dfs -ls /tp_hdfs/fichiers
```

### 7. Afficher le contenu
```bash
hdfs dfs -cat /tp_hdfs/fichiers/test.txt
```

### 8. Copier le fichier dans HDFS
```bash
hdfs dfs -cp /tp_hdfs/fichiers/test.txt /tp_hdfs/fichiers/test_copy.txt
hdfs dfs -ls /tp_hdfs/fichiers
```

### 9. Déplacer un fichier HDFS
```bash
hdfs dfs -mv /tp_hdfs/fichiers/test_copy.txt /tp_hdfs/archive/
hdfs dfs -ls /tp_hdfs/archive
```

### 10. Récupérer le fichier du HDFS vers le local du conteneur
```bash
mkdir -p /tmp/retour
hdfs dfs -get /tp_hdfs/fichiers/test.txt /tmp/retour/
ls -l /tmp/retour
```

### 11. Supprimer le fichier déplacé
```bash
hdfs dfs -rm /tp_hdfs/archive/test_copy.txt
hdfs dfs -ls /tp_hdfs/archive
```

## Résultats attendus — Partie 1
- Le répertoire `/tp_hdfs/fichiers` existe dans HDFS.
- Le fichier `test.txt` apparaît dans `/tp_hdfs/fichiers`.
- La commande `hdfs dfs -cat` affiche le contenu du fichier.
- Après copie, `test_copy.txt` apparaît.
- Après déplacement, `test_copy.txt` se trouve dans `/tp_hdfs/archive`.
- Après suppression, le fichier n'apparaît plus dans `/tp_hdfs/archive`.

## Partie 2 — Scripts Bash
Tous les scripts se trouvent dans `scripts/`.

### Rendre les scripts exécutables
```bash
chmod +x scripts/*.sh
```

### 1. Créer un répertoire HDFS
```bash
./scripts/create_hdfs.sh /tp_hdfs/test_create
```
Résultat attendu :
- si le chemin n'existe pas, il est créé ;
- sinon, le script affiche qu'il existe déjà.

### 2. Supprimer un fichier ou répertoire HDFS
```bash
./scripts/delete_hdfs.sh /tp_hdfs/test_create
```
Résultat attendu :
- si le chemin existe, il est supprimé ;
- sinon, le script affiche qu'il n'existe pas.

### 3. Copier un fichier local vers HDFS
```bash
./scripts/copy_local_to_hdfs.sh /tmp/dataset/test.txt /tp_hdfs/fichiers/
```
Résultat attendu :
- si le fichier local existe, il est copié dans HDFS.

### 4. Copier un fichier HDFS vers HDFS
```bash
./scripts/copy_hdfs_to_hdfs.sh /tp_hdfs/fichiers/test.txt /tp_hdfs/archive/test_hdfs_copy.txt
```
Résultat attendu :
- un nouveau fichier `test_hdfs_copy.txt` est créé dans `/tp_hdfs/archive`.

### 5. Copier un fichier HDFS vers le local
```bash
mkdir -p /tmp/sortie
./scripts/copy_hdfs_to_local.sh /tp_hdfs/fichiers/test.txt /tmp/sortie/
```
Résultat attendu :
- `test.txt` apparaît dans `/tmp/sortie`.

### 6. Déplacer un fichier local vers HDFS
```bash
./scripts/move_local_to_hdfs.sh /tmp/dataset/test.txt /tp_hdfs/fichiers/
```
Résultat attendu :
- le fichier est envoyé dans HDFS puis supprimé du local.

### 7. Déplacer un fichier HDFS vers HDFS
```bash
./scripts/move_hdfs_to_hdfs.sh /tp_hdfs/fichiers/test.txt /tp_hdfs/archive/
```
Résultat attendu :
- le fichier quitte `/tp_hdfs/fichiers` et apparaît dans `/tp_hdfs/archive`.

## Partie Hive
Deux fichiers de requêtes Hive sont inclus :
- `query_1.hql`
- `query_2.hql`

Exécution possible depuis le conteneur Hive Server :
```bash
docker exec -it hive-server bash
hive -f /path/to/query_1.hql
hive -f /path/to/query_2.hql
```

## Dépôt GitHub — commandes recommandées
Depuis le dossier `lab_1_hadoop_rendu` :
```bash
git init
git add .
git commit -m "Rendu Lab 1 Hadoop Hive HBase"
git branch -M main
git remote add origin <URL_DU_REPO>
git push -u origin main
```

## Remarques
- Si un port est déjà utilisé, arrêter les autres conteneurs avant de lancer le lab.
- Les conflits les plus fréquents concernent `8088` et `2181`.
- Le fichier `dataset/test.txt` remplace ici un dataset complet afin de valider les commandes et les scripts demandés.
