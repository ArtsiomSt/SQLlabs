DROP DATABASE IF EXISTS Openings;
CREATE DATABASE Openings;
USE Openings;
CREATE TABLE inventioner(
	first_name VARCHAR(128),
    last_name VARCHAR(128),
    country VARCHAR(128)
);

DROP TABLE inventioner;
DROP DATABASE Openings;

CREATE DATABASE Openings;
USE Openings;
CREATE TABLE inventioner(
	first_name VARCHAR(128),
    last_name VARCHAR(128),
    born_country VARCHAR(128)
);

CREATE TABLE invention(
	id  INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(128),
    invention_date YEAR,
    content VARCHAR(255)
);

ALTER TABLE inventioner
ADD id INT PRIMARY KEY AUTO_INCREMENT;

CREATE TABLE inventioner_invention(
	inventioner_id INT,
    invention_id INT,
	FOREIGN KEY (inventioner_id) REFERENCES inventioner(id),
	FOREIGN KEY (invention_id) REFERENCES invention(id),
	PRIMARY KEY (inventioner_id, invention_id)
);

ALTER TABLE inventioner
CHANGE born_country country VARCHAR(128);

ALTER TABLE invention
	MODIFY COLUMN content TEXT, 
	DROP COLUMN invention_date;
