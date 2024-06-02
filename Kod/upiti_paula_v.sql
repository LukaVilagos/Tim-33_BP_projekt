USE Sustav_za_rezervaciju_cuvara_ljubimaca;
-- grupa tablica: Ustanova, Čuvar_Ustanova, Mjesto_Interesa, Regija

-- 1. upit --
SELECT u.naziv AS naziv_ustanove, u.adresa AS adresa_ustanove, r.naziv AS naziv_regije,
       c.ime AS ime_cuvara, c.prezime AS prezime_cuvara, c.email AS email_cuvara
FROM ustanova u
JOIN cuvar_ustanova cu ON u.id = cu.ustanova_id
JOIN cuvar c ON cu.cuvar_id = c.id
JOIN regija r ON u.regija_id = r.id
WHERE r.naziv = 'Karlovačka';

-- 2. upit --
SELECT u.naziv AS naziv_ustanove, u.adresa AS adresa_ustanove, u.ocjena AS ocjena_ustanove, 
       r.naziv AS naziv_regije, r.opis AS opis_regije
FROM ustanova u
JOIN regija r ON u.regija_id = r.id
WHERE u.ocjena > (
    SELECT AVG(u2.ocjena)
    FROM ustanova u2
    WHERE u2.regija_id = u.regija_id
);

-- 3. upit --
SELECT r.naziv AS naziv_regije, AVG(u.ocjena) AS prosjecna_ocjena
FROM ustanova u
JOIN regija r ON u.regija_id = r.id
GROUP BY r.naziv
HAVING AVG(u.ocjena) > 4.4
ORDER BY prosjecna_ocjena DESC;

-- 4. upit --
SELECT c.ime AS ime_cuvara, c.prezime AS prezime_cuvara, c.email AS email_cuvara,
       u.naziv AS naziv_ustanove, u.ocjena AS ocjena_ustanove, r.naziv AS naziv_regije
FROM cuvar c
JOIN cuvar_ustanova cu ON c.id = cu.cuvar_id
JOIN ustanova u ON cu.ustanova_id = u.id
JOIN regija r ON u.regija_id = r.id
WHERE r.naziv LIKE 'P%';

-- 1. pogled --
DROP VIEW IF EXISTS broj_ustanova_po_regiji;

CREATE VIEW broj_ustanova_po_regiji AS
SELECT r.naziv AS naziv_regije,
COUNT(u.id) AS broj_ustanova
FROM ustanova u
JOIN regija r ON u.regija_id = r.id
GROUP BY r.naziv
ORDER BY broj_ustanova DESC;

SELECT * FROM broj_ustanova_po_regiji;

-- 2. pogled --
DROP VIEW IF EXISTS mjesto_interesa_u_regiji_i_info;

CREATE VIEW mjesto_interesa_u_regiji_i_info AS
SELECT m.id AS mjesto_interesa_id, 
       m.naziv AS mjesto_interesa_naziv, 
       m.adresa AS mjesto_interesa_adresa, 
       r.naziv AS regija_naziv, 
       r.opis AS regija_opis,
       r.povrsina AS regija_povrsina
FROM mjesto_interesa m
JOIN regija r ON m.regija_id = r.id
ORDER BY regija_povrsina DESC;

SELECT * FROM mjesto_interesa_u_regiji_i_info;

-- 3. pogled --
DROP VIEW IF EXISTS broj_cuvara_po_regiji;

CREATE VIEW broj_cuvara_po_regiji AS
SELECT r.naziv AS regija_naziv, COUNT(c.id) AS broj_cuvara
FROM cuvar c
JOIN cuvar_ustanova cu ON c.id = cu.cuvar_id
JOIN ustanova u ON cu.ustanova_id = u.id
JOIN regija r ON u.regija_id = r.id
GROUP BY r.naziv;

SELECT * FROM broj_cuvara_po_regiji;

-- 4. pogled --
DROP VIEW IF EXISTS prosjecna_ocjena_i_top_ustanova_po_regiji;

CREATE VIEW prosjecna_ocjena_i_top_ustanova_po_regiji AS
WITH top_ustanova AS (
    SELECT u.regija_id,
    u.naziv AS naziv_top_ustanove,
    u.ocjena AS ocjena_top_ustanove
    FROM ustanova u
    JOIN (
        SELECT regija_id,
        MAX(ocjena) AS max_ocjena
        FROM ustanova
        GROUP BY regija_id
    ) max_u ON u.regija_id = max_u.regija_id AND u.ocjena = max_u.max_ocjena
)
SELECT r.naziv AS naziv_regije,
AVG(u.ocjena) AS prosjecna_ocjena, 
tu.naziv_top_ustanove,
tu.ocjena_top_ustanove
FROM ustanova u
JOIN regija r ON u.regija_id = r.id
JOIN top_ustanova tu ON r.id = tu.regija_id
GROUP BY r.naziv, tu.naziv_top_ustanove, tu.ocjena_top_ustanove;

SELECT * FROM prosjecna_ocjena_i_top_ustanova_po_regiji;