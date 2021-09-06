SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

DROP TABLE IF EXISTS activities_students CASCADE;
DROP TABLE IF EXISTS teachers_classrooms CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS classrooms CASCADE;
DROP TABLE IF EXISTS alerts CASCADE;
DROP TABLE IF EXISTS attendance CASCADE;
DROP TABLE IF EXISTS files CASCADE;

SET FOREIGN_KEY_CHECKS = 1;
SET UNIQUE_CHECKS = 1;

-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema hibredu_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema hibredu_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `hibredu_db` DEFAULT CHARACTER SET latin1 ;
USE `hibredu_db` ;

-- -----------------------------------------------------
-- Table `hibredu_db`.`classrooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`classrooms` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`files`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`files` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `content` LONGBLOB NOT NULL,
  `type` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`schools`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`schools` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hibredu_db`.`teachers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`teachers` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `schools_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_teachers_schools1_idx` (`schools_id` ASC)  ,
  CONSTRAINT `fk_teachers_schools1`
    FOREIGN KEY (`schools_id`)
    REFERENCES `hibredu_db`.`schools` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`activities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`activities` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `subject` VARCHAR(255) NOT NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  `max_note` DOUBLE NOT NULL,
  `classrooms_id` BIGINT(20) NULL,
  `files_id` INT(11) NULL,
  `teachers_id` BIGINT(20) NULL,
  PRIMARY KEY (`id`),
  INDEX `activities_classrooms_fk` (`classrooms_id` ASC)  ,
  INDEX `activities_files_fk` (`files_id` ASC)  ,
  INDEX `fk_activities_teachers1_idx` (`teachers_id` ASC)  ,
  CONSTRAINT `activities_classrooms_fk`
    FOREIGN KEY (`classrooms_id`)
    REFERENCES `hibredu_db`.`classrooms` (`id`),
  CONSTRAINT `activities_files_fk`
    FOREIGN KEY (`files_id`)
    REFERENCES `hibredu_db`.`files` (`id`),
  CONSTRAINT `fk_activities_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`students` (
  `id` VARCHAR(30) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `classrooms_id` BIGINT(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_students_classrooms1_idx` (`classrooms_id` ASC)  ,
  CONSTRAINT `fk_students_classrooms1`
    FOREIGN KEY (`classrooms_id`)
    REFERENCES `hibredu_db`.`classrooms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`activities_students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`activities_students` (
  `id` DOUBLE NOT NULL AUTO_INCREMENT,
  `delivered` DOUBLE NOT NULL,
  `status` VARCHAR(50) NULL DEFAULT NULL,
  `grade` DOUBLE NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `students_id` VARCHAR(30) NOT NULL,
  `activities_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_activities_students_students1_idx` (`students_id` ASC)  ,
  INDEX `fk_activities_students_activities1_idx` (`activities_id` ASC)  ,
  CONSTRAINT `fk_activities_students_students1`
    FOREIGN KEY (`students_id`)
    REFERENCES `hibredu_db`.`students` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_activities_students_activities1`
    FOREIGN KEY (`activities_id`)
    REFERENCES `hibredu_db`.`activities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`alerts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`alerts` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `value` LONGBLOB NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `teachers_id` BIGINT(20) NOT NULL,
  `students_id` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_alerts_teachers1_idx` (`teachers_id` ASC)  ,
  INDEX `fk_alerts_students1_idx` (`students_id` ASC)  ,
  CONSTRAINT `fk_alerts_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alerts_students1`
    FOREIGN KEY (`students_id`)
    REFERENCES `hibredu_db`.`students` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`attendance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`attendance` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `class_subject` BLOB NULL DEFAULT NULL,
  `files_id` INT(11) NOT NULL,
  `classrooms_id` BIGINT(20) NOT NULL,
  `teachers_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_attendance_files1_idx` (`files_id` ASC)  ,
  INDEX `fk_attendance_classrooms1_idx` (`classrooms_id` ASC)  ,
  INDEX `fk_attendance_teachers1_idx` (`teachers_id` ASC)  ,
  CONSTRAINT `fk_attendance_files1`
    FOREIGN KEY (`files_id`)
    REFERENCES `hibredu_db`.`files` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attendance_classrooms1`
    FOREIGN KEY (`classrooms_id`)
    REFERENCES `hibredu_db`.`classrooms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attendance_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`teachers_classrooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`teachers_classrooms` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `classrooms_id` BIGINT(20) NOT NULL,
  `teachers_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_teachers_classrooms_classrooms1_idx` (`classrooms_id` ASC)  ,
  INDEX `fk_teachers_classrooms_teachers1_idx` (`teachers_id` ASC)  ,
  CONSTRAINT `fk_teachers_classrooms_classrooms1`
    FOREIGN KEY (`classrooms_id`)
    REFERENCES `hibredu_db`.`classrooms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teachers_classrooms_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`attendance_students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`attendance_students` (
  `attendance_id` BIGINT(20) NOT NULL,
  `students_id` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`attendance_id`, `students_id`),
  INDEX `fk_attendance_has_students_students1_idx` (`students_id` ASC)  ,
  INDEX `fk_attendance_has_students_attendance1_idx` (`attendance_id` ASC)  ,
  CONSTRAINT `fk_attendance_has_students_attendance1`
    FOREIGN KEY (`attendance_id`)
    REFERENCES `hibredu_db`.`attendance` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_attendance_has_students_students1`
    FOREIGN KEY (`students_id`)
    REFERENCES `hibredu_db`.`students` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* INSERÇÕES DE TESTES */

INSERT INTO schools (name) values('FIAP');
INSERT INTO schools (name) values('FIAP COPI');

INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Je', 'jean@hibredu.com.br', '$2a$08$ykA7e8O16xs12d/InZ/VgefjY.LrbaYeShQljIwvj8xLFjY8PjkuS', '1195581190', 1);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Felipe', 'felipe@hibredu.com.br', '$2a$08$ykA7e8O16xs12d/InZ/VgefjY.LrbaYeShQljIwvj8xLFjY8PjkuS', '1195581190', 1);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Vini', 'vinicius@hibredu.com.br', '$2a$08$ykA7e8O16xs12d/InZ/VgefjY.LrbaYeShQljIwvj8xLFjY8PjkuS', '1195581190', 2);

INSERT INTO classrooms (name) VALUES ('1o ano');
INSERT INTO classrooms (name) VALUES ('2o ano');
INSERT INTO classrooms (name) VALUES ('3o ano');
INSERT INTO classrooms (name) VALUES ('4o ano');
INSERT INTO classrooms (name) VALUES ('5o ano');

INSERT INTO students (id, name, email, classrooms_id) VALUES (1, 'Felipe', 'felipe@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (2, 'Jean', 'jean@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (3, 'Petillo', 'petillo@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (4, 'Giovanna', 'giovanna@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (5, 'Vinicius', 'vinicius@gmail.com', 1);

INSERT INTO activities (name, subject, max_note) VALUES ('Atividade1', 'Português', 10);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade2', 'Matemática', 11);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade3', 'Inglês', 4.5);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade4', 'Artes', 12);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade5', 'Espanhol', 10);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade6', 'Português', 10);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade7', 'Matemática', 11);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade8', 'Inglês', 4.5);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade9', 'Artes', 12);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade10', 'Espanhol', 10);

INSERT INTO activities_students (students_id, activities_id, delivered) VALUES (1, 1, 0);
INSERT INTO activities_students (students_id, activities_id, delivered) VALUES (1, 2, 1);
INSERT INTO activities_students (students_id, activities_id, delivered) VALUES (2, 3, 1);
INSERT INTO activities_students (students_id, activities_id, delivered) VALUES (3, 4, 0);
INSERT INTO activities_students (students_id, activities_id, delivered) VALUES (4, 5, 0);

COMMIT;