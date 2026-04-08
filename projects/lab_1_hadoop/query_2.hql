USE albums;

CREATE EXTERNAL TABLE series_ext (
Year	INTEGER,
Ranking	INTEGER,
Artist	STRING,
Album	STRING,
sales	INTEGER,
CDs		INTEGER,
Tracks  INTEGER,
length	STRING,
hours	STRING,
minutes	STRING,
seconds	String,
Genre	STRING)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/data/albums/series'
TBLPROPERTIES ("skip.header.line.count"="1");


CREATE TABLE series (
Year	INTEGER,
Ranking	INTEGER,
Artist	STRING,
Album	STRING,
sales	INTEGER,
CDs		INTEGER,
Tracks  INTEGER,
length	STRING,
hours	STRING,
minutes	STRING,
seconds	String,
Genre	STRING)
STORED AS ORC;

INSERT INTO series SELECT * FROM series_ext;
