use albums;

create external table ranking (
Year	INTEGER,
Ranking	INTEGER,
Artist	STRING,
Album	STRING,
sales	INTEGER,
CDs		INTEGER,
Tracks  INTEGER,
length	STRING,
Genre	STRING)
Row format delimited
fields terminated by ','
stored as textfile
location '/data/albums/ranking'
TBLPROPERTIES ("skip.header.line.count"="1");