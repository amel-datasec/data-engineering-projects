# 🚀 Kafka Vote Stream – Pipeline Temps Réel

## 📌 Objectif du projet

Ce projet consiste à construire une architecture de traitement de données en temps réel simulant un système de votes municipaux.

L'objectif est de comprendre et implémenter un pipeline complet :

* ingestion de données
* validation métier
* traitement streaming
* stockage
* visualisation

---

## 🧠 Architecture globale

```
Producer → Kafka → Validator → Kafka → ksqlDB → Cassandra → Streamlit
```

### 🔷 Schéma global

```
        ┌──────────────┐
        │  Producer    │
        └──────┬───────┘
               │ vote_events_raw
               ▼
        ┌──────────────┐
        │    Kafka     │
        └──────┬───────┘
               ▼
        ┌──────────────┐
        │  Validator   │
        └──────┬───────┘
        ┌──────┴──────────────┐
        ▼                     ▼
Valid votes           Rejected votes
        │                     │
        └──────► ksqlDB ◄─────┘
                    │
                    ▼
               Cassandra
                    │
                    ▼
               Streamlit
```

---

## ⚙️ Mise en place

### 1. Lancer la stack Docker

```bash
docker compose up -d
```

### 📸 Résultat

![Docker](screenshots/docker_ps.png)

---

### 2. Création des topics Kafka

* vote_events_raw
* vote_events_valid
* vote_events_rejected

```bash
docker compose exec kafka kafka-topics --list --bootstrap-server localhost:9092
```

### 📸 Résultat

![Kafka Topics](screenshots/kafka_topics.png)

---

## 🚀 Producer

Le producer génère des votes simulés et les envoie dans Kafka.

```bash
python enonce/src/producer_votes.py
```

### 📸 Résultat

![Producer](screenshots/producer.png)

---

## 🛡️ Validator

Le validator filtre les votes selon des règles métier :

* signature valide
* vote_id présent
* candidat valide

```bash
python enonce/src/validator_votes.py
```

### 📸 Résultat

![Validator](screenshots/validator.png)

---

## 🧠 Traitement avec ksqlDB

Agrégation des données en temps réel :

* votes par candidat
* votes par minute
* votes par département

```sql
SELECT * FROM vote_count_by_city_minute EMIT CHANGES;
```

### 📸 Résultat

![ksqlDB](screenshots/ksqldb.png)

---

## 🗄️ Cassandra

Stockage des données agrégées.

```sql
SELECT * FROM votes_by_city_minute LIMIT 10;
```

### 📸 Résultat

![Cassandra](screenshots/cassandra.png)

---

## 🔄 Loader Cassandra

Transfert des données depuis Kafka vers Cassandra.

```bash
python enonce/src/load_to_cassandra.py
```

### 📸 Résultat

![Loader](screenshots/loader.png)

---

## 📊 Dashboard Streamlit

Visualisation des données :

* KPI
* Graphiques
* Carte France

```bash
streamlit run enonce/src/dashboard_streamlit.py
```

### 📸 Résultat

![Dashboard](screenshots/dashboard.png)

---

## 🗺️ Schéma final du pipeline

```
[Producer]
     ↓
[Kafka RAW]
     ↓
[Validator]
  ↓        ↓
Valid    Rejected
  ↓        ↓
     [ksqlDB]
         ↓
     [Kafka agg]
         ↓
   [Cassandra]
         ↓
   [Streamlit]
```

---

## 🎯 Conclusion

Ce projet met en œuvre une architecture complète de traitement de données temps réel.

Technologies utilisées :

* Kafka (streaming)
* Python (logique métier)
* ksqlDB (SQL streaming)
* Cassandra (NoSQL)
* Streamlit (visualisation)

---

## 📁 Structure du projet

```
kafka-vote-stream/
├── enonce/
│   ├── src/
│   ├── sql/
│   └── cql/
├── data/
├── docker-compose.yml
└── README.md
```

---

## 👨‍💻 Auteur

Amel

