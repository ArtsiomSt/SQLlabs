-- ??? - Что такое транзакция? Как работает транзакция? Когда и для чего используют транзакции?
-- ??? - Что такое индексы? Как работают индексы? Какие бывают индексы?

-- ----------------------------------------------------------------------------------------------------------------------------------------
/* 	№1	Привести пример использования транзакции. Транзакция должна завершиться успешно. */

-- Решение:

USE lr5;
-- DROP PROCEDURE addmarkt;

delimiter //
CREATE PROCEDURE addmarkt(bookid INT, userid INT, markpage INT, context VARCHAR(128))
BEGIN
	IF markpage > (SELECT pages FROM books WHERE IDB=bookid) OR (SELECT COUNT(*) FROM books WHERE IDB=bookid) <> 1 THEN ROLLBACK;
    ELSE INSERT INTO bumark VALUES(bookid, userid, markpage,context, now());
		 SELECT * FROM bumark;
	END IF;
END//
delimiter ;


SELECT * FROM books
WHERE IDB = 1 OR IDB = 2;


delimiter //
START TRANSACTION//

UPDATE books 
SET Price=Price*2
WHERE IDB = 1 OR IDB = 2//

SELECT * FROM users WHERE IDU = 5//

CALL addmarkt(3,3,1,'mark2')//

COMMIT//
delimiter ;


-- ----------------------------------------------------------------------------------------------------------------------------------------
/* 	№2	Привести пример использования транзакции. Транзакция должна должна быть отклонена. */

-- Решение: 

delimiter //
START TRANSACTION//

UPDATE books 
SET Price=Price*2
WHERE IDB = 1 OR IDB = 2//

SELECT * FROM users WHERE IDU = 5//

CALL addmarkt(33333333,3,1,'mark2')//

COMMIT//
delimiter ;

-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№3 Создать таблицу "Buy", которая состоит из полей: ID - первичный ключ, авто заполняемое. IDB, IDU, TimeBuy
. Создать уникальный составной индекс для IDB, IDU. Создать обычный индекс TimeBuy, обратный порядок.
*/


CREATE TABLE Buy (
ID INT PRIMARY KEY,
IDU INT,
IDB INT,
TimeBuy DATETIME,
FOREIGN KEY (IDB) REFERENCES books(IDB),
FOREIGN KEY (IDU) REFERENCES users(IDU)
);

CREATE UNIQUE INDEX buy_idb_idu ON Buy(IDU, IDB);

CREATE INDEX buy_timebuy ON buy(TimeBuy);

-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№4  Модифицировать таблицу "Buy", добавить поле для хранения стоимости покупки "Cost".*/

-- Решение:

ALTER TABLE Buy
ADD COLUMN Cost DOUBLE;

-- ----------------------------------------------------------------------------------------------------------------------------------------
-- **{Создать хранимую процедуру для добавления записи о покупке книги и подсчета итоговой цены книги с учетом всех скидок и предложений. Полученная стоимость записывается в поле "Cost". }

-- Решение:



-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№5	Изменить триггер для таблицы USERS, который теперь должен срабатывать при изменении адреса почтового ящика.*/ 

-- Решение:
SELECT * FROM arusers;

CREATE TABLE old_email(
	IDU INT,
    email VARCHAR(128)
);

delimiter //
CREATE TRIGGER email_save
AFTER UPDATE ON users FOR EACH ROW
BEGIN
IF (SELECT mail FROM users WHERE IDU = old.IDU) <> (SELECT mail FROM arusers WHERE IDU=old.IDU) THEN INSERT INTO old_email(IDU, email) SELECT IDU, mail FROM arusers WHERE IDU=old.IDU; 
END IF;
END//
delimiter ;

UPDATE users
SET mail = 'asdfsadf@sadsadf.rg'
WHERE IDU = 2;

SELECT * FROM arusers;
SELECT * FROM old_email;
-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№6	Для таблицы пользователей заменить пароль, который хранится в открытом виде, на тот же, но захешированный методом md5.*/

-- Решение:

UPDATE users
SET pass = md5(pass);

-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№7	Вывести количество и среднее значение стоимости книг, которые были просмотрены, но не разу не были куплены.*/

-- Решение:

SELECT Count(*) AS books_amount, AVG(Price) AS avg_price
FROM(
SELECT DISTINCT IDB, Title, Price
FROM books
INNER JOIN buview USING (IDB)
LEFT JOIN bubuy USING (IDB)
WHERE Datetime IS NULL
) as e0;

SELECT *
FROM books
INNER JOIN buview USING (IDB)
LEFT JOIN bubuy USING (IDB)
WHERE Title = 'Двоедушник';

-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№8	Вывести количество купленных книг, а также суммарную их стоимость для тем с кодом с 1 по 6 включительно.*/

-- Решение:
SELECT COUNT(*) AS books_amount, SUM(PRICE) AS sum_price
FROM (
SELECT DISTINCT Title, IDB, Price, IDT
FROM books 
INNER JOIN bt USING (IDB)
WHERE IDT BETWEEN 1 AND 6
ORDER BY IDT DESC
) AS e0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	№9	Вывести Название книги, Имя автора, Логин покупателя для книг, которые были куплены в период с июня по август 2018 года включительно, написаны
 в тематике 'фэнтези' и 'классика', при условии, что число страниц должно быть от 700 до 800 включительно и цена книги меньше 500.*/

-- Решение:


SELECT Title, NameA, login
FROM(
SELECT IDB, Title, NameA, login, GROUP_CONCAT(Theme) AS themes, Pages, price
FROM books
INNER JOIN BA USING (IDB)
INNER JOIN bubuy USING (IDB)
INNER JOIN users USING (IDU)
INNER JOIN bt USING (IDB)
INNER JOIN Theme USING (IDT)
GROUP BY IDB
HAVING (themes LIKE "%фэнтези%" OR themes LIKE '%классика%') AND Pages BETWEEN 700 AND 800 AND PRICE < 500
) AS e0;

-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	**{Создать таблицу «Авторы», где бы хранились имена авторов без повторений (Варианты Толстой Лев, Толстой Л.Н. и др. считать уникальными) и его ID. }	*/

-- Решение:

CREATE TABLE Authors(
	IDA INT PRIMARY KEY AUTO_INCREMENT,
    AuthName VARCHAR(128)
);



INSERT INTO Authors 
SELECT (@auth_id:=@auth_id+1) AS IDA, NameA
FROM (
SELECT DISTINCT NameA
FROM books 
RIGHT JOIN ba USING (IDB)
) AS e0;

SELECT * FROM Authors;
-- ----------------------------------------------------------------------------------------------------------------------------------------
/*	**{Создать новую таблицу «ВА» для связи таблиц «Книги» и «Авторы» через ID, и заполнить её.}	*/

-- Решение:

CREATE TABLE BANEW(
	IDB INT,
    IDA INT,
    FOREIGN KEY (IDB) REFERENCES books(IDB),
    FOREIGN KEY (IDA) REFERENCES Authors(IDA)
);


INSERT INTO BANEW
SELECT IDB, IDA
FROM books
INNER JOIN BA USING (IDB)
INNER JOIN Authors ON NameA = Authors.AuthName;

-- ----------------------------------------------------------------------------------------------------------------------------------------
