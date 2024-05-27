select * from usluga;
select * from cuvar;
select * from aktivnost;
select * from cuvar_aktivnost;


-- 1. Izračunava koliko je tko usluga napravio od čuvara, od svakog čuvara izračunava ukupno zaradu te koliko prosječno uzima po usluzi. 
SELECT cuvar.id , cuvar.ime,cuvar.prezime,
    COUNT(usluga.id) AS broj_usluga,
    SUM(usluga.cijena) AS ukupna_zarada,
    AVG(usluga.cijena) AS prosjecna_cijena
FROM cuvar 
INNER JOIN usluga ON cuvar.id = usluga.cuvar_id
GROUP BY cuvar.grad, cuvar.id, cuvar.ime, cuvar.prezime
HAVING COUNT(usluga.id) > 0
ORDER BY prosjecna_cijena DESC;


-- 2. Izračunava koliko je svaki čuvar mora raditi svoje aktivnosti(u minutama).
SELECT cuvar.id, cuvar.ime, cuvar.prezime,
    ROUND(SUM(TIME_TO_SEC(aktivnost.trajanje) / 60), 2) AS ukupno_trajanje_min
FROM cuvar
INNER JOIN cuvar_aktivnost ON cuvar.id = cuvar_aktivnost.cuvar_id
INNER JOIN aktivnost ON cuvar_aktivnost.aktivnost_id = aktivnost.id
GROUP BY cuvar.id, cuvar.ime, cuvar.prezime
ORDER BY ukupno_trajanje_min DESC;

-- 3. Izračunava prosjek cijena svih usluga u gradu Zagrebu i vrača usluge koje su iznad tog prosijeka.
SELECT DISTINCT usluga.naziv, usluga.opis
FROM usluga
INNER JOIN cuvar ON usluga.cuvar_id = cuvar.id
INNER JOIN cuvar_aktivnost ON cuvar.id = cuvar_aktivnost.cuvar_id
INNER JOIN aktivnost ON cuvar_aktivnost.aktivnost_id = aktivnost.id
WHERE cuvar.grad = 'Zagreb'
AND usluga.cijena > (
    SELECT AVG(usluga.cijena)
    FROM usluga 
    INNER JOIN cuvar ON usluga.cuvar_id = cuvar.id
    INNER JOIN cuvar_aktivnost ON cuvar.id = cuvar_aktivnost.cuvar_id
    INNER JOIN aktivnost ON cuvar_aktivnost.aktivnost_id = aktivnost.id
    WHERE cuvar.grad = 'Zagreb'
);


-- 4. Izdvoji koja je osoba zaradila najviše novaca u svim gradovima. 
SELECT cuvar.grad, cuvar.ime, cuvar.prezime, usluga.naziv, usluga.opis, usluga.cijena
FROM usluga
JOIN cuvar ON usluga.cuvar_id = cuvar.id
WHERE usluga.cijena = (
	SELECT MAX(usluga_u2.cijena)
        FROM usluga AS usluga_u2
        JOIN cuvar AS cuvar_c2 ON usluga_u2.cuvar_id = cuvar_c2.id
        WHERE cuvar_c2.grad = cuvar.grad
    )
ORDER BY cuvar.grad;


-- 5. Koliko rezervacija ima svaka aktivnost.
-- drop view broj_rezervacija;
create view broj_rezervacija as
SELECT aktivnost.naziv AS vrsta_aktivnosti, COUNT(*) AS broj_rezervacija
FROM cuvar
JOIN cuvar_aktivnost ON cuvar.id = cuvar_aktivnost.cuvar_id
JOIN aktivnost ON cuvar_aktivnost.aktivnost_id = aktivnost.id
GROUP BY aktivnost.naziv
ORDER BY broj_rezervacija DESC;

-- test
select * from broj_rezervacija;

-- 6 Prema spolu određuje broj čuvara, prosječnu dob i koliko su ukupno zaradili.
-- drop view spolovi;
create view spolovi as 
SELECT
    cuvar.spol,
    COUNT(DISTINCT cuvar.id) AS broj_cuvara,
    ROUND(AVG(DATEDIFF(CURRENT_DATE, cuvar.datum_rodenja) / 365), 1) AS prosjecna_dob_godina,
    SUM(usluga.cijena) AS suma_cijena
FROM cuvar
JOIN usluga ON cuvar.id = usluga.cuvar_id
GROUP BY cuvar.spol;

-- test 
select * from spolovi;

-- 7 Ovaj kod broji aktivnosti s različitim intenzitetima za svaki grad.
-- drop view intenzitet_po_gradu;
create view intenzitet_po_gradu as 
SELECT 
    cuvar.grad AS puni_naziv_grada,
    SUM(aktivnost.intenzitet = ' srednje') AS broj_srednjeg,
    SUM(aktivnost.intenzitet = ' nisko') AS broj_niskog,
    SUM(aktivnost.intenzitet = ' visoko') AS broj_visokog
FROM cuvar
JOIN cuvar_aktivnost ON cuvar.id = cuvar_aktivnost.cuvar_id
JOIN aktivnost ON cuvar_aktivnost.aktivnost_id = aktivnost.id
GROUP BY cuvar.grad
ORDER BY cuvar.grad;

-- test 
select * from intenzitet_po_gradu;


-- 8 Prikaži sve aktivnosti koje traju duže od 1 sata i imaju više od 5 rezervacija.
-- drop view dugacke_popularne_rezervacije;
create view dugacke_popularne_rezervacije as 
SELECT * FROM aktivnost 
WHERE trajanje > '01:00:00' 
AND id IN (
	SELECT aktivnost_id 
    FROM cuvar_aktivnost 
    GROUP BY aktivnost_id 
    HAVING COUNT(*) > 5);

-- test 
select * from dugacke_popularne_rezervacije;






 






















 










    
    
    



