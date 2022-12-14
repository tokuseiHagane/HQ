CREATE DATABASE IF NOT EXISTS appdb;
CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'password';
GRANT SELECT,UPDATE,INSERT ON appdb.* TO 'user'@'%';
FLUSH PRIVILEGES;

USE appdb;
SET NAMES utf8;


CREATE TABLE article
(
	id_article           INTEGER NOT NULL AUTO_INCREMENT,
	title                TINYTEXT NULL,
	content              TEXT NOT NULL,
	time                 TIME NOT NULL,
	id_source            INTEGER NOT NULL,
	primary key (id_article)
);



CREATE TABLE media
(
	id_media             INTEGER NOT NULL AUTO_INCREMENT,
	media_link           VARCHAR(190) NOT NULL,
	id_media_type        INTEGER NOT NULL,
	primary key (id_media)
);



CREATE TABLE media_sequence
(
	id_media_sequence    INTEGER NOT NULL AUTO_INCREMENT,
	id_media             INTEGER NOT NULL,
	id_article           INTEGER NOT NULL,
	primary key (id_media_sequence)
);



CREATE TABLE media_type
(
	id_media_type        INTEGER NOT NULL AUTO_INCREMENT,
	type                 TINYTEXT NOT NULL,
	primary key (id_media_type)
);



CREATE TABLE publish_sequence
(
	id_publish_sequence          INTEGER NOT NULL AUTO_INCREMENT,
	date                 DATE NOT NULL,
	id_article           INTEGER NOT NULL,
	primary key (id_publish_sequence)
);



CREATE TABLE source_tag
(
	id_source_tag       INTEGER NOT NULL AUTO_INCREMENT,
	type                 TINYTEXT NOT NULL,
	primary key (id_source_tag)
);



CREATE TABLE source
(
	id_source            INTEGER NOT NULL AUTO_INCREMENT,
	url                  VARCHAR(190) NOT NULL,
	name                 TINYTEXT NOT NULL,
	id_url_type          INTEGER NOT NULL,
	primary key (id_source)
);



CREATE TABLE source_tags
(
	id_source_tags INTEGER NOT NULL AUTO_INCREMENT,
	id_source          	INTEGER NOT NULL,
	id_source_tag         INTEGER NOT NULL,
	primary key (id_source_tags)
);



CREATE TABLE url_type
(
	id_url_type          INTEGER NOT NULL AUTO_INCREMENT,
	type                 TINYTEXT NOT NULL,
	primary key (id_url_type)
);


ALTER TABLE article
ADD FOREIGN KEY SOURCE_KEY (id_source) REFERENCES source (id_source);



ALTER TABLE media
ADD FOREIGN KEY MEDIA_TYPE_KEY (id_media_type) REFERENCES media_type (id_media_type);



ALTER TABLE media_sequence
ADD FOREIGN KEY MEDIA_KEY (id_media) REFERENCES media (id_media);



ALTER TABLE media_sequence
ADD FOREIGN KEY ARTICLE_KEY (id_article) REFERENCES article (id_article);



ALTER TABLE source_tags
ADD FOREIGN KEY TAG_KEY (id_source_tag) REFERENCES source_tag (id_source_tag);



ALTER TABLE source_tags
ADD FOREIGN KEY SOURCE_KEY (id_source) REFERENCES source (id_source);



ALTER TABLE publish_sequence
ADD FOREIGN KEY ARTICLE_KEY (id_article) REFERENCES article (id_article);



ALTER TABLE source
ADD FOREIGN KEY URL_KEY (id_url_type) REFERENCES url_type (id_url_type);


-- INSERT TYPES

INSERT INTO source_tag (type) VALUES 
("internet"), -- 1
("sport"), -- 2
("politics"), -- 3
("economics"), -- 4
("culture"), -- 5
("science"), -- 6
("society"), -- 7
("religion"); -- 8

INSERT INTO url_type (type) VALUES 
("rss"),
("site"),
("tg");

INSERT INTO media_type (type) VALUES 
("image"),
("video");

-- INSERT media, source

INSERT INTO media (media_link, id_media_type) VALUES
("https://i.imgur.com/dQT7037.jpeg", 1),
("https://i.imgur.com/lqwLBio.jpeg", 1),
("https://i.imgur.com/0uNlWHd.jpeg", 1),
("https://i.imgur.com/GLxlby0.jpeg", 1),
("https://i.imgur.com/I2IgQP3.jpeg", 1),
("https://i.imgur.com/9BFTmH6.png", 1),
("https://i.imgur.com/eAoBzS5.jpeg", 1);

INSERT INTO source (url, name, id_url_type) VALUES
("https://t.me/interfaxonline", "Интерфакс", 3),
("https://t.me/prime1", "ПРАЙМ", 3),
("https://www.opennet.ru/opennews/opennews_full.rss", "Opennet", 1),
("https://.rbc.ru/", "РБК", 1),
("https://ria.ru/", "РИА Новости", 1);

INSERT INTO source_tags (id_source, id_source_tag) VALUES
(4, 3),(4, 4),(4, 5),(4, 6),(4, 7),
(5, 2),(5, 3),(5, 4),(5, 5),(5, 6),(5, 7),
(3, 1),(3, 5),(3, 6),(3, 7),
(2, 4),(2, 7),
(1, 2),(1, 3),(1, 4),(1, 5),(1, 6),(1, 7);

-- INSERT article, publish_sequence, media_sequence

INSERT INTO article (title, content, time, id_source) VALUES
("Доступен Vieb 9.4, web-браузер в стиле редактора Vim", "Опубликован web-браузер Vieb 9.4, оптимизированный для управления с клавиатуры, используя принципы работы и комбинации клавиш, свойственные для текстового редактора vim (например, для ввода текста в форме необходимо переходить в режим вставки). Код написан на языке JavaScript и распространяется под лицензией GPLv3. Интерфейс построен на базе платформ Electron, а в качестве web-движка задействован Chromium. Готовые сборки подготовлены для Linux (AppImage, snap, deb, rpm, pacman), Windows и macOS.",
"12:12:00", 3),
("Океан между Европой и США становится все шире и глубже", "Любому школьнику известно, что Евразийский и Североамериканский континенты разделяет Атлантический океан. Если говорить метафорически, то сегодня Европа и США так же разделены, только в отличие от своего географического собрата океан геополитических противоречий между союзниками постепенно становится все глубже и шире. Эммануэль Макрон, выступая в эфире телеканала CBS News, озвучил уже явную, но все еще неприглядную изнанку отношений между двумя центрами западного мира.
Президент Франции, в частности, сказал, что Брюссель и Вашингтон имеют абсолютно солидарные позиции по украинскому (читай: антироссийскому) вопросу, однако положение союзников вовсе не паритетное. Макрон упоминает самые болезненные вопросы текущей повестки, а именно энергетический кризис и цены на энергоносители. Европа, скрупулезно выполнившая все требования в вопросах введения санкций и самоограничения российских энергоресурсов, теперь находится в гораздо более уязвимом и зависимом положении.",
"08:00:00", 5),
("Зеленский и премьер Черногории подписали договор о членстве Украины в НАТО", "БЕЛГРАД, 5 дек – РИА Новости. Премьер Черногории Дритан Абазович по видеосвязи подписал с президентом Украины Владимиром Зеленским декларацию о евроатлантической перспективе Киева, сообщила пресс-служба черногорского правительства.
Ранее президент Черногории Мило Джуканович вместе с восемью лидерами стран Восточной Европы выразил поддержку поданной в конце сентября заявке Киева на членство в НАТО. Правительство Черногории сообщало, что передаст в качестве дотации Украине 11% своих оборонных расходов, которые согласно, проекту бюджета на 2023 год, составят около 67,3 миллиона евро.
Военнослужащий НАТО - РИА Новости, 1920, 05.12.2022
5 декабря, 09:26
СМИ: НАТО собирается использовать на Украине новые методы борьбы с Россией
'Черногория недвусмысленно поддерживает Украину в защите территориальной целостности и ее права выбирать, как хочет жить и в какие организации вступать', - заявил Абазович после подписания документа, содержание которого не раскрывается.
Черногорский премьер также указал, что его страна приняла больше всего украинских беженцев в регионе Западных Балкан.
'В настоящий момент у нас свыше 10 тысяч украинцев, их число может вырасти за время зимних месяцев. В сотрудничестве с посольством Украины работаем над тем, чтобы помочь приезду людей на реабилитацию в Черногорию', - заявил глава правительства, видеозапись разместила пресс-служба кабмина.
Абазович подчеркнул, что Киев может рассчитывать на политическую, военную и финансовую помощь официальной Подгорицы.",
"23:57:00", 5),
("Крупнейшие нефтяные компании России попали под санкции ЕС", "Евросоюз опубликовал новые санкционные списки в отношении российских компаний, предпринимателей, чиновников и членов их семей. В список структур, оказавшихся под санкциями, попали входящие в список крупнейших нефтегазовых компаний России — «Роснефть», «Газпром нефть» и трубопроводная компания «Транснефть».
Санкции введены в связи с ситуацией на Украине.
Помимо них в санкционном списке оказались:
«Оборонпром»;
Объединенная авиастроительная корпорация (ОАК);
Уралвагонзавод;
«Алмаз-Антей»;
КамАЗ;
Ростех;
«Севмаш»;
«Совкомфлот»;
Объединенная судостроительная корпорация.
Сделки и транзакции с ними в юрисдикции ЕС запрещены в связи с тем, что эти структуры контролируются государством.
Вместе с тем запрещать торговлю нефтью, газом и другими полезными энергоносителями с этими компаниями Евросоюз не стал. Для этих категорий товаров в санкционном листе оговорено исключение. «Запрет... не распространяется на операции, которые необходимы для импорта или транспортировки ископаемого топлива, в частности угля, нефти
и природного газа, а также титана, алюминия, меди, никеля, палладия и железной руды из России или через Россию», — говорится в документе.
Кроме того, Евросоюз расширяет санкционные списки, введенные еще в 2014 году после присоединения Крыма к России. В них попало еще порядка 80 менее крупных коммерческих и государственных структур. Например, под санкциями ЕС оказалась компания Baikal Electronics — проектировщик отечественных процессоров серии «Байкал»; Crocus Nano Electronics — компания по производству микроэлектроники, созданная по инициативе «Роснано»; научно-производственный комплекс «Элара», выпускающий электронику военного и гражданского назначения, и другие.",
"20:06:00", 4),
("Путин заявил, что необходимости для новой волны мобилизации сейчас нет", "В России в настоящее время нет необходимости в проведении дополнительной мобилизации, заявил президент страны Владимир Путин. Трансляцию вел РБК.
«В дополнительных мобилизационных мероприятиях необходимости на сегодняшний день нет никакой», — сказал он на встрече с членами Совета по правам человека.
Глава государства напомнил, что в России во время частичной мобилизации были призваны 300 тыс. граждан. «150 тыс. находятся в зоне проведения операции. То есть половина — в войсках, в группировке. Из этих 150 тыс. половина — а это 77 тыс. — находятся на боевых позициях, остальные находятся на вторых или третьих рубежах, выполняя функцию по сути войск территориальной обороны, или проходят дополнительную подготовку в зоне проведения спецоперации», — отметил Путин.
Военная операция на Украине. Онлайн
Политика
По его словам, 150 тыс. мобилизованных, то есть половина из общего количества попавших под частичную мобилизацию, не находятся в войсковой группировке в зоне спецоперации. «Они до сих пор находятся на полигонах и в учебных центрах Министерства обороны, где проходят дополнительную подготовку. Это так называемый боевой резерв. В этих условиях разговоры о каких-то дополнительных мобилизационных мероприятиях просто не имеют смысла», — заключил президент.
Ранее, 4 ноября, Путин говорил о том, что в ходе частичной мобилизации Минобороны призвало из запаса достаточное количество военнослужащих. По оценке президента, таковых насчитывалось 318 тыс. человек, включая добровольцев. К началу месяца в зону боевых действий направили около 50 тыс. человек. В конце ноября глава государства провел встречу с матерями участников спецоперации, и на слова одной из женщин, которая сказала, что скоро ее младшему сыну исполнится 18 лет, и он, как и двое других ее сыновей, будет призван и тоже «пойдет воевать», Путин ответил: «Не надо, не надо, хватит».", 
"17:26:00", 4);
INSERT INTO publish_sequence (date, id_article) VALUES
("2022-12-07", 1),
("2022-12-06", 2),
("2022-12-05", 3),
("2022-04-15", 4),
("2022-12-07", 5);
INSERT INTO media_sequence (id_article, id_media) VALUES
(1, 1),(1, 2),(3, 3),(3, 4),(4, 5),(5, 6),(5, 7);
-- delete триггеры для полседовательностей
-- удаление статьи из publish_sequence (удаляет статью из общего хранилища)
delimiter //
create trigger delete_article before delete on publish_sequence for each row
begin
delete from article where article.id_article=old.id_article;
end
//
delimiter ;
-- удаление вложения из media_sequence (удаляет отвязвнное вложение из общего хранилища)
delimiter //
create trigger delete_media before delete on media_sequence for each row
begin
delete from media where media.id_media=old.id_media;
end
//
delimiter ;
-- удаление тэга из source_tag (отвязывает тэг от ресурса)
delimiter //
create trigger delete_source_tag before delete on source_tag for each row
begin
delete from source_tags where source_tags.id_source_tag=old.id_source_tag;
end
//
delimiter ;

-- процедуры на получение
-- процедура для получения статей по дате
delimiter //
create definer = 'root'@'localhost' procedure appdb.getArticlesByDate (in curDate date)
begin
   select a.id_article, p.date, a.time, a.title, a.content, s.name
   from appdb.publish_sequence as p left join appdb.article as a
   on p.date = curDate join appdb.source as s
   on a.id_source = s.id_source;
end
//
delimiter ;

-- процедура для получения вложений по статье
delimiter //
create definer = 'root'@'localhost' procedure appdb.getMediaByArticle (in ID int)
begin
   select a.id_article, m.media_link, t.type
   from appdb.article as a right join appdb.media_sequence as s
   on a.id_article = ID and s.id_article = ID join appdb.media_type as t
   on t.id_media_type = s.id_media_type;
end
//
delimiter ;

-- процедура для добавления новой статьи
-- date                 DATE NOT NULL (для publish),
-- id_article           INTEGER NOT NULL (для publish),
-- title                TINYTEXT NULL,
-- content              TEXT NOT NULL,
-- time                 TIME NOT NULL,
-- name            INTEGER NOT NULL,

delimiter //
create definer = 'root'@'localhost' procedure appdb.insertNewArticle
(in title tinytext, in content text, in article_time time, in article_date date, in source_name TINYTEXT)
begin
	SET @source_id = (select s.id_source from source as s where s.name = source_name);
	insert into article (title, content, time, id_source)
    values (title, content, article_time, (select @source_id));
    insert into publish_sequence (date, id_article) values (article_date, (SELECT LAST_INSERT_ID()));
end
//
delimiter ;

-- delimiter //
-- CREATE DEFINER=`root`@`localhost` FUNCTION Article.insertArticle()
-- BEGIN
-- 	insert 
-- 	SELECT sum(PriceMonth) as revenue from aboniment join aboniment_type on aboniment.id_sub_type = aboniment_type.id_sub_type;
-- END
-- //
-- delimiter ;


-- Запрос 1. Операция проекции

select a.id_article, a.title, a.time, a.id_source from article as a;

-- Запрос 2. Операция селекции

select a.id_article, a.title, a.time, a.id_source from article as a where a.id_source > 3;

-- Запрос 3. Операции соединения

select a.id_article, a.title, a.time, s.name from article as a, source as s
where a.id_source = s.id_source;

-- Запрос 4. Операция объединения

select m.id_media, m.media_link, t.type from media as m join media_type as t 
on m.id_media_type = t.id_media_type;

-- Запрос 5. Операция пересечения

select a.id_article, a.title, s.date from article as a join publish_sequence as s 
on a.id_article=s.id_article
where a.id_article=3 
and exists (select * from publish_sequence as s1
where s1.id_article=s.id_article and s1.id_article=3);

-- Запрос 6. Операция разности

select a.id_article, a.title, s.date from article as a join publish_sequence as s
on a.id_article=s.id_article
where not exists (select * from publish_sequence as s1
where s1.id_article=s.id_article and s1.id_article=3);


-- Запрос 7. Операция группировки

SELECT t.type, COUNT(m.id_media_type) AS count FROM media as m right join media_type as t
on m.id_media_type=t.id_media_type
GROUP BY t.type;

-- Запрос 8. Операция сортировки

select s.id_article, a.title, m.media_link, t.type from media as m join media_type as t 
on m.id_media_type = t.id_media_type join media_sequence as s
on s.id_media = m.id_media join article as a
on a.id_article = s.id_article order by s.id_article asc;

-- Запрос 9. Операция деления

-- select a.id_article, a.title, s.date from article as a join publish_sequence as s
-- on a.id_article=s.id_article
-- where not exists (select * from publish_sequence as s1
-- where s1.id_article=s.id_article and s1.id_article=3);

-- SELECT FIOTeacher FROM Teachers WHERE idTeacher IN 
-- (SELECT DISTINCT s0.idTeacher FROM Sessions AS s0
-- WHERE NumSemestr=1 AND
-- NOT EXISTS (SELECT DISTINCT s1.idTeacher, s2.NumGroup 
-- FROM Sessions AS s1, Sessions AS s2
-- WHERE s1.NumSemestr=1 AND s2.NumSemestr=1 
-- AND NOT EXISTS (SELECT * FROM Sessions
-- AS s3 WHERE s3.idTeacher=s1.idTeacher AND 
-- s3.NumGroup=s2.NumGroup)
-- AND s1.idTeacher=s0.idTeacher));