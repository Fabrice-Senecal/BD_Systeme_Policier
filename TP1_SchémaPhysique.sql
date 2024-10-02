-- Auteurs: Fabrice Senécal et Paul Labelle-Bilodeau

CREATE OR REPLACE DATABASE evenements_database CHARACTER SET = "utf8" COLLATE = "utf8_bin";

USE evenements_database;

CREATE OR REPLACE TABLE code_nature (  
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    lettre CHAR NOT NULL UNIQUE KEY ,
    code INT UNSIGNED NOT NULL UNIQUE KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE policier (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    matricule INT NOT NULL UNIQUE KEY,
    poste_de_police VARCHAR(100) NOT NULL UNIQUE KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    grade VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE lieu (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    latitude DECIMAL(9, 6) NOT NULL UNIQUE KEY,
    longitude DECIMAL(9, 6) NOT NULL UNIQUE KEY,
    type ENUM('borne', 'adresse', 'intersection'),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    CONSTRAINT type_valide CHECK (type IN ('borne', 'adresse', 'intersection'))
);

CREATE TABLE ville (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE KEY,
    nom_abr VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE secteur (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE KEY,
    secteur_abr VARCHAR(100) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE type_route_municipale (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(100) NOT NULL UNIQUE KEY,
    type_abr VARCHAR(10) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE OR REPLACE TABLE route_municipale (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE KEY,
    article VARCHAR(10) NOT NULL ,
    secteur VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_secteur_nom
        FOREIGN KEY (secteur)
        REFERENCES secteur(nom)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    ville VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_ville_nom
        FOREIGN KEY (ville)
        REFERENCES ville(nom)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_type_route_municipale_type
        FOREIGN KEY (type)
        REFERENCES type_route_municipale(type)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE autoroute (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    nom VARCHAR(100) NOT NULL UNIQUE KEY,
    article VARCHAR(10), -- Selon le contexte une autoroute n'a pas nécessairement d'article
    secteur VARCHAR(100) NOT NULL,
    CONSTRAINT fk_autoroute_secteur_nom
        FOREIGN KEY (secteur)
        REFERENCES secteur(nom)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    no_2_chiffres SMALLINT UNSIGNED NOT NULL UNIQUE KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE intersection (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    type VARCHAR(100) NOT NULL,
    latitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_intersection_lieu_latitude
        FOREIGN KEY (latitude)
        REFERENCES lieu(latitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    longitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_intersection_lieu_longitude
        FOREIGN KEY (longitude)
        REFERENCES lieu(longitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE OR REPLACE TABLE route_municipale_intersection (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    id_intersection INT UNSIGNED NOT NULL,
    CONSTRAINT fk_route_municipale_intersection_intersection_id
        FOREIGN KEY (id_intersection)
        REFERENCES intersection(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    nom VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_intersection_route_municipale_nom
        FOREIGN KEY (nom)
        REFERENCES route_municipale(nom)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    secteur VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_intersection_route_municipale_secteur
        FOREIGN KEY (secteur)
        REFERENCES route_municipale(secteur)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    ville VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_intersection_route_municipale_ville
        FOREIGN KEY (ville)
        REFERENCES route_municipale(ville)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    type_route VARCHAR(100) NOT NULL,
    CONSTRAINT fk_route_municipale_intersection_route_municipale_type
        FOREIGN KEY (type_route)
        REFERENCES route_municipale(type)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE borne (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    direction VARCHAR(100) NOT NULL UNIQUE KEY,
    no_Borne INT UNSIGNED NOT NULL UNIQUE KEY,
    nom VARCHAR(100) NOT NULL,
    CONSTRAINT fk_borne_autoroute_nom
        FOREIGN KEY (nom)
        REFERENCES autoroute(nom)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    secteur VARCHAR(100) NOT NULL,
    CONSTRAINT fk_borne_autoroute_secteur
        FOREIGN KEY (secteur)
        REFERENCES autoroute(secteur)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    no_2_chiffres SMALLINT UNSIGNED NOT NULL,
    CONSTRAINT fk_borne_autoroute_no_2_chiffres
        FOREIGN KEY (no_2_chiffres)
        REFERENCES autoroute(no_2_chiffres)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    latitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_borne_lieu_latitude
        FOREIGN KEY (latitude)
        REFERENCES lieu(latitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    longitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_borne_lieu_longitude
        FOREIGN KEY (longitude)
        REFERENCES lieu(longitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);


CREATE OR REPLACE TABLE adresse (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    code_postal INT UNSIGNED NOT NULL UNIQUE KEY,
    no_civique INT UNSIGNED NOT NULL UNIQUE KEY,
    no_app INT UNSIGNED NOT NULL UNIQUE KEY,
    nom VARCHAR(100) NOT NULL,
    CONSTRAINT fk_adresse_route_municipale_nom
        FOREIGN KEY (nom)
        REFERENCES route_municipale(nom)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    secteur VARCHAR(100) NOT NULL,
    CONSTRAINT fk_adresse_route_municipale_secteur
        FOREIGN KEY (secteur)
        REFERENCES route_municipale(secteur)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    type VARCHAR(100) NOT NULL,
    CONSTRAINT fk_adresse_route_municipale_type
        FOREIGN KEY (type)
        REFERENCES route_municipale(type)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    ville VARCHAR(100) NOT NULL,
    CONSTRAINT fk_adresse_route_municipale_ville
        FOREIGN KEY (ville)
        REFERENCES route_municipale(ville)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    latitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_adresse_lieu_latitude
        FOREIGN KEY (latitude)
        REFERENCES lieu(latitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    longitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_adresse_lieu_longitude
        FOREIGN KEY (longitude)
        REFERENCES lieu(longitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

CREATE TABLE evenement (
    id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
    date DATE NOT NULL,
    description VARCHAR(255) NOT NULL,
    lettre CHAR NOT NULL,
    CONSTRAINT fk_evenement_code_nature_lettre
        FOREIGN KEY (lettre)
        REFERENCES code_nature(lettre)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    code INT UNSIGNED NOT NULL,
    CONSTRAINT fk_evenement_code_nature_code
        FOREIGN KEY (code)
        REFERENCES code_nature(code)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    matricule INT NOT NULL,
    CONSTRAINT fk_evenement_policier_matricule
        FOREIGN KEY (matricule)
        REFERENCES policier(matricule)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    poste_de_police VARCHAR(100) NOT NULL,
    CONSTRAINT fk_evenement_policier_poste_de_police
        FOREIGN KEY (poste_de_police)
        REFERENCES policier(poste_de_police)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    latitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_evenement_lieu_latitude
        FOREIGN KEY (latitude)
        REFERENCES lieu(latitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    longitude DECIMAL(9, 6) NOT NULL,
    CONSTRAINT fk_evenement_lieu_longitude
        FOREIGN KEY (longitude)
        REFERENCES lieu(longitude)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);


