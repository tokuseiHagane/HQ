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