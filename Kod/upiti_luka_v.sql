USE Sustav_za_rezervaciju_cuvara_ljubimaca;

-- Grupa tablica: ustanova_znacajka, tip, znacajka, vlasnik, ustanova
-- Upiti:
-- 1. Upit: Prikaži sve značajke određene ustanove

SELECT z.naziv, z.opis
	FROM ustanova_znacajka uz
	JOIN znacajka z ON uz.znacajka_id = z.id
	WHERE uz.ustanova_id = 1;
    
-- 2. Upit: Prikaži sve ustanove i njihovog vlasnika 

SELECT u.naziv AS ustanova, v.ime AS vlasnik_ime, v.prezime AS vlasnik_prezime
	FROM ustanova u
	JOIN vlasnik v ON u.vlasnik_id = v.id;
    
-- 3. Upit: Pronađi tipove ustanova sa određenom znčajkom

SELECT u.naziv AS ustanova, t.naziv AS tip
	FROM ustanova u
	JOIN ustanova_znacajka uz ON u.id = uz.ustanova_id
	JOIN znacajka z ON uz.znacajka_id = z.id
	JOIN tip t ON u.tip_id = t.id
	WHERE z.naziv = 'Veliko dvorište'; 
    
-- 4. Upit: Pronađi sve ustanove koje imaju značajku koja je dostupna između 12:00:00 i 19:00:00

SELECT u.naziv AS ustanova, z.naziv AS znacajka
	FROM ustanova u
	JOIN ustanova_znacajka uz ON u.id = uz.ustanova_id
	JOIN znacajka z ON uz.znacajka_id = z.id
	WHERE z.id IN (
		SELECT z1.id
			FROM znacajka z1
			WHERE z1.vrijeme_otvaranja <= '12:00:00' AND z1.vrijeme_zatvaranja >= '19:00:00'
	);

-- Pogledi:
-- 1. Pogled: Pogled prikazuje sve relevantne podatke o ustanovi s značajkom 'Igralište'

CREATE VIEW ustanova_tip_vlasnik_s_igralištem AS
	SELECT u.naziv AS ustanova_naziv, t.naziv AS tip_naziv, v.ime AS vlasnik_ime, v.prezime AS vlasnik_prezime, z.naziv AS znacajka_naziv
		FROM ustanova u
		JOIN tip t ON u.tip_id = t.id
		JOIN vlasnik v ON u.vlasnik_id = v.id
		JOIN ustanova_znacajka uz ON u.id = uz.ustanova_id
		JOIN znacajka z ON uz.znacajka_id = z.id
		WHERE z.naziv = 'Igralište'
		GROUP BY u.id, u.naziv, t.naziv, v.ime, v.prezime, z.naziv;
        
SELECT * FROM ustanova_tip_vlasnik_s_igralištem;

-- 2. Pogled: Pogled prikazuje sve vlasnike koji imaju ustanova tipa 'Pet Spa' i koliko takvih ustanova imaju

CREATE VIEW broj_ustanova_tipa_pet_spa_odredenog_vlasnika AS
	SELECT v.ime, v.prezime, (
		SELECT COUNT(*)
			FROM ustanova u
			WHERE u.vlasnik_id = v.id AND u.tip_id IN (
				SELECT t.id
					FROM tip t
					WHERE t.naziv = 'Pet Spa'
			)
	) AS broj_ustanova
		FROM vlasnik v
		WHERE v.id IN (
			SELECT u.vlasnik_id
				FROM ustanova u
				JOIN tip t ON u.tip_id = t.id
				WHERE t.naziv = 'Pet Spa'
		);

SELECT * FROM broj_ustanova_tipa_pet_spa_odredenog_vlasnika;

-- 3. Pogled: Pogled prikazuje detaljan prikaz svih podataka o ustanovama.

CREATE VIEW ustanova_detalji AS
	SELECT 
		u.id AS ustanova_id,
		u.naziv AS ustanova_naziv,
		u.adresa AS ustanova_adresa,
		u.broj_telefona AS ustanova_broj_telefona,
		u.email AS ustanova_email,
		u.radno_vrijeme AS ustanova_radno_vrijeme,
		u.opis as ustanova_opis,
		u.web_stranica AS ustanova_web_stranica,
		u.kapacitet AS ustanova_kapacitet,
		u.ocjena AS ustanova_ocjena,
		t.id AS tip_id,
		t.naziv AS tip_naziv,
		t.opis AS tip_opis,
		v.ime AS vlasnik_ime,
		v.prezime AS vlasnik_prezime,
		v.broj_telefona AS vlasnik_broj_telefona,
		v.email AS vlasnik_email,
		v.datum_rodenja AS vlasnik_datum_rodenja,
		v.adresa AS vlasnik_adresa,
		v.grad AS vlasnik_grad,
		v.drzava AS vlasnik_drzava,
		v.spol AS vlasnik_spol,
		GROUP_CONCAT(z.naziv ORDER BY z.naziv ASC SEPARATOR ', ') AS znacajke,
		(SELECT COUNT(*) FROM ustanova_znacajka uz WHERE uz.ustanova_id = u.id) AS broj_znacajki,
		(SELECT GROUP_CONCAT(CONCAT(z1.naziv, ' (', z1.dostupnost, ')') ORDER BY z1.naziv ASC SEPARATOR ', ')
		FROM znacajka z1 
		JOIN ustanova_znacajka uz1 ON z1.id = uz1.znacajka_id 
		WHERE uz1.ustanova_id = u.id) AS znacajke_detalji
		FROM ustanova u
		JOIN tip t ON u.tip_id = t.id
		JOIN vlasnik v ON u.vlasnik_id = v.id
		JOIN ustanova_znacajka uz ON u.id = uz.ustanova_id
		JOIN znacajka z ON uz.znacajka_id = z.id
		GROUP BY u.id, t.id, v.id;

SELECT * FROM ustanova_detalji;

-- 4. Pogled: Pogled prikazuje sve vlasnike koji žive u Zagrebu i njihove ustanove

CREATE VIEW vlasnici_iz_zagreba_i_njihove_ustanove AS
	SELECT v.ime, v.prezime, v.grad, GROUP_CONCAT(u.naziv ORDER BY u.naziv ASC SEPARATOR ', ') AS ustanove
		FROM ustanova u
		JOIN vlasnik v ON u.vlasnik_id = v.id
		WHERE v.grad = 'Zagreb'
		GROUP BY v.id 
		ORDER BY v.prezime, v.ime;

SELECT * FROM vlasnici_iz_zagreba_i_njihove_ustanove;