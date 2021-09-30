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
DROP TABLE IF EXISTS questions CASCADE;
DROP TABLE IF EXISTS questions_student CASCADE;

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
  `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `content` TEXT NOT NULL,
  `type` VARCHAR(100) NOT NULL
) ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`school_subjects`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`school_subjects` (
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(200) NULL
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hibredu_db`.`classrooms`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`classrooms` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
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
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(150) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hibredu_db`.`teachers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`teachers` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(255) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `schools_id` BIGINT NOT NULL,
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
  `id` BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `school_subjects_id` BIGINT NOT NULL,
  `classrooms_id` BIGINT NOT NULL,
  `teachers_id` BIGINT NOT NULL,
  `schools_id` BIGINT NULL,
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
  `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(255) NOT NULL,
  `subject` VARCHAR(255) NULL,
  `description` LONGTEXT NULL DEFAULT NULL,
  `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `max_note` DOUBLE NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT NULL,
  `files_id` INT NULL,
  `owner_id` BIGINT NOT NULL,
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
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `classrooms_id` BIGINT NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
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
  `students_id` BIGINT NOT NULL,
  `activities_id` BIGINT NOT NULL,
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
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `value` TEXT NOT NULL,
  `level` VARCHAR(50) NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NULL DEFAULT NULL,
  `teachers_id` BIGINT NOT NULL,
  `students_id` BIGINT NOT NULL,
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
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` VARCHAR(255) NULL DEFAULT NULL,
  `class_subject` VARCHAR(255) NULL DEFAULT NULL,
  `created_at` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `files_id` INT NOT NULL,
  `owner_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_attendance_files1_idx` (`files_id` ASC) ,
  INDEX `fk_attendances_subjects_classrooms1_idx` (`owner_id` ASC) ,
  CONSTRAINT `fk_attendance_files1`
    FOREIGN KEY (`files_id`)
    REFERENCES `hibredu_db`.`files` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_attendances_subjects_classrooms1`
    FOREIGN KEY (`owner_id`)
    REFERENCES `hibredu_db`.`subjects_classrooms` (`id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `hibredu_db`.`attendances_students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`attendances_students` ( 
  `attendances_id` BIGINT NOT NULL,
  `students_id` BIGINT NOT NULL,
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
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `point` DECIMAL NULL,
  `date` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `teachers_id` BIGINT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_hibredu_rewards_teachers1_idx` (`teachers_id` ASC) ,
  CONSTRAINT `fk_hibredu_rewards_teachers1`
    FOREIGN KEY (`teachers_id`)
    REFERENCES `hibredu_db`.`teachers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `hibredu_db`.`questions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`questions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `activities_id` BIGINT NOT NULL,
  `description` TEXT NULL,
  `total_points` INT NULL DEFAULT 10,
  INDEX `fk_questions_activities1_idx` (`activities_id` ASC),
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_questions_activities1`
    FOREIGN KEY (`activities_id`)
    REFERENCES `hibredu_db`.`activities` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `hibredu_db`.`questions_student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `hibredu_db`.`questions_student` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `points` INT NULL DEFAULT 0,
  `response` TEXT NULL,
  `activities_students_id` DOUBLE NOT NULL,
  `questions_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_questions_student_activities_students1_idx` (`activities_students_id` ASC),
  INDEX `fk_questions_student_questions1_idx` (`questions_id` ASC),
  CONSTRAINT `fk_questions_student_activities_students1`
    FOREIGN KEY (`activities_students_id`)
    REFERENCES `hibredu_db`.`activities_students` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_questions_student_questions1`
    FOREIGN KEY (`questions_id`)
    REFERENCES `hibredu_db`.`questions` (`id`)
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
INSERT INTO school_subjects (name) values('Física');
INSERT INTO school_subjects (name) values('Português');
INSERT INTO school_subjects (name) values('História');
INSERT INTO school_subjects (name) values('Música');
INSERT INTO school_subjects (name) values('Química');
INSERT INTO school_subjects (name) values('Geografia');
INSERT INTO school_subjects (name) values('Filosofia');
INSERT INTO school_subjects (name) values('Sociologia');

INSERT INTO teachers (id, name, email, password, phone, schools_id) VALUES (2, 'Paulo Freire', 'teste@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195581190', 1);
INSERT INTO teachers (id, name, email, password, phone, schools_id) VALUES (3, 'Jean Jacques', 'jean@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195581192', 1);
INSERT INTO teachers (id, name, email, password, phone, schools_id) VALUES (4, 'Vinicius Mota', 'vinicius@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195581193', 2);
INSERT INTO teachers (id, name, email, password, phone, schools_id) VALUES (5, 'Gabriel Petillo', 'gspetillo@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195456783', 2);
INSERT INTO teachers (id, name, email, password, phone, schools_id) VALUES (6, 'Giovanna Godoy', 'giovanna@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195456783', 1);
INSERT INTO teachers (id, name, email, password, phone, schools_id) VALUES (7, 'Patricia', 'patricia@hibredu.com.br', '$2a$08$QmivfICA/QZdeqxlC0Dv6eM.W2oOkXZCpAreFyW6H4TyU3a8.6742', '1195456783', 1);

INSERT INTO classrooms (name) VALUES ('3A-2021');
INSERT INTO classrooms (name) VALUES ('3B-2021');
INSERT INTO classrooms (name) VALUES ('3C-2021');
INSERT INTO classrooms (name) VALUES ('3A-2020');
INSERT INTO classrooms (name) VALUES ('3B-2020');
INSERT INTO classrooms (name) VALUES ('5A-2021');
INSERT INTO classrooms (name) VALUES ('5B-2021');
INSERT INTO classrooms (name) VALUES ('5C-2021');

INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(1, 1, 2, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(2, 2, 2, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(2, 3, 2, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(3, 4, 5, 1);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(4, 5, 3, 2);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(3, 6, 3, 3);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(4, 7, 3, 4);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(5, 5, 4, 2);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(6, 6, 4, 3);
INSERT INTO subjects_classrooms(school_subjects_id, classrooms_id ,teachers_id, schools_id) VALUES(7, 7, 4, 4);

INSERT INTO students (id, name, email, classrooms_id) VALUES (1, 'Karini Justino dos Santos', 'rm64088@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (2, 'Kauã Gusmão dos Santos Moreira', 'rm73651@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (3, 'Diogo Pacheco de Lima', 'rm73590@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (4, 'Leandro Moreira Matos', 'rm73578@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (5, 'Victor Gabriel Brito da Silva', 'rm73585@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (6, 'Leonardo Souza Rodrigues Abel', 'rm73655@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (7, 'Leticia Cardana Lustosa', 'rm73542@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (8, 'Iago Azevedo Lira', 'rm75280@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (9, 'Sofia Monteiro Mendonça', 'rm73512@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (10, 'Layza Vitoria Brito Barbosa', 'rm73530@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (11, 'Pedro Salva  Zanelato', 'rm76060@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (12, 'Vinicius dos Santos Amaral', 'rm75283@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (13, 'Caio Vinicius Paulino dos Santos', 'rm73623@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (14, 'Amanda Mendes dos Santos', 'rm73538@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (15, 'Victor Martins Feliciano', 'rm64100@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (16, 'Matheus Martins Costa', 'rm64123@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (17, 'Geovana Mene de Oliveira Lima', 'rm75275@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (18, 'Leticia Silva da Rocha', 'rm73526@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (19, 'Pedro Henrique Souza Silva', 'rm73633@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (20, 'Ester Tiago Rocha', 'rm73533@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (21, 'Kauan de Souza Almeida', 'rm61730@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (22, 'Felipe Zuco Ferreira Gonçalves', 'rm73568@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (23, 'Sergio Francisco Dias Vieira', 'rm73605@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (24, 'Uedson Claudino de Jesus Junior', 'rm64099@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (25, 'Lucca Matos Macedo', 'rm74390@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (26, 'Ester Alessandra Rodrigues de Jesus', 'rm73548@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (27, 'Breno Cavalheiro Pimentel', 'rm73617@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (28, 'Gabriela Moreira Ferreira', 'rm73518@hibredu.school.com.br', 1);
INSERT INTO students (id, name, email, classrooms_id) VALUES (29, 'Melissa do Carmo Alves', 'rm73522@hibredu.school.com.br', 1);

INSERT INTO students (id, name, email, classrooms_id) VALUES (30, 'Augustos Trindade', 'rm98088@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (31, 'Bruno Alves', 'rm98651@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (32, 'Carlos Souza', 'rm98590@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (33, 'Daniela Silva', 'rm98578@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (34, 'Eduardo Petillo', 'rm98585@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (35, 'Fernando Barros', 'rm98655@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (36, 'Gabriel Oliveira', 'rm98542@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (37, 'Henrique Souza', 'rm98280@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (38, 'Igor Oliveira', 'rm98512@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (39, 'João Pedro', 'rm98530@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (40, 'Lucas Alves', 'rm98060@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (41, 'Mateus Souza', 'rm98283@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (42, 'Pedro Souza', 'rm98623@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (43, 'Rafael Alves', 'rm98538@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (44, 'Ricardo da Silva Sauro', 'rm98100@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (45, 'Ricardo da Conceição', 'rm98123@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (46, 'Lucas Silva da Conceição', 'rm98275@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (47, 'Iara Gabriela da Silva Godoy', 'rm98526@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (48, 'Iara Gabriela da Silva Godoy', 'rm98633@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (59, 'Diana Palhau Nascimento Barros', 'rm98533@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (60, 'Daiane Lopes', 'rm98730@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (61, 'Denize Ribeiro', 'rm98568@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (62, 'Claudia Oliveira', 'rm98605@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (63, 'Davi Silva', 'rm98099@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (64, 'Davi Barros', 'rm98390@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (65, 'Davi Souza', 'rm98548@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (66, 'Daleyne Souza', 'rm98617@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (67, 'Dalila Souza', 'rm98518@hibredu.school.com.br', 2);
INSERT INTO students (id, name, email, classrooms_id) VALUES (68, 'Danilo de Oliveira', 'rm98522@hibredu.school.com.br', 2);

INSERT INTO students (id, name, email, classrooms_id) VALUES (69, 'Ricardo e Souza', 'rm101020@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (70, 'Iara de Oliveira', 'rm101030@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (71, 'Eduardo Barros', 'rm101040@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (72, 'Davi Castro', 'rm101050@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (73, 'Bruna Souza', 'rm101060@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (74, 'Bruno Gonçalves', 'rm101070@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (75, 'Thiago de Gonçalves', 'rm101080@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (76, 'Guilherme de Gonçalves', 'rm101090@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (77, 'João de Gonçalves', 'rm101010@hibredu.school.com.br', 3);
INSERT INTO students (id, name, email, classrooms_id) VALUES (78, 'João de Souza', 'rm101011@hibredu.school.com.br', 3);

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
INSERT INTO files (content, type) VALUES ('https://www.youtube12.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube13.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube14.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube15.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube16.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube17.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube18.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube19.com/','image');
INSERT INTO files (content, type) VALUES ('https://www.youtube20.com/','image');

INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (1, 'Atividade 1', 'Português', 10, 2, 1,'2021-09-01 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (2, 'Avaliação Trimestral', 'Matemática', 10, 1, 2,'2021-09-02 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (3, 'Avaliação Trimestral', 'Inglês', 10, 1, 3,'2021-09-03 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (4, 'Avaliação de Reforço', 'Artes', 10, 2, 4,'2021-09-04 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (5, 'Avaliação de Reforço', 'Espanhol', 10, 2, 4,'2021-09-05 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (6, 'Avaliação de Reforço', 'Português', 10, 2, 4,'2021-09-06 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (7, 'Avaliação Trimestral', 'Matemática', 10, 2, 5,'2021-09-07 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (8, 'Avaliação Trimestral', 'Inglês', 10, 1, 1,'2021-09-08 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (9, 'Avaliação Trimestral', 'Artes', 10, 1, 1,'2021-09-09 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (10, 'Atividade complementar', 'Espanhol', 10, 1, 1,'2021-09-10 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (11, 'Avaliação Trimestral', 'Inglês', 10, 2, 1,'2021-09-11 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (12, 'Avaliação complementar', 'Inglês', 10, 2, 1,'2021-09-12 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (13, 'Avaliação complementar', 'Inglês', 10, 2, 1,'2021-09-12 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (14, 'Avaliação complementar', 'Matemática', 10, 1, 1,'2021-09-12 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (15, 'Avaliação Trimestral', 'Matemática', 10, 1, 6,'2021-09-12 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (16, 'Atividade 16', 'Português', 10, 1, 1,'2021-09-13 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (17, 'Avaliação Trimestral', 'Português', 10, 1, 4,'2021-09-14 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (18, 'Avaliação Trimestral', 'Português', 10, 1, 3,'2021-09-14 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (19, 'Atividade 1', 'Português', 10, 2, 1,'2021-09-01 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (20, 'Avaliação Trimestral', 'Matemática', 10, 2, 3,'2021-09-02 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (21, 'Avaliação Trimestral', 'Inglês', 10, 2, 1,'2021-09-03 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (22, 'Avaliação de Reforço', 'Artes', 10, 2, 1,'2021-09-04 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (23, 'Avaliação de Reforço', 'Espanhol', 10, 2, 8,'2021-09-05 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (24, 'Avaliação de Reforço', 'Português', 10, 2, 9,'2021-09-06 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (25, 'Avaliação Trimestral', 'Matemática', 10, 2, 10,'2021-09-07 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (26, 'Avaliação Trimestral', 'Inglês', 10, 2, 11,'2021-09-08 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (27, 'Avaliação Trimestral', 'Artes', 10, 2, 10,'2021-09-09 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (28, 'Atividade complementar', 'Espanhol', 10, 2, 6,'2021-09-10 01:00:00');
INSERT INTO activities (id, name, subject, max_note, owner_id, files_id, created_at) VALUES (29, 'Avaliação Trimestral', 'Inglês', 10, 2, 7,'2021-09-11 01:00:00');

INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 1, 0, 'não entregue', 0, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 2, 1, 'entregue', 10, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 3, 1, 'entregue', 5, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 4, 0, 'não entregue', 0, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 5, 0, 'não entregue', 0, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 6, 0, 'não entregue', 0, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (1, 7, 0, 'não entregue', 0, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 1, 1, 'entregue', 9, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 2, 1, 'entregue', 8, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 4, 1, 'entregue', 4, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 5, 1, 'entregue', 10, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 6, 1, 'entregue', 10, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 7, 1, 'entregue', 10, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 8, 1, 'entregue', 10, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 9, 1, 'entregue', 10, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 10, 1, 'entregue', 10, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 11, 1, 'entregue', 10, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (2, 12, 1, 'entregue', 10, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 1, 1, 'entregue', 10, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 1, 0, 'não entregue', 0, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 2, 0, 'não entregue', 0, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 3, 1, 'entregue', 1, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 4, 0, 'não entregue', 0, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 6, 1, 'entregue', 1, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 7, 1, 'entregue', 1, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 8, 1, 'entregue', 1, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 9, 1, 'entregue', 1, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 10, 1, 'entregue', 1, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 11, 1, 'entregue', 4, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (3, 12, 1, 'entregue', 1, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 1, 0, 'não entregue', 0, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 2, 1, 'entregue', 10, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 3, 1, 'entregue', 7, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 5, 1, 'entregue', 8, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 6, 1, 'entregue', 9, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 7, 1, 'entregue', 1, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 8, 1, 'entregue', 10, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 9, 1, 'entregue', 10, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 10, 1, 'entregue', 4, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 11, 1, 'entregue', 4, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (4, 12, 1, 'entregue', 4, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 1, 1, 'entregue', 5, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 2, 1, 'entregue', 4, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 3, 1, 'entregue', 5, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 4, 1, 'entregue', 6, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 5, 0, 'não entregue', 0, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 6, 1, 'entregue', 6, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 7, 1, 'entregue', 7, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 8, 1, 'entregue', 8, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 9, 1, 'entregue', 9, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (5, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (6, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (7, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (8, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (9, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');

INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (30, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (31, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (32, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (33, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (35, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (34, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');

INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (69, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (71, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (70, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 1, 1, 'entregue', 7, '2021-09-01 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 2, 1, 'entregue', 8, '2021-09-02 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 3, 1, 'entregue', 9, '2021-09-03 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 4, 1, 'entregue', 10, '2021-09-04 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 5, 1, 'entregue', 1, '2021-09-05 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 6, 1, 'entregue', 2, '2021-09-06 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 7, 1, 'entregue', 3, '2021-09-07 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 8, 1, 'entregue', 4, '2021-09-08 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 9, 1, 'entregue', 5, '2021-09-09 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 10, 1, 'entregue', 6, '2021-09-10 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 11, 1, 'entregue', 6, '2021-09-11 01:00:00');
INSERT INTO activities_students (students_id, activities_id, delivered, status, grade, created_at) VALUES (72, 12, 1, 'entregue', 6, '2021-09-12 01:00:00');

INSERT INTO questions (activities_id, description) VALUES (1, 'Qual o nome do seu primeiro animal de estimação?');
INSERT INTO questions (activities_id, description) VALUES (1, 'Quais seus filmes favoritos?');
INSERT INTO questions (activities_id, description) VALUES (1, 'Quantas moléculas tem um ácido?');
INSERT INTO questions (activities_id, description) VALUES (1, 'Há muitas receitinhas caseiras para limpeza na internet misturando vinagre com bicarbonato de sódio. Dentre os reagentes e produtos envolvidos nessa reação de neutralização do vinagre com bicarbonato de sódio, qual é o nome do reagente?');
INSERT INTO questions (activities_id, description) VALUES (1, 'Dentre as reações abordadas no estudo das funções orgânicas, aquela que está diretamente relacionada à produção de essências artificiais que são os chamados aromas, utilizados pela indústria alimentícia, é a:');
INSERT INTO questions (activities_id, description) VALUES (1, 'Qual o nome do filme mais famoso do cinema?');
INSERT INTO questions (activities_id, description) VALUES (1, 'Quantos elementos químicos existem na tabela periódica?');

INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, 'Cachorro', 1, 1);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, 'batman, superman, homem de ferro', 1, 2);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, '2', 1, 3);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, 'Sódio', 1, 4);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, 'Bicarbonato de sódio', 1, 5);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, 'Neutralização', 1, 6);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (1, 'Batman', 1, 7);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, 'Cachorro', 1, 1);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, 'batman, superman, homem de ferro', 1, 2);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, '2', 1, 3);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, 'Sódio', 1, 4);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, 'Bicarbonato de sódio', 1, 5);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, 'Neutralização', 1, 6);
INSERT INTO questions_student (points, response, activities_students_id, questions_id) VALUES (2, 'Batman', 1, 7);

INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 1', '2021-09-01 01:53:36', 1, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 2', '2021-09-02 01:53:36', 2, 2);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 3', '2021-09-03 01:53:36', 3, 3);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 4', '2021-09-04 01:53:36', 4, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 5', '2021-09-05 01:53:36', 5, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 6', '2021-09-06 01:53:36', 6, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 7', '2021-09-07 01:53:36', 7, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 8', '2021-09-08 01:53:36', 8, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 9', '2021-09-09 01:53:36', 9, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 10', '2021-09-10 01:53:36', 10, 1);
INSERT INTO attendances (description, created_at, files_id, owner_id) VALUES ('Chamada registrada 11', '2021-09-11 01:53:36', 11, 1);

INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 0, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 0, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (1, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 0, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (2, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 0, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (3, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (4, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 0, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (5, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 0, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (6, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 0, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (7, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (8, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (9, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (10, 1, 12);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 1);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 2);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 0, 3);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 4);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 5);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 6);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 7);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 8);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 9);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 10);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 11);
INSERT INTO attendances_students (attendances_id, present, students_id) VALUES (11, 1, 12);

INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa', 'red', '2021-09-06 01:53:36', 2, 1);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('não entregou atividade', 'red', '2021-09-08 01:53:36', 2, 1);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('não entregou atividade', 'yellow', '2021-09-09 01:53:36', 2, 1);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa', 'yellow', '2021-09-07 01:53:36', 2, 2);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa e falta em excesso', 'red', '2021-09-07 01:53:36', 2, 3);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa', 'yellow', '2021-09-07 01:53:36', 2, 5);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa há tempos', 'red', '2021-09-07 01:53:36', 2, 4);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa e falta em excesso', 'red', '2021-09-07 01:53:36', 3, 2);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com ótimo desempenho', 'green', '2021-09-07 01:53:36', 4, 2);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com ótimo desempenho', 'green', '2021-09-07 01:53:36', 2, 2);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa', 'yellow', '2021-09-07 01:53:36', 6, 2);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa e falta em excesso', 'yellow', '2021-09-07 01:53:36', 3, 1);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa', 'yellow', '2021-09-07 01:53:36', 2, 1);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com nota baixa e falta em excesso', 'red', '2021-09-07 01:53:36', 2, 1);
INSERT INTO alerts (value, level, created_at, teachers_id, students_id) VALUES ('está com ótimo desempenho', 'green', '2021-09-07 01:53:36', 2, 1);

INSERT INTO hibredu_rewards (point, teachers_id) VALUES (450, 2);
INSERT INTO hibredu_rewards (point, teachers_id) VALUES (540, 3);
INSERT INTO hibredu_rewards (point, teachers_id) VALUES (600, 4);

COMMIT;







