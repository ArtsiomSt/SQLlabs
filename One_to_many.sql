DROP DATABASE IF EXISTS L3;
CREATE DATABASE L3;
USE L3;
CREATE TABLE `manuf` (
`IDM` int PRIMARY KEY,  
`name` varchar(20),  
`city` varchar(20));
INSERT INTO `manuf` VALUES 
(1,'Intel','Santa Clara'),
(2,'AMD','Santa Clara'),
(3,'WD','San Jose'),
(4,'seagete','Cupertino'),
(5,'Asus','Taipei'),
(6,'Dell','Round Rock');
CREATE TABLE `cpu` (
`IDC` int PRIMARY KEY ,
`IDM` int,
`Name` varchar(20),
`clock` decimal(5,2));
INSERT INTO `cpu` VALUES 
(1,1,'i5',3.20),
(2,1,'i7',4.70),
(3,2,'Ryzen 5',3.20),
(4,2,'Ryzen 7',4.70),
(5,NULL,'Power9',3.50);
CREATE TABLE `hdisk` (
`IDD` int PRIMARY KEY,
`IDM` int,
`Name` varchar(20),
`type` varchar(20),
`size` int);
INSERT INTO `hdisk` VALUES 
(1,3,'Green','hdd',1000),
(2,3,'Black','ssd',256),
(3,1,'6000p','ssd',256),
(4,1,'Optane','ssd',16);
CREATE TABLE `nb` (
`IDN` int PRIMARY KEY,
`IDM` int,
`Name` varchar(20),
`IDC` int,
`IDD` int);
INSERT INTO `nb` VALUES 
(1,5,'Zenbook',2,2),
(2,6,'XPS',2,2),
(3,9,'Pavilion',2,2),
(4,6,'Inspiron',3,4),
(5,5,'Vivobook',1,1),
(6,6,'XPS',4,1);


SELECT * FROM manuf, cpu;

SELECT * FROM manuf, cpu
WHERE cpu.IDM = manuf.IDM;

SELECT IDM, manuf.name, IDC, cpu.name
FROM manuf
INNER JOIN cpu USING (IDM);

SELECT IDM, manuf.name, IDC, cpu.name
FROM manuf
LEFT JOIN cpu USING (IDM);

SELECT IDM, manuf.name, IDC, cpu.name
FROM manuf
RIGHT JOIN cpu USING (IDM);

SELECT IDM, manuf.name, IDC, cpu.name
FROM manuf
CROSS JOIN cpu USING (IDM);


-- 9	Вывести название фирмы и модель диска. Список не должен содержать пустых значений (NULL)
-- Решение:

SELECT manuf.Name, hdisk.Name
FROM manuf
RIGHT JOIN hdisk USING (IDM);

-- 10	Вывести модель процессора и, если есть информация в БД, название фирмы
-- Решение:

SELECT cpu.Name, manuf.Name
FROM cpu
INNER JOIN manuf USING (IDM);

-- 11	Вывести модели ноутбуков, у которых нет информации в базе данных о фирме изготовителе
-- Решение:

SELECT nb.Name, manuf.Name
FROM nb
LEFT JOIN manuf USING (IDM)
WHERE manuf.Name IS NULL;

-- 12	Вывести модель ноутбука и название производителя ноутбука, название модели процессора, название модели диска
-- Решение:

SELECT nb.Name, manuf.Name, cpu.Name, hdisk.Name
FROM nb
INNER JOIN manuf USING (IDM)
INNER JOIN cpu USING (IDC)
INNER JOIN hdisk USING (IDD);


-- 13	Вывести модель ноутбука, фирму производителя ноутбука, а также для этой модели:	модель и название фирмы производителя процессора, модель и название фирмы производителя диска
-- Решение:

SELECT nb.Name, manuf.Name AS nb_name, cpu_title, cpu_manuf, hdisk_name, hdisk_manuf
FROM nb
LEFT JOIN manuf USING (IDM)
INNER JOIN (SELECT manuf.Name AS cpu_manuf, IDC, cpu.Name AS cpu_title FROM cpu INNER JOIN manuf USING (IDM)) AS cpu_join USING (IDC)
INNER JOIN (SELECT manuf.Name AS hdisk_manuf, IDD, hdisk.Name AS hdisk_name FROM hdisk INNER JOIN manuf USING (IDM)) AS hdisk_join USING (IDD);

-- 14	Вывести абсолютно все названия фирм в первом поле и все моделей процессоров во втором
-- Решение:

SELECT manuf.Name AS manuf_title, cpu.Name AS cpu_title
FROM manuf
LEFT JOIN cpu USING (IDM)
UNION
SELECT manuf.Name AS manuf_title, cpu.Name AS cpu_title
FROM manuf
RIGHT JOIN cpu USING (IDM);

-- 15	Вывести название фирмы, которая производит несколько типов товаров
-- Решение:
SELECT distinct manuf_title
FROM (SELECT DISTINCT manuf.Name AS manuf_title, cpu.Name AS cpu_Name, hdisk.Name AS hdisk_Name, nb.Name AS nb_Name
FROM manuf
LEFT JOIN cpu USING (IDM)
LEFT JOIN hdisk USING (IDM)
LEFT JOIN nb USING (IDM)) AS manuf_prod
WHERE (cpu_Name IS NOT NULL AND hdisk_Name IS NOT NULL) OR (cpu_Name IS NOT NULL AND nb_Name IS NOT NULL) OR (nb_Name IS NOT NULL AND hdisk_Name IS NOT NULL);


SELECT manuf_title
FROM (SELECT manuf.Name AS manuf_title , count(*) AS manuf_amount
FROM manuf
LEFT JOIN cpu USING (IDM)
GROUP BY manuf.Name) AS manufs_amounts
WHERE manuf_amount > 1;