DROP TABLE IF EXISTS activities_students CASCADE;
DROP TABLE IF EXISTS teachers CASCADE;
DROP TABLE IF EXISTS classroom CASCADE;
DROP TABLE IF EXISTS students CASCADE;
DROP TABLE IF EXISTS activities CASCADE;

CREATE TABLE teachers (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    birthDay DATETIME, -- Acho que não precisamos disso
    phone VARCHAR(255),
    school VARCHAR(255), -- Pode estar em várias escolas?
    email VARCHAR(255) UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL default CURRENT_TIMESTAMP,
    updated_at DATETIME
);

CREATE TABLE classroom (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL default CURRENT_TIMESTAMP,
    updated_at DATETIME
);

CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME
);

CREATE TABLE activities (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL, -- Futuramente pode ser uma fk para a tabela de matérias
    description TEXT,
    max_note DECIMAL(10, 1) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME
);

CREATE TABLE activities_students (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_student INTEGER NOT NULL,
    id_activity INTEGER NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivered INTEGER NOT NULL,
    updated_at DATETIME,
    CONSTRAINT fk_id_student FOREIGN KEY (id_student) REFERENCES students(id),
    CONSTRAINT fk_id_activity FOREIGN KEY (id_activity) REFERENCES activities(id)
);

/* INSERÇÕES DE TESTES */

INSERT INTO students (name, email) VALUES ('Felipe', 'felipe@gmail.com');
INSERT INTO students (name, email) VALUES ('Jean', 'jean@gmail.com');
INSERT INTO students (name, email) VALUES ('Petillo', 'petillo@gmail.com');
INSERT INTO students (name, email) VALUES ('Giovanna', 'giovanna@gmail.com');
INSERT INTO students (name, email) VALUES ('Vinicius', 'vinicius@gmail.com');

INSERT INTO activities (name, subject, max_note) VALUES ('Atividade1', 'Português', 10);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade2', 'Matemática', 11);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade3', 'Inglês', 4.5);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade4', 'Artes', 12);
INSERT INTO activities (name, subject, max_note) VALUES ('Atividade5', 'Espanhol', 10);

INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (1, 1, 0);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (1, 2, 1);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (2, 3, 0);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (3, 4, 0);
INSERT INTO activities_students (id_student, id_activity, delivered) VALUES (4, 5, 0);

COMMIT;


