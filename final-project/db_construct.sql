DROP DATABASE IF EXISTS kinopoisk;
CREATE DATABASE kinopoisk DEFAULT charset cp1251;

USE kinopoisk;

DROP TABLE IF EXISTS films;
CREATE TABLE films (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	title_rus VARCHAR(100),
	tagline VARCHAR(200),
	show_year DATE,
	show_year_rus DATE,
	country VARCHAR(100),
	producer VARCHAR(200),
	genre VARCHAR(100),
	duration FLOAT4 UNSIGNED
) COMMENT = 'Список фильмов';

DROP TABLE IF EXISTS trailers;
CREATE TABLE trailers (
	id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	duration TIME,
	
	FOREIGN KEY (film_id) REFERENCES films(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT
) COMMENT = 'Список трейлеров к фильму';

DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
	id SERIAL PRIMARY KEY,
	name VARCHAR (200),
	date_of_birth DATE,
	place_of_birth VARCHAR(200),
	sex CHAR(1),
	intresting_facts text
) COMMENT = 'Список актеров';

DROP TABLE IF EXISTS actors_films;
CREATE TABLE actors_films (
	id SERIAL PRIMARY KEY,
	film_id BIGINT UNSIGNED NOT NULL,
	actor_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (film_id) REFERENCES films(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	FOREIGN KEY (actor_id) REFERENCES actors(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(film_id),
	INDEX(actor_id)
) COMMENT = 'Отношение таблиц актеров и фильмов ~ многие ко многим => нужна таблица связка';

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	login VARCHAR(200),
	sex CHAR(1),
	date_of_birth DATE
) COMMENT = 'Список пользователей';

DROP TABLE IF EXISTS roles_films;
CREATE TABLE roles_films (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200),
	actor_film BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (actor_film) REFERENCES actors_films(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT
) COMMENT = 'Отношение таблиц ролей и фильмов ~ многие ко многим => нужна таблица связка';

DROP TABLE IF EXISTS serials;
CREATE TABLE serials (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	title_rus VARCHAR(200),
	tagline VARCHAR(200),
	show_year DATE,
	show_year_rf DATE,
	country VARCHAR(100),
	producer VARCHAR(200),
	genre VARCHAR(100),
	seasons_num SMALLINT,
	released BOOL
) COMMENT = 'Список сериалов';

DROP TABLE IF EXISTS seasons;
CREATE TABLE seasons (
	id SERIAL PRIMARY KEY,
	serial_id BIGINT UNSIGNED NOT NULL,
	title VARCHAR(100),
	show_year DATE,
	show_year_rf DATE,
	num_of_season SMALLINT NOT NULL,
	series_num SMALLINT,
	released BOOL,
	
	FOREIGN KEY (serial_id) REFERENCES serials(id)
) COMMENT = 'Список сезонов. Так как сезоны принадлежат только одному сериалу => отношение таблиц сериалов и сезонов 1 к многим';

DROP TABLE IF EXISTS series;
CREATE TABLE series (
	id SERIAL PRIMARY KEY,
	season_id BIGINT UNSIGNED NOT NULL,
	title VARCHAR(100),
	show_year DATE,
	show_year_rf DATE,
	duration FLOAT4 UNSIGNED,
	num_of_seria SMALLINT,
	released BOOL,
	
	FOREIGN KEY (season_id) REFERENCES seasons(id)
) COMMENT = 'Список серий. Так как серии принадлежат только одному сезону => отношение таблиц сезонов и сериалов 1 к многим';

DROP TABLE IF EXISTS actors_serials;
CREATE TABLE actors_serials (
	id SERIAL PRIMARY KEY,
	serial_id BIGINT UNSIGNED NOT NULL,
	actor_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (serial_id) REFERENCES serials(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	FOREIGN KEY (actor_id) REFERENCES actors(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(serial_id),
	INDEX(actor_id)
) COMMENT = 'Отношение таблиц актеров и сериалов ~ многие ко многим => нужна таблица связка';

DROP TABLE IF EXISTS users_films;
CREATE TABLE users_films (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	film_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (film_id) REFERENCES films(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(film_id),
	INDEX(user_id)
) COMMENT = 'Отношение таблиц пользователей и фильмов ~ многие ко многим => нужна таблица связка';

DROP TABLE IF EXISTS users_serials;
CREATE TABLE users_serials (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	serial_id BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (serial_id) REFERENCES serials(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	FOREIGN KEY (user_id) REFERENCES users(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(serial_id),
	INDEX(user_id)
) COMMENT = 'Отношение таблиц пользователей и сериалов ~ многие ко многим => нужна таблица связка';

DROP TABLE IF EXISTS ratings_films;
CREATE TABLE ratings_films (
	id SERIAL PRIMARY KEY,
	value FLOAT4 UNSIGNED,
	user_film BIGINT UNSIGNED NOT NULL,
	created_date TIMESTAMP,
	
	FOREIGN KEY (user_film) REFERENCES users_films(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(user_film)
) COMMENT = 'Рейтинг фильмов. Нужна отдельная таблица для фильмов, так как иначе возникают конфликты внешних ключей, которые указывают на сериал и фильм(вместе они не могут быть заполнены). Атрибут user_film указывает на соответствующую таблицу связку';

DROP TABLE IF EXISTS ratings_serials;
CREATE TABLE ratings_serials (
	id SERIAL PRIMARY KEY,
	value FLOAT4 UNSIGNED,
	user_serial BIGINT UNSIGNED NOT NULL,
	created_date TIMESTAMP,
	
	FOREIGN KEY (user_serial) REFERENCES users_serials(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(user_serial)
) COMMENT = 'Рейтинг сериалов. Нужна отдельная таблица для сериалов, так как иначе возникают конфликты внешних ключей, которые указывают на сериал и фильм(вместе они не могут быть заполнены). Атрибут user_serial указывает на соответствующую таблицу связку';

DROP TABLE IF EXISTS comments_serials;
CREATE TABLE comments_serials (
	id SERIAL PRIMARY KEY,
	title VARCHAR(200),
	body text,
	user_serial BIGINT UNSIGNED NOT NULL,
	created_date TIMESTAMP,
	
	FOREIGN KEY (user_serial) REFERENCES users_serials(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(user_serial)
) COMMENT = 'Комментарии для сериалов. Выделять для сериалов нужно по аналогичным причинам, что и для таблиц рейтингов. Атрибут user_serial указывает на соответствующую таблицу связку';

DROP TABLE IF EXISTS comments_films;
CREATE TABLE comments_films (
	id SERIAL PRIMARY KEY,
	title VARCHAR(200),
	body text,
	user_film BIGINT UNSIGNED NOT NULL,
	created_date TIMESTAMP,
	
	FOREIGN KEY (user_film) REFERENCES users_films(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT,
	INDEX(user_film)
) COMMENT = 'Комментарии для фильмов. Выделять для фильмов нужно по аналогичным причинам, что и для таблиц рейтингов. Атрибут user_film указывает на соответствующую таблицу связку';

DROP TABLE IF EXISTS roles_serials;
CREATE TABLE roles_serials (
	id SERIAL PRIMARY KEY,
	name VARCHAR(200),
	actor_serial BIGINT UNSIGNED NOT NULL,
	
	FOREIGN KEY (actor_serial) REFERENCES actors_serials(id)
	ON UPDATE CASCADE 
	ON DELETE RESTRICT
) COMMENT = 'Список ролей, поле actor_serial указывает на отношение в таблице связке actors_serials, в которой эта роль актуальна';










