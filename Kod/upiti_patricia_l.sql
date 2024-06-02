USE Sustav_za_rezervaciju_cuvara_ljubimaca;

-- Grupa tablica: vrsta, pasmina, ljubimac, rezervacija_ljubimac
-- Upiti:
-- 1. Upit: Prikaži najmlađeg ljubimca za svaku pasminu

SELECT 
	p.naziv AS pasmina_naziv, 
    ljubimac.ime AS ljubimac_ime, 
    ljubimac.dob AS ljubimac_dob, 
    ljubimac.boja AS ljubimac_boja, 
    ljubimac.tezina AS ljubimac_tezina
	FROM pasmina p
	JOIN ljubimac ON p.id = ljubimac.pasmina_id
	WHERE ljubimac.dob = (
			SELECT MIN(lj.dob)
				FROM ljubimac lj
				WHERE lj.pasmina_id = p.id
		)
	ORDER BY p.naziv;
    
-- 2. Upit: Prikaži ljubimca sa više od jedne rezervacije

SELECT 
    l.id AS ljubimac_id,
    l.ime AS ljubimac_ime,
    p.naziv AS pasmina_naziv,
    v.naziv AS vrsta_naziv,
    COUNT(rl.rezervacija_id) AS broj_rezervacija
	FROM ljubimac l
	JOIN pasmina p ON l.pasmina_id = p.id
	JOIN vrsta v ON p.vrsta_id = v.id
	JOIN rezervacija_ljubimac rl ON l.id = rl.ljubimac_id
	GROUP BY l.id, p.naziv, v.naziv
	HAVING COUNT(rl.rezervacija_id) > 1
	ORDER BY broj_rezervacija DESC, l.ime ASC;
    
-- 3. Upit: Prikaži najčešću boju ljubimca po vrsti
    
SELECT vrsta.naziv AS vrsta_naziv, ljubimac.boja, COUNT(*) AS broj_ljubimaca
	FROM vrsta
	JOIN pasmina ON vrsta.id = pasmina.vrsta_id
	JOIN ljubimac ON pasmina.id = ljubimac.pasmina_id
	GROUP BY vrsta.id, ljubimac.boja
	HAVING COUNT(*) = (
			SELECT MAX(boja_count)
			FROM (
				SELECT COUNT(*) AS boja_count
					FROM pasmina AS p2
					JOIN ljubimac AS l2 ON p2.id = l2.pasmina_id
					WHERE p2.vrsta_id = vrsta.id
					GROUP BY l2.boja
			) AS broj_boja
		)
	ORDER BY vrsta.naziv;
    
-- 4. Upit: Prikaži najčešću pasminu ljubimca   
    
SELECT p.id AS id_pasmina, p.naziv AS pasmina_naziv, COUNT(*) AS broj_ljubimaca
	FROM ljubimac l
	JOIN pasmina p ON l.pasmina_id = p.id
	GROUP BY p.id, p.naziv
	ORDER BY broj_ljubimaca DESC;

-- Pogledi:
-- 1. Pogled: Detaljan prikaz ljubimca:

DROP VIEW IF EXISTS detaljan_prikaz_ljubimac;
CREATE VIEW detaljan_prikaz_ljubimac AS
	SELECT 
		l.id AS ljubimac_id,
		l.ime AS ljubimac_ime,
		l.dob AS ljubimac_dob,
		l.spol AS ljubimac_spol,
		l.boja AS ljubimac_boja,
		l.tezina AS ljubimac_tezina,
		l.zdravstveni_problemi AS ljubimac_zdravstveni_problemi,
		l.veterinarski_podaci AS ljubimac_veterinarski_podaci,
		l.posebne_potrebe AS ljubimac_posebne_potrebe,
		l.socijalnost AS ljubimac_socijalnost,
		l.akitvnosti AS ljubimac_aktivnosti,
		p.naziv AS pasmina_naziv,
		v.naziv AS vrsta_naziv,
		(
			SELECT COUNT(rl.rezervacija_id)
				FROM rezervacija_ljubimac rl
				WHERE rl.ljubimac_id = l.id
		) AS broj_rezervacija,
		(
			SELECT GROUP_CONCAT(rl.rezervacija_id ORDER BY rl.rezervacija_id ASC SEPARATOR ', ')
				FROM rezervacija_ljubimac rl
				WHERE rl.ljubimac_id = l.id
		) AS id_rezervacija
		FROM ljubimac l
		JOIN pasmina p ON l.pasmina_id = p.id
		JOIN vrsta v ON p.vrsta_id = v.id;

SELECT * FROM detaljan_prikaz_ljubimac;

-- 2. Pogled: vrsta statistika

DROP VIEW IF EXISTS vrsta_statistika;
CREATE VIEW vrsta_statistika AS
	SELECT 
		v.id AS d,
		v.naziv AS naziv,
		AVG(l.dob) AS prosjecna_dob,
		MIN(l.dob) AS minimalna_dob,
		MAX(l.dob) AS maximalna_dob,
		STDDEV(l.dob) AS standardna_devijacaija_dob,
		SUM(l.dob) AS ukupna_dob,
		AVG(l.tezina) AS prosjecna_tezina,
		MIN(l.tezina) AS najmanja_tezina,
		MAX(l.tezina) AS najveca_tezina,
		STDDEV(l.tezina) AS standardna_devijacaija_tezina,
		SUM(l.tezina) AS ukupna_tezina,
		COUNT(l.id) AS broj_ljubimaca
		FROM vrsta v
		JOIN pasmina p ON v.id = p.vrsta_id
		JOIN ljubimac l ON p.id = l.pasmina_id
		GROUP BY v.id;

SELECT * FROM vrsta_statistika;

-- 3. Pogled: ljubimci s rezervacijama

DROP VIEW IF EXISTS ljubimci_s_rezervacijama;
CREATE VIEW ljubimci_s_rezervacijama AS
SELECT 
    l.id AS ljubimac_id,
    l.ime AS ljubimac_ime,
    p.naziv AS pasmina_naziv,
    v.naziv AS vrsta_naziv,
    rl.rezervacija_id AS rezervacija_id,
    r.datum AS rezervacija_datum
FROM 
    ljubimac l
    JOIN pasmina p ON l.pasmina_id = p.id
    JOIN vrsta v ON p.vrsta_id = v.id
    LEFT JOIN rezervacija_ljubimac rl ON l.id = rl.ljubimac_id
    LEFT JOIN rezervacija r ON rl.rezervacija_id = r.id;

SELECT * FROM ljubimci_s_rezervacijama;

-- 4. Pogled: Pasmina statistika

DROP VIEW IF EXISTS pasmina_statistika;
CREATE VIEW pasmina_statistika AS
	SELECT
		p.id AS pasmina_id,
		p.naziv AS pasmina_naziv,
		p.opis AS pasmina_opis,
		p.porijeklo AS pasmina_porijeklo,
		p.tezina AS pasmina_tezina,
		p.zivotni_vijek AS pasmina_zivotni_vijek,
		v.naziv AS vrsta_naziv,
		COUNT(l.id) AS broj_ljubimaca,
		AVG(l.dob) AS prosjecna_dob_ljubimaca,
		MIN(l.dob) AS najmanja_dob_ljubimaca,
		MAX(l.dob) AS najveca_dob_ljubimaca,
		AVG(l.tezina) AS prosjecna_tezina_ljubimaca,
		MIN(l.tezina) AS najmanja_tezina_ljubimaca,
		MAX(l.tezina) AS najveca_tezina_ljubimaca,
		(SELECT AVG(rez_count)
			FROM (
				SELECT COUNT(rl.rezervacija_id) AS rez_count
					FROM ljubimac l2
					LEFT JOIN rezervacija_ljubimac rl ON l2.id = rl.ljubimac_id
					WHERE l2.pasmina_id = p.id
					GROUP BY l2.id
		 ) AS broj_rez) AS prosjecan_broj_rezervacija_po_ljubimcu
		FROM pasmina p
		LEFT JOIN vrsta v ON p.vrsta_id = v.id
		LEFT JOIN ljubimac l ON p.id = l.pasmina_id
		GROUP BY p.id, v.naziv;

SELECT * FROM pasmina_statistika;

