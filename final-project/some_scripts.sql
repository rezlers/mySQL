CREATE VIEW films_roles_actors (names_of_actors, names_of_roles, titles_of_films) AS 
SELECT a.name, r.name, f.title FROM actors a JOIN actors_films af ON a.id = af.actor_id JOIN films f ON f.id = af.film_id JOIN roles_films r ON r.actor_film = af.id; 
-- посмотреть роль актеров в фильме
CREATE VIEW comments_and_ratings_films (login_of_user, title_of_film, rating, comment) AS
SELECT u.login, f.title, rf.value, cf.body FROM users u JOIN users_films uf ON u.id = uf.user_id JOIN films f ON f.id = uf.film_id JOIN comments_films cf ON cf.user_film = uf.id JOIN ratings_films rf ON rf.user_film = uf.id;
-- посмотреть комментарии пользователя по фильмам и оценку пользователем фильмов

CREATE VIEW serials_roles_actors (names_of_actors, names_of_roles, titles_of_serials) AS 
SELECT a.name, rs.name, s.title FROM actors a JOIN actors_serials `as` ON a.id = `as`.actor_id JOIN serials s ON s.id = `as`.serial_id JOIN roles_serials rs ON rs.actor_serial = `as`.id;
-- посмотреть роль актеров в сериале
CREATE VIEW comments_and_ratings_serials (login_of_user, title_of_serial, rating, comment) AS
SELECT u.login, s.title, rs.value, cs.body FROM users u JOIN users_serials us ON u.id = us.user_id JOIN serials s ON s.id = us.serial_id JOIN comments_serials cs ON cs.user_serial = us.id JOIN ratings_serials rs ON rs.user_serial = us.id; 
-- посмотреть комментарии пользователя по сериалам и оценку пользователем сериалов

SELECT AVG(rf.value) average_value, f.title FROM films f JOIN users_films uf ON f.id = uf.film_id JOIN users u ON u.id = uf.user_id
JOIN ratings_films rf ON rf.user_film = (SELECT id FROM users_films ufvz WHERE ufvz.film_id = f.id AND ufvz.user_id = u.id)
GROUP BY f.title; 
-- посмотреть рейтинг фильмов(на данный момент, усредненный)

SELECT AVG(rs.value) average_value, s.title FROM serials s JOIN users_serials us ON s.id = us.serial_id JOIN users u ON u.id = us.user_id
JOIN ratings_serials rs ON rs.user_serial = (SELECT id FROM users_serials usvz WHERE usvz.serial_id = s.id AND usvz.user_id = u.id)
GROUP BY s.title;
-- посмотреть рейтинг сериалов(на данный момент, усредненный)

-- SELECT * FROM films_roles_actors;
-- 
-- SELECT * FROM comment_and_ratings_films;
-- 
-- SELECT * FROM serials_roles_actors;
-- 
-- SELECT * FROM comment_and_ratings_serials;
