USE Sustav_za_rezervaciju_cuvara_ljubimaca;

-- SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/vrsta.csv'
INTO TABLE vrsta
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(naziv, opis, ishrana);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/pasmina.csv'
INTO TABLE pasmina
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(naziv,vrsta_id,opis,porijeklo,tezina,zivotni_vijek,posebne_potrebe);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/ljubimac.csv'
INTO TABLE ljubimac
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ime,pasmina_id,dob,detalji,spol,boja,tezina,zdravstveni_problemi,veterinarski_podaci,posebne_potrebe,socijalnost,akitvnosti);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/korisnik.csv'
INTO TABLE korisnik
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ime,prezime,broj_telefona,email,datum_rodenja,adresa,grad,drzava,spol,potvrdeno);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/korisnik_ljubimac.csv'
INTO TABLE korisnik_ljubimac
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(korisnik_id,ljubimac_id);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/znacajka.csv'
INTO TABLE znacajka
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(naziv,opis,dostupnost,cijena_dodatka,vrijeme_otvaranja,vrijeme_zatvaranja);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/tip.csv'
INTO TABLE tip
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(naziv,opis);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/vlasnik.csv'
INTO TABLE vlasnik
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ime,prezime,broj_telefona,email,datum_rodenja,adresa,grad,drzava,spol,potvrdeno);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/regija.csv'
INTO TABLE regija
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(naziv,opis,povrsina);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/aktivnost.csv'
INTO TABLE aktivnost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(naziv,opis,trajanje,intenzitet,potrebni_resursi);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/cuvar.csv'
INTO TABLE cuvar
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(ime,prezime,broj_telefona,email,datum_rodenja,adresa,grad,drzava,spol,potvrdeno);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/data/cuvar_aktivnost.csv'
INTO TABLE cuvar_aktivnost
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(cuvar_id, aktivnost_id);
