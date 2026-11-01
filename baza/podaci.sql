-- Početni podaci: 15 izmišljenih bića u pet razvojnih nizova.
-- Skripta se može pokrenuti više puta bez stvaranja duplikata.

BEGIN;

INSERT INTO lab_bica.staniste (naziv) VALUES
    ('Šumski rub'),
    ('Vulkanska dolina'),
    ('Riječni rukavac'),
    ('Stjenovita visoravan'),
    ('Vjetrovita poljana')
ON CONFLICT (naziv) DO NOTHING;

INSERT INTO lab_bica.rijetkost (naziv) VALUES
    ('Uobičajena'),
    ('Neuobičajena'),
    ('Rijetka')
ON CONFLICT (naziv) DO NOTHING;

INSERT INTO lab_bica.tip_bica (naziv) VALUES
    ('Biljni'),
    ('Vatreni'),
    ('Vodeni'),
    ('Zemljani'),
    ('Zračni'),
    ('Svjetlosni')
ON CONFLICT (naziv) DO NOTHING;

INSERT INTO lab_bica.sposobnost (naziv) VALUES
    ('Fotosinteza'),
    ('Koraštit'),
    ('Korijenov prasak'),
    ('Žar'),
    ('Toplinski oklop'),
    ('Plameni nalet'),
    ('Osjet struje'),
    ('Vodeni veo'),
    ('Dubinska struja'),
    ('Olujni zov'),
    ('Kamenokoža'),
    ('Potresni udar'),
    ('Gromovita obrana'),
    ('Vjetrohod'),
    ('Oštro oko')
ON CONFLICT (naziv) DO NOTHING;

INSERT INTO lab_bica.nacin_razvoja (naziv) VALUES ('Sazrijevanje')
ON CONFLICT (naziv) DO NOTHING;

INSERT INTO lab_bica.vrsta_uvjeta_razvoja (naziv) VALUES ('Minimalna razina')
ON CONFLICT (naziv) DO NOTHING;

INSERT INTO lab_bica.vrsta_bica (
    kataloski_broj, naziv, opis, visina_cm, masa_kg, staniste_id, rijetkost_id
)
SELECT
    podaci.kataloski_broj,
    podaci.naziv,
    podaci.opis,
    podaci.visina_cm,
    podaci.masa_kg,
    staniste.staniste_id,
    rijetkost.rijetkost_id
FROM (VALUES
    (1,  'Listić',      'Maleno šumsko biće koje skuplja sunčevu toplinu u listovima.', 22.0,   1.30, 'Šumski rub',          'Uobičajena'),
    (2,  'Trnovrat',    'Čuvar šumskog tla čije bodlje štite mlade biljke.',            68.0,  12.40, 'Šumski rub',          'Neuobičajena'),
    (3,  'Šumokljun',   'Snažno krošnjasto biće koje širi sjeme na velike udaljenosti.',180.0, 74.00, 'Šumski rub',          'Rijetka'),
    (4,  'Žarčić',     'Razigrano biće koje čuva malu iskru u toploj grivi.',            20.0,   1.10, 'Vulkanska dolina',   'Uobičajena'),
    (5,  'Plamenorep',  'Brzo biće čiji rep ostavlja kratke tragove topline.',           82.0,  18.60, 'Vulkanska dolina',   'Neuobičajena'),
    (6,  'Ognjenik',    'Moćni stanovnik doline koji nadzire tokove užarene stijene.',  166.0,  79.20, 'Vulkanska dolina',   'Rijetka'),
    (7,  'Kapljak',     'Sitno vodeno biće koje živi uz mirne riječne rukavce.',         24.0,   0.90, 'Riječni rukavac',    'Uobičajena'),
    (8,  'Brzoperaj',   'Spretan plivač koji osjeća promjene u riječnim strujama.',      75.0,  16.00, 'Riječni rukavac',    'Neuobičajena'),
    (9,  'Plimorog',    'Dubokovodno biće čiji snažni rogovi razbijaju visoke valove.', 155.0,  63.00, 'Riječni rukavac',    'Rijetka'),
    (10, 'Šljunak',     'Malo kameno biće koje se skriva među zaobljenim oblutcima.',    26.0,   4.00, 'Stjenovita visoravan','Uobičajena'),
    (11, 'Kamenoril',   'Čvrsto biće s oklopom od slojevitog granita.',                  88.0,  62.00, 'Stjenovita visoravan','Neuobičajena'),
    (12, 'Gromoklop',   'Teško biće čiji koraci pokreću sitne odrone.',                 172.0, 148.00, 'Stjenovita visoravan','Rijetka'),
    (13, 'Puhić',       'Lagano biće koje klizi iznad travnatih poljana.',               19.0,   0.60, 'Vjetrovita poljana', 'Uobičajena'),
    (14, 'Vjetrokrest', 'Brzo biće koje usmjerava vjetar širokim krilima.',              69.0,   8.40, 'Vjetrovita poljana', 'Neuobičajena'),
    (15, 'Olujokril',   'Rijetko biće koje se pojavljuje prije ljetnih oluja.',         151.0,  33.20, 'Vjetrovita poljana', 'Rijetka')
) AS podaci(kataloski_broj, naziv, opis, visina_cm, masa_kg, staniste_naziv, rijetkost_naziv)
JOIN lab_bica.staniste AS staniste ON staniste.naziv = podaci.staniste_naziv
JOIN lab_bica.rijetkost AS rijetkost ON rijetkost.naziv = podaci.rijetkost_naziv
ON CONFLICT (kataloski_broj) DO UPDATE SET
    naziv = EXCLUDED.naziv,
    opis = EXCLUDED.opis,
    visina_cm = EXCLUDED.visina_cm,
    masa_kg = EXCLUDED.masa_kg,
    staniste_id = EXCLUDED.staniste_id,
    rijetkost_id = EXCLUDED.rijetkost_id;

INSERT INTO lab_bica.osnovna_statistika (
    bice_id, zdravlje, napad, obrana, specijalni_napad, specijalna_obrana, brzina
)
SELECT bice.bice_id, podaci.zdravlje, podaci.napad, podaci.obrana,
       podaci.specijalni_napad, podaci.specijalna_obrana, podaci.brzina
FROM (VALUES
    (1,  32,  28,  30,  35,  34,  41),
    (2,  58,  54,  61,  52,  58,  48),
    (3, 104,  88, 112,  91, 105,  62),
    (4,  30,  39,  28,  42,  31,  56),
    (5,  64,  71,  58,  68,  55,  76),
    (6,  99, 113,  82, 108,  84, 101),
    (7,  34,  30,  42,  39,  51,  45),
    (8,  68,  55,  73,  74,  79,  67),
    (9,  98,  87, 102, 116, 108,  89),
    (10, 40,  45,  54,  25,  33,  28),
    (11, 79,  82, 106,  45,  72,  33),
    (12,115, 121, 132,  68, 102,  47),
    (13, 28,  26,  24,  35,  32,  72),
    (14, 58,  52,  43,  62,  56, 104),
    (15, 94,  83,  74, 112,  88, 128)
) AS podaci(kataloski_broj, zdravlje, napad, obrana, specijalni_napad, specijalna_obrana, brzina)
JOIN lab_bica.vrsta_bica AS bice ON bice.kataloski_broj = podaci.kataloski_broj
ON CONFLICT (bice_id) DO UPDATE SET
    zdravlje = EXCLUDED.zdravlje,
    napad = EXCLUDED.napad,
    obrana = EXCLUDED.obrana,
    specijalni_napad = EXCLUDED.specijalni_napad,
    specijalna_obrana = EXCLUDED.specijalna_obrana,
    brzina = EXCLUDED.brzina;

INSERT INTO lab_bica.bice_tip (bice_id, tip_id, redni_broj)
SELECT bice.bice_id, tip.tip_id, podaci.redni_broj
FROM (VALUES
    ('Listić',      'Biljni',     1),
    ('Trnovrat',    'Biljni',     1),
    ('Šumokljun',   'Biljni',     1), ('Šumokljun',   'Zemljani',   2),
    ('Žarčić',      'Vatreni',    1),
    ('Plamenorep',  'Vatreni',    1),
    ('Ognjenik',    'Vatreni',    1), ('Ognjenik',    'Zračni',     2),
    ('Kapljak',     'Vodeni',     1),
    ('Brzoperaj',   'Vodeni',     1),
    ('Plimorog',    'Vodeni',     1), ('Plimorog',    'Zračni',     2),
    ('Šljunak',     'Zemljani',   1),
    ('Kamenoril',   'Zemljani',   1),
    ('Gromoklop',   'Zemljani',   1), ('Gromoklop',   'Vatreni',    2),
    ('Puhić',       'Zračni',     1),
    ('Vjetrokrest', 'Zračni',     1),
    ('Olujokril',   'Zračni',     1), ('Olujokril',   'Svjetlosni', 2)
) AS podaci(naziv_bica, naziv_tipa, redni_broj)
JOIN lab_bica.vrsta_bica AS bice ON bice.naziv = podaci.naziv_bica
JOIN lab_bica.tip_bica AS tip ON tip.naziv = podaci.naziv_tipa
ON CONFLICT (bice_id, redni_broj) DO UPDATE SET tip_id = EXCLUDED.tip_id;

INSERT INTO lab_bica.bice_sposobnost (bice_id, sposobnost_id, utor, skrivena)
SELECT bice.bice_id, sposobnost.sposobnost_id, podaci.utor, podaci.skrivena
FROM (VALUES
    ('Listić',      'Fotosinteza',       1, FALSE), ('Listić',      'Korijenov prasak', 3, TRUE),
    ('Trnovrat',    'Koraštit',          1, FALSE), ('Trnovrat',    'Korijenov prasak', 3, TRUE),
    ('Šumokljun',   'Koraštit',          1, FALSE), ('Šumokljun',   'Fotosinteza',      3, TRUE),
    ('Žarčić',      'Žar',               1, FALSE), ('Žarčić',      'Toplinski oklop',  3, TRUE),
    ('Plamenorep',  'Toplinski oklop',   1, FALSE), ('Plamenorep',  'Plameni nalet',    3, TRUE),
    ('Ognjenik',    'Plameni nalet',     1, FALSE), ('Ognjenik',    'Žar',              3, TRUE),
    ('Kapljak',     'Osjet struje',      1, FALSE), ('Kapljak',     'Vodeni veo',       3, TRUE),
    ('Brzoperaj',   'Vodeni veo',        1, FALSE), ('Brzoperaj',   'Dubinska struja',  3, TRUE),
    ('Plimorog',    'Dubinska struja',   1, FALSE), ('Plimorog',    'Olujni zov',       3, TRUE),
    ('Šljunak',     'Kamenokoža',        1, FALSE), ('Šljunak',     'Potresni udar',    3, TRUE),
    ('Kamenoril',   'Potresni udar',     1, FALSE), ('Kamenoril',   'Kamenokoža',       3, TRUE),
    ('Gromoklop',   'Gromovita obrana',  1, FALSE), ('Gromoklop',   'Potresni udar',    3, TRUE),
    ('Puhić',       'Vjetrohod',         1, FALSE), ('Puhić',       'Oštro oko',        3, TRUE),
    ('Vjetrokrest', 'Oštro oko',         1, FALSE), ('Vjetrokrest', 'Olujni zov',       3, TRUE),
    ('Olujokril',   'Olujni zov',       1, FALSE), ('Olujokril',   'Vjetrohod',        3, TRUE)
) AS podaci(naziv_bica, naziv_sposobnosti, utor, skrivena)
JOIN lab_bica.vrsta_bica AS bice ON bice.naziv = podaci.naziv_bica
JOIN lab_bica.sposobnost AS sposobnost ON sposobnost.naziv = podaci.naziv_sposobnosti
ON CONFLICT (bice_id, sposobnost_id) DO UPDATE SET
    utor = EXCLUDED.utor,
    skrivena = EXCLUDED.skrivena;

INSERT INTO lab_bica.razvoj (roditelj_id, dijete_id, nacin_razvoja_id)
SELECT roditelj.bice_id, dijete.bice_id, nacin.nacin_razvoja_id
FROM (VALUES
    ('Listić',     'Trnovrat'),
    ('Trnovrat',   'Šumokljun'),
    ('Žarčić',     'Plamenorep'),
    ('Plamenorep', 'Ognjenik'),
    ('Kapljak',    'Brzoperaj'),
    ('Brzoperaj',  'Plimorog'),
    ('Šljunak',    'Kamenoril'),
    ('Kamenoril',  'Gromoklop'),
    ('Puhić',      'Vjetrokrest'),
    ('Vjetrokrest','Olujokril')
) AS podaci(roditelj_naziv, dijete_naziv)
JOIN lab_bica.vrsta_bica AS roditelj ON roditelj.naziv = podaci.roditelj_naziv
JOIN lab_bica.vrsta_bica AS dijete ON dijete.naziv = podaci.dijete_naziv
JOIN lab_bica.nacin_razvoja AS nacin ON nacin.naziv = 'Sazrijevanje'
ON CONFLICT (roditelj_id, dijete_id) DO UPDATE SET
    nacin_razvoja_id = EXCLUDED.nacin_razvoja_id;

INSERT INTO lab_bica.uvjet_razvoja (razvoj_id, vrsta_uvjeta_id, vrijednost)
SELECT razvoj.razvoj_id, vrsta_uvjeta.vrsta_uvjeta_id, podaci.minimalna_razina::VARCHAR
FROM (VALUES
    ('Listić',     'Trnovrat',    12),
    ('Trnovrat',   'Šumokljun',   28),
    ('Žarčić',     'Plamenorep',  12),
    ('Plamenorep', 'Ognjenik',   28),
    ('Kapljak',    'Brzoperaj',   12),
    ('Brzoperaj',  'Plimorog',    28),
    ('Šljunak',    'Kamenoril',   12),
    ('Kamenoril',  'Gromoklop',   28),
    ('Puhić',      'Vjetrokrest', 12),
    ('Vjetrokrest','Olujokril',   28)
) AS podaci(roditelj_naziv, dijete_naziv, minimalna_razina)
JOIN lab_bica.vrsta_bica AS roditelj ON roditelj.naziv = podaci.roditelj_naziv
JOIN lab_bica.vrsta_bica AS dijete ON dijete.naziv = podaci.dijete_naziv
JOIN lab_bica.razvoj AS razvoj
    ON razvoj.roditelj_id = roditelj.bice_id
   AND razvoj.dijete_id = dijete.bice_id
JOIN lab_bica.vrsta_uvjeta_razvoja AS vrsta_uvjeta ON vrsta_uvjeta.naziv = 'Minimalna razina'
ON CONFLICT (razvoj_id, vrsta_uvjeta_id)
DO UPDATE SET vrijednost = EXCLUDED.vrijednost;

COMMIT;
