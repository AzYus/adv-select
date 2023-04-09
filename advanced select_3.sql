SELECT * FROM album
WHERE release_year  = 2018;

select title, duration
from song
order by duration DESC
limit 1;

select title
from song
where duration >= 210;

select name
from playlist
where (release_date >= '2018-01-01') and (release_date <= '2020-12-31');

select name
from artist
where not name like '%% %%';

select title
from song
where title like '%%my%%';

--Количество исполнителей в каждом жанре.
select g.name, count(a.name)
from genre as g
left join artist_genre as ag on g.id = ag.ge_id
left join artist as a on ag.artist_id = a.id
group by g.name
order by count(a.id) desc

--Количество треков, вошедших в альбомы 2019–2020 годов.
select al.name, count(s.title)
from album as al
left join song as s on s.album_id = al.id
where (al.release_year >= 2019) and (al.release_year <= 2020)
group by al.name

--Средняя продолжительность треков по каждому альбому.
select al.name, avg(s.duration)
from album as al
left join song as s on s.album_id = al.id
group by al.name

--Все исполнители, которые не выпустили альбомы в 2020 году.
select distinct a.name from artist as a
where a.name not in (
	select distinct a.name from artist as a
	left join artist_album as aa on a.id = aa.artist_id
	left join album as al on al.id = aa.album_id
	where al.release_year = 2020
)
group by a.name

--Названия сборников, в которых присутствует конкретный исполнитель (выберите его сами).
select p.name from playlist as p
left join playlist_song as ps on p.id = ps.playlist_id
left join song as s on s.id = ps.song_id
left join album as al on al.id = s.album_id
left join artist_album as aa on aa.album_id = al.id
left join artist as a on a.id = aa.artist_id
where a.name like '%%Eminem%%'
order by p.name

--Названия альбомов, в которых присутствуют исполнители более чем одного жанра.
select al.name from album as al
left join artist_album as aa on al.id = aa.album_id
left join artist as a on a.id = aa.artist_id
left join artist_genre ag on a.id = ag.artist_id
left join genre as g on g.id = ag.ge_id
group by al.name
having count(distinct g.name) > 1
order by al.name

--Наименования треков, которые не входят в сборники.
select s.title from song s
left join playlist_song ps on s.id = ps.song_id
where ps.song_id is null

--Исполнитель или исполнители, написавшие самый короткий по продолжительности трек, — теоретически таких треков может быть несколько.
select a.name, s.duration from song s
left join album al on al.id = s.album_id 
left join artist_album aa on al.id = aa.album_id
left join artist a on a.id = artist_id
group by a.name, s.duration 
having s.duration = (select min(duration) from song)
order by a.name

--Названия альбомов, содержащих наименьшее количество треков.
select distinct al.name from album as al
left join song s on s.album_id = al.id
where s.album_id in (
    select album_id from song
    group by album_id
    having count(id) = (
        select count(id)
        from song
        group by album_id
        order by count
        limit 1
    )
)
order by al.name
