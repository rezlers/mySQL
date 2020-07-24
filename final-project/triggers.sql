DELIMITER //
DROP TRIGGER IF EXISTS inc_series_num//
CREATE TRIGGER inc_series_num AFTER INSERT ON series
FOR EACH ROW
BEGIN
	DECLARE series_num_var SMALLINT DEFAULT 0;
	SELECT series_num INTO series_num_var FROM seasons WHERE id = NEW.season_id;
	IF(series_num_var IS NOT NULL) THEN
		UPDATE seasons SET series_num = series_num_var + 1 WHERE id = NEW.season_id;
	ELSE
		UPDATE seasons SET series_num = 1 WHERE id = NEW.season_id;
	END IF;
END//

DELIMITER //
DROP TRIGGER IF EXISTS inc_seasons_num//
CREATE TRIGGER inc_seasons_num AFTER INSERT ON seasons
FOR EACH ROW
BEGIN
	DECLARE seasons_num_var SMALLINT DEFAULT 0;
	SELECT seasons_num INTO seasons_num_var FROM serials WHERE id = NEW.serial_id;
	IF(seasons_num_var IS NOT NULL) THEN
		UPDATE serials SET seasons_num = seasons_num_var + 1 WHERE id = NEW.serial_id;
	ELSE
		UPDATE serials SET seasons_num = 1 WHERE id = NEW.serial_id;
	END IF;
END//


