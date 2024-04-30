DROP DATABASE IF EXISTS Sustav_za_rezervaciju_cuvara_ljubimaca;
CREATE DATABASE Sustav_za_rezervaciju_cuvara_ljubimaca;
USE Sustav_za_rezervaciju_cuvara_ljubimaca;

CREATE TABLE vrsta (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(30) NOT NULL,
    opis TEXT NOT NULL,
    ishrana ENUM('mesožder', 'biljožder', 'svežder') NOT NULL,
    slika BLOB,
    
    CONSTRAINT PRIMARY KEY (id)
);

CREATE TABLE pasmina (
	id INT AUTO_INCREMENT,
    naziv VARCHAR(256) NOT NULL,
    vrsta_id INT,
    opis TEXT,
    porijeklo TEXT,
	tezina FLOAT(2) NOT NULL,
	zivotni_vijek TINYINT UNSIGNED NOT NULL,
    posebne_potrebe TEXT,
    slika BLOB,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (vrsta_id) REFERENCES vrsta (id) ON DELETE SET NULL
);

CREATE TABLE ljubimac (
	id INT AUTO_INCREMENT,
    ime VARCHAR(30),
    pasmina_id INT,
    dob TINYINT UNSIGNED,
    detalji TEXT,
    spol ENUM('M', 'Ž'),
    boja varchar(20),
    tezina FLOAT(2),
    zdravstveni_problemi TEXT,
    veterinarski_podaci TEXT,
    posebne_potrebe TEXT,
    socijalnost TEXT,
    akitvnosti TEXT,
    fotografija BLOB,
    
    CONSTRAINT PRIMARY KEY (id),
    CONSTRAINT FOREIGN KEY (pasmina_id) REFERENCES pasmina (id) ON DELETE SET NULL
);

CREATE TABLE korisnik (
	id INT AUTO_INCREMENT,
    ime varchar(30),
    prezime varchar(30),
	broj_telefona VARCHAR(12),
    email VARCHAR(30),
    datum_rodenja DATE,
    adresa VARCHAR(30),
    grad VARCHAR(20),
    drzava VARCHAR(56),
    spol ENUM('M', 'Ž'),
    potvrdeno BOOL,
    profilna_slika BLOB,
    
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
