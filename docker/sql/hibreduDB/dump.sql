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

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE activities (
    id DOUBLE NOT NULL,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    description LONGTEXT,
    max_note DOUBLE NOT NULL,
    teachers_id DOUBLE NOT NULL,
    classrooms_id DOUBLE NOT NULL,
    files_id INTEGER NOT NULL
);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE UNIQUE INDEX activities__idx ON activities (files_id ASC);

ALTER TABLE
    activities
ADD
    CONSTRAINT activities_pk PRIMARY KEY (
        id,
        classrooms_id
    );

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE activities_students (
    id DOUBLE NOT NULL,
    delivered DOUBLE NOT NULL,
    status VARCHAR(50),
    grade DOUBLE,
    students_id VARCHAR(30) NOT NULL,
    activities_id DOUBLE NOT NULL,
    activities_classrooms_id DOUBLE NOT NULL
);

ALTER TABLE
    activities_students
ADD
    CONSTRAINT activities_students_pk PRIMARY KEY (id);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE alerts (
    id INTEGER NOT NULL,
    value LONGBLOB NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    students_id VARCHAR(30) NOT NULL,
    teachers_id DOUBLE NOT NULL
);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE attendance (
    id INTEGER NOT NULL,
    `date` DATETIME,
    time VARCHAR(10),
    students_id VARCHAR(30) NOT NULL,
    files_id INTEGER NOT NULL
);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE UNIQUE INDEX attendance__idx ON attendance (files_id ASC);

ALTER TABLE
    attendance
ADD
    CONSTRAINT attendance_pk PRIMARY KEY (id);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE classrooms (
    id DOUBLE NOT NULL,
    name VARCHAR(255),
    created_at DATETIME NOT NULL,
    updated_at DATETIME
);

ALTER TABLE
    classrooms
ADD
    CONSTRAINT classrooms_pk PRIMARY KEY (id);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE files (
    id INTEGER NOT NULL,
    content LONGBLOB NOT NULL,
    type VARCHAR(100) NOT NULL
);

ALTER TABLE
    files
ADD
    CONSTRAINT files_pk PRIMARY KEY (id);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE students (
    id VARCHAR(30) NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME,
    classrooms_id DOUBLE NOT NULL
);

ALTER TABLE
    students
ADD
    CONSTRAINT students_pk PRIMARY KEY (id);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE teachers (
    id DOUBLE NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL,
    updated_at DATETIME
);

ALTER TABLE
    teachers
ADD
    CONSTRAINT teachers_pk PRIMARY KEY (id);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE TABLE teachers_classrooms (
    id DOUBLE NOT NULL,
    created_at DATETIME NOT NULL,
    teachers_id DOUBLE NOT NULL,
    classrooms_id DOUBLE NOT NULL
);

ALTER TABLE
    teachers_classrooms
ADD
    CONSTRAINT teachers_classrooms_pk PRIMARY KEY (id);

ALTER TABLE
    activities
ADD
    CONSTRAINT activities_classrooms_fk FOREIGN KEY (classrooms_id) REFERENCES classrooms (id);

ALTER TABLE
    activities
ADD
    CONSTRAINT activities_files_fk FOREIGN KEY (files_id) REFERENCES files (id);

-- SQLINES DEMO *** ength exceeds maximum allowed length(30) 
ALTER TABLE
    activities_students
ADD
    CONSTRAINT activities_students_activities_fk FOREIGN KEY (
        activities_id,
        activities_classrooms_id
    ) REFERENCES activities (
        id,
        classrooms_id
    );

-- SQLINES DEMO *** ength exceeds maximum allowed length(30) 
ALTER TABLE
    activities_students
ADD
    CONSTRAINT activities_students_students_fk FOREIGN KEY (students_id) REFERENCES students (id);

ALTER TABLE
    activities
ADD
    CONSTRAINT activities_teachers_fk FOREIGN KEY (teachers_id) REFERENCES teachers (id);

ALTER TABLE
    alerts
ADD
    CONSTRAINT alerts_students_fk FOREIGN KEY (students_id) REFERENCES students (id);

ALTER TABLE
    alerts
ADD
    CONSTRAINT alerts_teachers_fk FOREIGN KEY (teachers_id) REFERENCES teachers (id);

ALTER TABLE
    attendance
ADD
    CONSTRAINT attendance_files_fk FOREIGN KEY (files_id) REFERENCES files (id);

ALTER TABLE
    attendance
ADD
    CONSTRAINT attendance_students_fk FOREIGN KEY (students_id) REFERENCES students (id);

ALTER TABLE
    students
ADD
    CONSTRAINT students_classrooms_fk FOREIGN KEY (classrooms_id) REFERENCES classrooms (id);

-- SQLINES DEMO *** ength exceeds maximum allowed length(30) 
ALTER TABLE
    teachers_classrooms
ADD
    CONSTRAINT teachers_classrooms_classrooms_fk FOREIGN KEY (classrooms_id) REFERENCES classrooms (id);

-- SQLINES DEMO *** ength exceeds maximum allowed length(30) 
ALTER TABLE
    teachers_classrooms
ADD
    CONSTRAINT teachers_classrooms_teachers_fk FOREIGN KEY (teachers_id) REFERENCES teachers (id);

/* INSERÇÕES DE TESTES */

INSERT INTO classrooms (name) VALUES ('1o ano');
INSERT INTO classrooms (name) VALUES ('2o ano');
INSERT INTO classrooms (name) VALUES ('3o ano');
INSERT INTO classrooms (name) VALUES ('4o ano');
INSERT INTO classrooms (name) VALUES ('5o ano');

INSERT INTO students (name, email, id_classroom) VALUES ('Felipe', 'felipe@gmail.com', 1);
INSERT INTO students (name, email, id_classroom) VALUES ('Jean', 'jean@gmail.com', 1);
INSERT INTO students (name, email, id_classroom) VALUES ('Petillo', 'petillo@gmail.com', 1);
INSERT INTO students (name, email, id_classroom) VALUES ('Giovanna', 'giovanna@gmail.com', 1);
INSERT INTO students (name, email, id_classroom) VALUES ('Vinicius', 'vinicius@gmail.com', 1);

INSERT INTO activities (name, subject, max_note) VALUES ('Atividade1', 'Português', 10);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade2', 'Matemática', 11);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade3', 'Inglês', 4.5);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade4', 'Artes', 12);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade5', 'Espanhol', 10);

INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (1, 1, 0);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (1, 2, 1);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (2, 3, 1);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (3, 4, 0);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (4, 5, 0);

COMMIT;