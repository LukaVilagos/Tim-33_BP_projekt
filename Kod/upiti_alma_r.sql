-- Upit 1
-- Ovaj upit će pronaći sve korisnike koji su stariji od 18 godina.
SELECT * 
FROM korisnik 
WHERE DATEDIFF(CURDATE(), datum_rodenja) > (18 * 365);

-- Upit 2
-- Ovaj upit će pronaći sve rezervacije koje su zakazane unutar sljedeća dva tjedna.
SELECT * 
FROM rezervacija 
WHERE datum BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 2 WEEK);

-- Upit 3
-- Ovaj upit ce dohvatiti sve recenzije s ocjenom 3 ili niže
SELECT * 
FROM recenzija 
WHERE ocjena <= 3;

-- Upit 4
-- Računa prosječnu ocjenu recenzija
SELECT SUM(ocjena)/COUNT(ocjena) AS prosjecna_ocjena
FROM recenzija;

-- Pogled 1
-- Ovaj upit će dohvatiti sve potvrđene rezervacije
DROP VIEW IF EXISTS potvrdene_rezervacije;
CREATE VIEW potvrdene_rezervacije AS 
SELECT * 
FROM rezervacija 
WHERE potvrdeno = TRUE;

SELECT * FROM potvrdene_rezervacije;

-- Pogled 2
-- Dohvati mi korisnike s više od jednog ljubimca
DROP VIEW IF EXISTS korisnici_sa_vise_ljubimaca;
CREATE VIEW korisnici_sa_vise_ljubimaca AS
SELECT korisnik.id, korisnik.ime, korisnik.prezime, COUNT(korisnik_ljubimac.ljubimac_id) AS pet_count
FROM korisnik
JOIN korisnik_ljubimac ON korisnik.id = korisnik_ljubimac.korisnik_id
GROUP BY korisnik.id, korisnik.ime, korisnik.prezime
HAVING pet_count > 1;

SELECT * FROM korisnici_sa_vise_ljubimaca;

-- Pogled 3
-- Dohvati mi sve korisnike koji su iz Hrvatske i grada Zagreba
DROP VIEW IF EXISTS korisnici_u_zagrebu;
CREATE VIEW korisnici_u_zagrebu AS
SELECT * 
FROM korisnik 
WHERE drzava = 'Hrvatska' 
AND grad = 'Zagreb';

SELECT * FROM korisnici_u_zagrebu;

-- Pogled 4 
-- Dohvati mi sve korisnike koji imaju barem jednu recenziju
DROP VIEW IF EXISTS korisnici_s_recenzijama;
CREATE VIEW korisnici_s_recenzijama AS
SELECT korisnik.id, korisnik.ime, korisnik.prezime, COUNT(recenzija.id) AS broj_recenzija
FROM korisnik
JOIN recenzija ON korisnik.id = recenzija.korisnik_id
GROUP BY korisnik.id, korisnik.ime, korisnik.prezime
HAVING broj_recenzija > 0;

SELECT * FROM korisnici_s_recenzijama;
