DROP DATABASE IF EXISTS Sustav_za_rezervaciju_cuvara_ljubimaca;
CREATE DATABASE Sustav_za_rezervaciju_cuvara_ljubimaca;
USE Sustav_za_rezervaciju_cuvara_ljubimaca;

CREATE TABLE vrsta (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(30) NOT NULL,
    opis TEXT NOT NULL,
    ishrana ENUM('mesožder', 'biljožder', 'svežder') NOT NULL,
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE pasmina (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(256) NOT NULL,
    vrsta_id INT,
    opis TEXT NOT NULL,
    porijeklo TEXT NOT NULL,
	tezina FLOAT(2) NOT NULL,
	zivotni_vijek TINYINT UNSIGNED NOT NULL,
    posebne_potrebe TEXT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (vrsta_id) REFERENCES vrsta (id) ON DELETE SET NULL
);

CREATE TABLE ljubimac (
	id INT AUTO_INCREMENT,
    ime VARCHAR(30) NOT NULL,
    pasmina_id INT,
    dob TINYINT UNSIGNED NOT NULL,
    detalji TEXT,
    spol ENUM('M', 'Ž') NOT NULL,
    boja varchar(20),
    tezina FLOAT(2),
    zdravstveni_problemi TEXT,
    veterinarski_podaci TEXT,
    posebne_potrebe TEXT,
    socijalnost TEXT,
    akitvnosti TEXT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (pasmina_id) REFERENCES pasmina (id) ON DELETE SET NULL
);

CREATE TABLE korisnik (
	id INT AUTO_INCREMENT,
    ime varchar(30) NOT NULL,
    prezime varchar(30) NOT NULL,
	broj_telefona VARCHAR(15),
    email VARCHAR(30) NOT NULL,
    datum_rodenja DATE NOT NULL,
    adresa VARCHAR(256),
    grad VARCHAR(20),
    drzava VARCHAR(56),
    spol ENUM('M', 'Ž'),
    potvrdeno BOOL,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE korisnik_ljubimac (
	id INT AUTO_INCREMENT,
    korisnik_id INT,
    ljubimac_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (korisnik_id) REFERENCES korisnik (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (ljubimac_id) REFERENCES ljubimac (id) ON DELETE SET NULL
);

CREATE TABLE znacajka (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(256) NOT NULL,
    opis TEXT,
    dostupnost TEXT,
    cijena_dodatka FLOAT(2),
    vrijeme_otvaranja TIME,
    vrijeme_zatvaranja TIME,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE tip (
	id INT AUTO_INCREMENT,
    naziv varchar(256) NOT NULL,
    opis TEXT,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE vlasnik (
	id INT AUTO_INCREMENT,
    ime VARCHAR(30) NOT NULL,
    prezime VARCHAR(30) NOT NULL,
	broj_telefona VARCHAR(15),
    email VARCHAR(30) NOT NULL,
    datum_rodenja DATE NOT NULL,
    adresa VARCHAR(256),
    grad VARCHAR(20),
    drzava VARCHAR(56),
    spol ENUM('M', 'Ž'),
    potvrdeno BOOL,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE regija (
	id INT AUTO_INCREMENT,
    naziv varchar(64),
    opis TEXT,
    povrsina INT,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE mjesto_interesa (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(256) NOT NULL,
    adresa VARCHAR(256) NOT NULL,
    broj_telefona VARCHAR(15),
    email VARCHAR(30),
    radno_vrijeme TEXT,
    opis TEXT,
    web_stranica VARCHAR(256),
    regija_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (regija_id) REFERENCES regija (id) ON DELETE SET NULL
);

CREATE TABLE ustanova (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(256) NOT NULL,
    adresa VARCHAR(256) NOT NULL,
    broj_telefona VARCHAR(15),
    email VARCHAR(30),
    radno_vrijeme TEXT,
    opis TEXT,
    web_stranica VARCHAR(256),
    kapacitet TEXT,
    ocjena FLOAT(1),
    regija_id INT,
    tip_id INT,
    vlasnik_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (regija_id) REFERENCES regija (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (tip_id) REFERENCES tip (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (vlasnik_id) REFERENCES vlasnik (id) ON DELETE SET NULL
);

CREATE TABLE ustanova_znacajka (
	id INT AUTO_INCREMENT,
    ustanova_id INT,
    znacajka_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (ustanova_id) REFERENCES ustanova (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (znacajka_id) REFERENCES znacajka (id) ON DELETE SET NULL
);

CREATE TABLE aktivnost (
	id INT AUTO_INCREMENT,
    naziv varchar(256) NOT NULL,
    opis TEXT,
    trajanje TIME,
    intenzitet VARCHAR(256),
    potrebni_resursi TEXT,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE cuvar (
	id INT AUTO_INCREMENT,
    ime varchar(30) NOT NULL,
    prezime varchar(30) NOT NULL,
	broj_telefona VARCHAR(15),
    email VARCHAR(30) NOT NULL,
    datum_rodenja DATE NOT NULL,
    adresa VARCHAR(256),
    grad VARCHAR(20),
    drzava VARCHAR(56),
    spol ENUM('M', 'Ž'),
    potvrdeno BOOL,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE cuvar_aktivnost (
	id INT AUTO_INCREMENT,
    cuvar_id INT,
    aktivnost_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (cuvar_id) REFERENCES cuvar (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (aktivnost_id) REFERENCES aktivnost (id) ON DELETE SET NULL
);

CREATE TABLE cuvar_ustanova (
	id INT AUTO_INCREMENT,
    cuvar_id INT,
    ustanova_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (cuvar_id) REFERENCES cuvar (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (ustanova_id) REFERENCES ustanova (id) ON DELETE SET NULL
);

CREATE TABLE usluga (
	id INT AUTO_INCREMENT,
    cuvar_id INT,
    naziv VARCHAR (256),
    opis TEXT,
    cijena FLOAT(2),
    trajanje TEXT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (cuvar_id) REFERENCES cuvar (id) ON DELETE SET NULL
);

CREATE TABLE recenzija (
	id INT AUTO_INCREMENT,
    korisnik_id INT,
    ustanova_id INT,
    cuvar_id INT,
    naslov VARCHAR(256),
    tekst TEXT,
    ocjena TINYINT UNSIGNED,
    datum DATETIME,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (korisnik_id) REFERENCES korisnik (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (ustanova_id) REFERENCES ustanova (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (cuvar_id) REFERENCES cuvar (id) ON DELETE SET NULL
);

CREATE TABLE rezervacija (
	id INT AUTO_INCREMENT,
    korisnik_id INT,
    ustanova_id INT,
    usluga_id INT,
    datum DATETIME,
    napomena TEXT,
    potvrdeno BOOL,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (korisnik_id) REFERENCES korisnik (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (ustanova_id) REFERENCES ustanova (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (usluga_id) REFERENCES usluga (id) ON DELETE SET NULL
);

CREATE TABLE rezervacija_ljubimac (
	id INT AUTO_INCREMENT,
    rezervacija_id INT,
    ljubimac_id INT,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (rezervacija_id) REFERENCES rezervacija (id) ON DELETE SET NULL,
    CONSTRAINT FOREIGN KEY (ljubimac_id) REFERENCES ljubimac (id) ON DELETE SET NULL
);

-- Okidači

-- Okidač 1: Ažurira ocjenu ustanove nakon nove recenzije

DELIMITER //

CREATE TRIGGER azuriraj_ocjenu_nakon_inserta
AFTER INSERT ON recenzija
FOR EACH ROW
BEGIN
    DECLARE new_avg_ocjena DECIMAL(3, 2);

    SELECT AVG(ocjena) INTO new_avg_ocjena
    FROM recenzija
    WHERE ustanova_id = NEW.ustanova_id;

    UPDATE ustanova
    SET ocjena = new_avg_ocjena
    WHERE id = NEW.ustanova_id;
END;
//

DELIMITER ;

-- Okidač 2: Osigurava da odabrana ustanova i usluga su povezane čuvarom

DELIMITER //

CREATE TRIGGER validiraj_usluga_cuvar_prije_inserta
BEFORE INSERT ON rezervacija
FOR EACH ROW
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*)
    INTO v_count
    FROM usluga u
    JOIN cuvar c ON u.cuvar_id = c.id
    JOIN cuvar_ustanova cu ON c.id = cu.cuvar_id
    WHERE u.id = NEW.usluga_id
    AND cu.ustanova_id = NEW.ustanova_id;

    IF v_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Odabrana usluga_id nije asocirana sa danom ustanova_id kroz cuvara';
    END IF;
END;
//

DELIMITER ;
