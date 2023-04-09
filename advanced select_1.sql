create table if not exists album 
(
	id SERIAL primary key,
	name VARCHAR (60) NOT null unique,
	release_year numeric(4) NOT null
);

create table if not exists song 
(
	id SERIAL primary key,
	title VARCHAR (60) NOT null,
	duration_sec integer not null,
	album_id integer not null references album (id)
);

create table if not exists artist
(
	id SERIAL primary key,
	name VARCHAR (60) NOT null
);

create table if not exists genre 
(
	id SERIAL,
	name VARCHAR (60),
	primary key (id, name)
);

create table if not exists playlist 
(
	id SERIAL primary key,
	name VARCHAR (60) NOT null,
	release_date date check (release_date between date '1900-01-01' and sysdate)
);

create table if not exists playlist_song 
(
	playlist_id INTEGER REFERENCES playlist(id),
	song_id INTEGER REFERENCES song(id),
	CONSTRAINT pk PRIMARY KEY (playlist_id, song_id)
);

create table if not exists artist_album
(
	artist_id INTEGER REFERENCES artist(id),
	album_id INTEGER REFERENCES album(id),
	CONSTRAINT pk PRIMARY KEY (artist_id, album_id)
);

create table if not exists artist_genre
(
	artist_id INTEGER REFERENCES artist(id),
	ge_id INTEGER REFERENCES genre(id)
);

