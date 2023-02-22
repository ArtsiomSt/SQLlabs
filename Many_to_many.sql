CREATE DATABASE IF NOT EXISTS DB1;
Use DB1;
CREATE TABLE DB1.Basic (
    SongTitle VARCHAR(35),
    Quality ENUM('H', 'L', 'M'),
    Duration INT,
    DateRecord DATE,
    AlbumTitle varchar(35), 
    price decimal (5,2),
    ArtistName varchar(35),
    emailb varchar(35)
    );
insert into Basic (SongTitle, Quality, Duration, DateRecord, AlbumTitle, price, ArtistName, emailb) values 
('Sing Me To Sleep', 'H', 176, '2018-08-29',null, null, 'Alan Walke', 'AlanWalker@mail.com'),
('The Greatest', 'L', 88, '2019-10-24', 'The Greatest', 2.38, 'Sia', null),
('Cheap Thrills', 'M', 115, '2016-07-16', 'The Greatest', 2.38, 'Sia', null),
('Ocean Drive', 'M', 101,	'2015-12-04', null, null, 'Duke Dumont', null),
('No Money', 'M',	126, '2018-05-11', 'In The Lonely Hour', 3.63, null, null),
('Thinking About It', 'L', 170, '2016-01-14', 'Evolution', 1.88, 'Nathan Goshen', null),
('Perfect Strangers', 'L', 189, '2018-09-06', 'Runway', 2.75, 'Jonas Blue', null),
('Perfect Strangers', 'L', 189, '2018-09-06', 'Runway', 2.75, 'Jp Cooper', null),
('Thinking About It', 'M', 179, '2017-10-25','In The Lonely Hour',3.25, 'Alan Walke', 'AlanWalker@mail.com'),
('Thinking About It', 'M', 179, '2017-10-25','In The Lonely Hour',3.25, 'Jp Cooper', null),
('My Way', 'H', 163, '2018-07-26','My Way', 1.63, 'Frank Sinatra', null),	
('My Way', 'H', 157,	'1985-01-11','The Christmas', 3.63, 'Frank Sinatra', null),
('Let It Snow!', 'M', 158, '1984-03-05','World On A String', 3.38, 'Frank Sinatra', null);

-- 2. Нормальзвать базу данных. Создать новые таблицы и заполнить их с помощью запросов из таблицы Basic
-- решение 

CREATE TABLE Song(
	IDS INT auto_increment PRIMARY KEY,
    SongTitle VARCHAR(35),
	Quality ENUM('H', 'L', 'M'),
	Duration INT,
	price decimal (5,2)
    );
    

CREATE TABLE DateRec(
	IDD INT auto_increment PRIMARY KEY,
    DateRecord DATE
    );


CREATE TABLE Album(
	IDA INT auto_increment PRIMARY KEY,
    AlbumTitle varchar(35)
    );
    
CREATE TABLE Artist(
	IDAA INT auto_increment PRIMARY KEY,
    ArtistName varchar(35),
    emailar varchar(35)	
    );
    
    
 CREATE TABLE SongDate(
	IDS INT NOT NULL,
    IDD INT NOT NULL,
    foreign key (IDS) references Song(IDS) ON DELETE CASCADE,
    foreign key (IDD) references DateRec(IDD) ON DELETE CASCADE
    );
 
 
 CREATE TABLE SongAlbum(
	IDS INT NOT NULL,
    IDA INT NOT NULL,
    foreign key (IDS) references Song(IDS) ON DELETE CASCADE,
    foreign key (IDA) references Album(IDA) ON DELETE CASCADE
    );

 CREATE TABLE SongArtist(
	IDS INT NOT NULL,
    IDAA INT NOT NULL,
    foreign key (IDS) references Song(IDS) ON DELETE CASCADE,
    foreign key (IDAA) references Artist(IDAA) ON DELETE cascade
    );
    
INSERT INTO Artist (ArtistName, emailar) SELECT distinct ArtistName, emailb from basic;
INSERT INTO DateRec(DateRecord) SELECT distinct DateRecord FROM basic;
INSERT INTO Song (SongTitle, Quality, Duration, price) SELECT songtitle,quality,duration,price FROM basic;
INSERT INTO Album(AlbumTitle) SELECT distinct AlbumTitle FROM basic;



INSERT INTO SongAlbum(IDS, IDA)
(SELECT DISTINCT IDS, IDA
FROM basic
INNER JOIN Song USING (SongTitle, Quality, Duration)
INNER JOIN Album Using (AlbumTitle)
WHERE IDA IS NOT NULL);

INSERT INTO SongDate(IDS, IDD)
(SELECT IDS, IDD
FROM basic
INNER JOIN Song USING (SongTitle, Quality, Duration)
INNER JOIN DateRec Using (DateRecord)
WHERE IDD IS NOT NULL);



INSERT INTO SongArtist(IDS, IDAA)
SELECT IDS, IDAA
FROM basic
JOIN Song ON Song.SongTitle = basic.SongTitle AND Song.Duration = basic.Duration AND ((Song.Price IS NULL AND basic.price IS NULL) OR (Song.price=basic.price))
JOIN Artist ON Artist.ArtistName=basic.ArtistName;


-- 3. Создать запрос для	добавления нового SongTitle «Can't Stop The Feeling» исполнителя Jonas Blue продолжительностью 253 секунды, аудио запасись сделана 5 августа 2016 в среднем качестве.
-- решение 


INSERT IGNORE INTO DateRec(DateRecord) VALUES ('2016-08-05');
INSERT IGNORE INTO Song(SongTitle, Duration, Quality) VALUES ('Cant Stop The Feeling', 253, 'M');

INSERT INTO SongDate(IDS, IDD)
SELECT IDS, IDD 
FROM Song
FULL JOIN DateRec
WHERE SongTitle='Cant Stop The Feeling' and DateRecord = '2016-08-05';

INSERT INTO SongArtist(IDS,IDAA)
SELECT IDS, IDAA
FROM Song
FULL JOIN Artist
WHERE SongTitle = 'Cant Stop The Feeling' and ArtistName = 'Jonas Blue';

SELECT *
FROM Song
INNER JOIN SongDate USING (IDS)
INNER JOIN SongArtist USING (IDS)
INNER JOIN DateRec USING (IDD)
INNER JOIN Artist Using (IDAA)
WHERE SongTitle = 'Cant Stop The Feeling';

-- 4. Создать запрос для	Переименовать аудио запасись «Thinking About It - Nathan Goshen» в «Let It Go»
-- решение 

UPDATE Song
	INNER JOIN SongArtist USING (IDS)
    INNER JOIN Artist USING (IDAA)
SET SongTitle = 'Let It go'
WHERE SongTitle = 'Thinking About It' and ArtistName = 'Nathan Goshen';


-- 5. Создать запрос для	Удалить колонку «e-mail», создать колонку «Сайт» задав по умолчанию значение «нет»
-- решение 

ALTER TABLE Artist
DROP COLUMN emailar;

ALTER TABLE Artist
ADD site VARCHAR(128) DEFAULT 'no'; 

SELECT * FROM Artist;

-- 6. Создать запрос для	Вывести все аудио запасиси и если есть информация, то и исполнителя и альбом
-- решение 

SELECT distinct SongTitle, Quality, Duration, price,ArtistName, AlbumTitle
FROM Song
LEFT JOIN SongArtist USING (IDS)
INNER JOIN Artist USING (IDAA)
INNER JOIN SongAlbum USING(IDS)
INNER JOIN Album USING(IDA);


-- 7. Создать запрос для	Вывести все аудио запасиси, у которых в названии альбома есть «way» 
-- решение 

SELECT SongTitle, AlbumTitle
FROM SONG
INNER JOIN SongAlbum USING (IDS)
INNER JOIN Album USING (IDA)
WHERE AlbumTitle LIKE '%way%';

-- 8. Создать запрос для	Вывести название, стоимость альбома и его исполнителя при условии, что он будет самым дорогим для каждого исполнителя.
-- решение 

-- SELECT MAX(max_price) AS max_max, AlbumTitle, ArtistName
-- FROM (
-- SELECT MAX(price) as max_price, AlbumTitle, ArtistName
-- FROM 
-- (SELECT distinct AlbumTitle, ArtistName, price
-- FROM Song
-- INNER JOIN SongAlbum USING (IDS)
-- INNER JOIN Album USING (IDA)
-- INNER JOIN SongArtist USING (IDS)
-- INNER JOIN Artist USING (IDAA)) AS e
-- GROUP BY AlbumTitle
-- ORDER BY price DESC) AS e1
-- GROUP BY ArtistName;


-- SELECT MAX(price) AS max_price, AlbumTitle, ArtistName
-- FROM (
-- SELECT DISTINCT AlbumTitle, ArtistName, price
-- FROM Song
-- RIGHT JOIN SongArtist USING (IDS)
-- INNER JOIN Artist USING (IDAA)
-- INNER JOIN SongAlbum USING (IDS)
-- INNER JOIN Album USING (IDA)
-- ORDER BY price DESC) AS e
-- GROUP BY ArtistName; 




SELECT DISTINCT ArtistName,AlbumTitle, price_max
FROM Song
RIGHT JOIN SongArtist USING (IDS)
INNER JOIN Artist USING (IDAA)
INNER JOIN SongAlbum USING (IDS)
INNER JOIN Album USING (IDA)
INNER JOIN ( 
SELECT ArtistName AS ArtN, MAX(price) AS  price_max
FROM
(SELECT DISTINCT AlbumTitle, ArtistName, price
FROM Song
RIGHT JOIN SongArtist USING (IDS)
INNER JOIN Artist USING (IDAA)
INNER JOIN SongAlbum USING (IDS)
INNER JOIN Album USING (IDA)) AS e
GROUP BY ArtistName) AS e2 ON e2.ArtN = ArtistName AND e2.price_max = price;

-- 9. Создать запрос для	Удалить запись «Can't Stop The Feeling» исполнителя Jonas Blue.
-- решение 
DELETE FROM Song
WHERE IDS = 
(SELECT IDS FROM (SELECT IDS 
FROM Song
INNER JOIN SongArtist USING (IDS)
INNER JOIN Artist USING (IDAA)
WHERE SongTitle = 'Cant Stop The Feeling' AND ArtistName = 'Jonas Blue') AS t1);

-- 10** построить схему БД в workbench
