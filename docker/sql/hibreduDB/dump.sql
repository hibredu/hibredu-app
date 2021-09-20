SET FOREIGN_KEY_CHECKS = 0;
SET UNIQUE_CHECKS = 0;

DROP TABLE IF EXISTS activities_students CASCADE;
DROP TABLE IF EXISTS teachers_classrooms CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS schools CASCADE;
DROP TABLE IF EXISTS subjects_classrooms CASCADE;
DROP TABLE IF EXISTS school_subjects CASCADE;
DROP TABLE IF EXISTS activities CASCADE;
DROP TABLE IF EXISTS classrooms CASCADE;
DROP TABLE IF EXISTS alerts CASCADE;
DROP TABLE IF EXISTS files CASCADE;
DROP TABLE IF EXISTS hibredu_rewards CASCADE;
DROP TABLE IF EXISTS attendances_students CASCADE;
DROP TABLE IF EXISTS attendances CASCADE;

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
-- Table `hibredu_db`.`files`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`files` (
  `id` INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `content` TEXT NOT NULL,
  `type` VARCHAR(100) NOT NULL
) ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`school_subjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`school_subjects` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NULL
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hibredu_db`.`classrooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`classrooms` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `year` VARCHAR(6) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`schools`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`schools` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
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
  `schools_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_teachers_schools1_idx` (`schools_id` ASC) ,
  CONSTRAINT `fk_teachers_schools1`
    FOREIGN KEY (`schools_id`)
    REFERENCES `hibredu_db`.`schools` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 2
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`subjects_classrooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`subjects_classrooms` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `school_subjects_id` BIGINT(20) NOT NULL,
  `classrooms_id` BIGINT(20) NOT NULL,
  `teachers_id` BIGINT(20) NOT NULL,
  `schools_id` BIGINT(20) NULL,
  INDEX `id_subjects_classrooms_idx` (`id` ASC),
  INDEX `fk_school_subjects_has_classrooms_classrooms1_idx` (`classrooms_id` ASC),
  INDEX `fk_subjects_classrooms_teachers1_idx` (`teachers_id` ASC),
  INDEX `fk_subjects_classrooms_schools1_idx` (`schools_id` ASC),
  CONSTRAINT `fk_school_subjects_has_classrooms_school_subjects1`
    FOREIGN KEY (`school_subjects_id`)
    REFERENCES `hibredu_db`.`school_subjects` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_school_subjects_has_classrooms_classrooms1`
    FOREIGN KEY (`classrooms_id`)
    REFERENCES `hibredu_db`.`classrooms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subjects_classrooms_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_subjects_classrooms_schools1`
    FOREIGN KEY (`schools_id`)
    REFERENCES `hibredu_db`.`schools` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `hibredu_db`.`activities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`activities` (
  `id` BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `subject` VARCHAR(255) NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `max_note` DOUBLE NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT NULL,
  `files_id` INT(11) NULL,
  `owner_id` BIGINT(20) NOT NULL,
  INDEX `activities_files_fk` (`files_id` ASC) ,
  INDEX `fk_activities_subjects_classrooms1_idx` (`owner_id` ASC) ,
  CONSTRAINT `activities_files_fk`
    FOREIGN KEY (`files_id`)
    REFERENCES `hibredu_db`.`files` (`id`),
  CONSTRAINT `fk_activities_subjects_classrooms1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `hibredu_db`.`subjects_classrooms` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`students` (
  `id` BIGINT(20) AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `classrooms_id` BIGINT(20) NULL DEFAULT NULL,
  INDEX `fk_students_classrooms1_idx` (`classrooms_id` ASC) ,
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
  `students_id` BIGINT(20) NOT NULL,
  `activities_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_activities_students_students1_idx` (`students_id` ASC) ,
  INDEX `fk_activities_students_activities1_idx` (`activities_id` ASC) ,
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
  `value` TEXT NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `teachers_id` BIGINT(20) NOT NULL,
  `students_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_alerts_teachers1_idx` (`teachers_id` ASC) ,
  INDEX `fk_alerts_students1_idx` (`students_id` ASC) ,
  CONSTRAINT `fk_alerts_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_alerts_students1`
    FOREIGN KEY (`students_id`)
    REFERENCES `hibredu_db`.`students` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`attendances`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`attendances` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `class_subject` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `classroom_id` BIGINT(20) NOT NULL,
  `files_id` INT(11) NOT NULL,
  `owner_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_attendance_files1_idx` (`files_id` ASC) ,
  INDEX `fk_attendances_subjects_classrooms1_idx` (`owner_id` ASC) ,
  INDEX `fk_attendance_classrooms_idx` (`classroom_id` ASC) ,
  CONSTRAINT `fk_attendance_files1`
    FOREIGN KEY (`files_id`)
    REFERENCES `hibredu_db`.`files` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_attendances_subjects_classrooms1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `hibredu_db`.`subjects_classrooms` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_attendance_classrooms_idx`
    FOREIGN KEY (`classroom_id`)
    REFERENCES `hibredu_db`.`classrooms` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`attendances_students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`attendances_students` ( 
  `attendances_id` BIGINT(20) NOT NULL,
  `students_id` BIGINT(20) NOT NULL,
  `present` TINYINT NOT NULL DEFAULT 0,
  PRIMARY KEY (`attendances_id`, `students_id`),
  INDEX `fk_attendance_has_students_students1_idx` (`students_id` ASC) ,
  INDEX `fk_attendance_has_students_attendance1_idx` (`attendances_id` ASC) ,
  CONSTRAINT `fk_attendance_has_students_attendance1`
    FOREIGN KEY (`attendances_id`)
    REFERENCES `hibredu_db`.`attendances` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_attendance_has_students_students1`
    FOREIGN KEY (`students_id`)
    REFERENCES `hibredu_db`.`students` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`hibredu_rewards`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`hibredu_rewards` (
  `id` BIGINT(20) NOT NULL AUTO_INCREMENT,
  `point` DECIMAL NULL,
  `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `teachers_id` BIGINT(20) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hibredu_rewards_teachers1_idx` (`teachers_id` ASC) ,
  CONSTRAINT `fk_hibredu_rewards_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

/* INSERÇÕES DE TESTES */

INSERT INTO schools (name) values('FIAP');
INSERT INTO schools (name) values('FIAP COPI');
INSERT INTO schools (name) values('ETEC I');
INSERT INTO schools (name) values('ETEC II');

INSERT INTO school_subjects (name) values('Matemática');
INSERT INTO school_subjects (name) values('Português');
INSERT INTO school_subjects (name) values('História');
INSERT INTO school_subjects (name) values('Música');
INSERT INTO school_subjects (name) values('Química');
INSERT INTO school_subjects (name) values('Geografia');

INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Jean Jacques', 'jean@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195581190', 1);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Felipe Toscano', 'felipe@gmail.com', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195581192', 1);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Vinicius Mota', 'vinicius@gmail.com', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195581193', 2);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Gabriel Petillo', 'gspetillo@gmail.com', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195456783', 2);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Giovanna Godoy', 'giovanna@gmail.com', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195456783', 1);
INSERT INTO teachers (name, email, password, phone, schools_id) VALUES ('Patricia', 'patricia@gmail.com', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195456783', 1);

INSERT INTO classrooms (name) VALUES ('3A-2021');
INSERT INTO classrooms (name) VALUES ('3B-2021');
INSERT INTO classrooms (name) VALUES ('3C-2021');
INSERT INTO classrooms (name) VALUES ('3A-2020');
INSERT INTO classrooms (name) VALUES ('3B-2020');
INSERT INTO classrooms (name) VALUES ('5A-2021');
INSERT INTO classrooms (name) VALUES ('5B-2021');

INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(1, 1, 2, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(1, 2, 2, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(2, 2, 3, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(3, 2, 4, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(4, 1, 3, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(4, 2, 3, 1);

INSERT INTO students (id, name, email, classrooms_id) VALUES (1, 'Felipe', 'felipe@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (2, 'Jean', 'jean@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (3, 'Petillo', 'petillo@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (4, 'Giovanna', 'giovanna@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (5, 'Vinicius', 'vinicius@gmail.com', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (6, 'Gustavo', 'gustavo@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (7, 'Guilherme', 'guilherme@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (8, 'Thiago', 'thiago@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (9, 'Isadora', 'isadora@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (10, 'Naruto', 'naruto@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (11, 'Bruna', 'bruna@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (12, 'Luana', 'luana@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (13, 'Evelyn', 'evelyn@gmail.com', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (14, 'Bruno', 'bruno@gmail.com', 2);

INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade1', 'Português', 10, 1);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade2', 'Matemática', 10, 1);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade3', 'Inglês', 10, 1);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade4', 'Artes', 10, 1);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade5', 'Espanhol', 10, 1);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade6', 'Português', 10, 1);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade7', 'Matemática', 10, 2);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade8', 'Inglês', 10, 2);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade9', 'Artes', 10, 2);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade10', 'Espanhol', 10, 2);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade11', 'Inglês', 10, 2);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade12', 'Inglês', 10, 2);
INSERT INTO activities (name, subject, max_note, owner_id) VALUES ('Atividade13', 'Inglês', 10, 1);

INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 1, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 2, 1, 'entregue', 10);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 3, 1, 'entregue', 5);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 4, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 5, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 6, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (1, 7, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (2, 1, 1, 'entregue', 9);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (2, 2, 1, 'entregue', 8);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (2, 3, 1, 'entregue', 9);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (2, 4, 1, 'entregue', 4);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (2, 5, 0, 'entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (3, 1, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (3, 2, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (3, 3, 1, 'entregue', 1);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (3, 4, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (4, 5, 0, 'não entregue', 0);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (5, 3, 1, 'entregue', 10);
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade) VALUES (3, 3, 1, 'entregue', 10);

INSERT INTO files (content, type) VALUES ('https://www.youtube.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube2.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube3.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube4.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube5.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube6.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube7.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube8.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube9.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube10.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube11.com/','image');

INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 1', '2021-09-06 01:53:36', 1, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 2', '2021-09-05 01:53:36', 2, 2, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 3', '2021-09-06 01:53:36', 3, 3, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 4', '2021-09-07 01:53:36', 4, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 5', '2021-09-08 01:53:36', 5, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 6', '2021-09-09 01:53:36', 6, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 7', '2021-09-09 01:53:36', 7, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 8', '2021-09-09 01:53:36', 8, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 9', '2021-09-09 01:53:36', 9, 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id, classroom_id) VALUES ('Teste de Descrição de chamada 10', '2021-09-09 01:53:36', 10, 1, 1);

INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 0, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 0, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 0, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 0, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 0, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 8);

INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa','2021-09-06 01:53:36', 2, 1);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno não entregou atividade','2021-09-08 01:53:36', 2, 1);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno não entregou atividade','2021-09-09 01:53:36', 2, 1);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa','2021-09-07 01:53:36', 2, 2);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa e falta em excesso','2021-09-07 01:53:36', 2, 3);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa','2021-09-07 01:53:36', 2, 5);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa a tempos','2021-09-07 01:53:36', 2, 4);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa e falta em excesso','2021-09-07 01:53:36', 3, 2);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa','2021-09-07 01:53:36', 4, 2);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa e falta em excesso','2021-09-07 01:53:36', 5, 2);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa','2021-09-07 01:53:36', 6, 2);
INSERT INTO alerts (value, created_at, teachers_id, students_id) VALUES ('Aluno com nota baixa e falta em excesso','2021-09-07 01:53:36', 7, 1);

COMMIT;