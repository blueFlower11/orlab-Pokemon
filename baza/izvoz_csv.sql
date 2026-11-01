-- Izravnani CSV izvoz: jedan redak po biću, s roditeljskim i dječjim vezama.
COPY (
    SELECT
        bice.kataloski_broj,
        bice.naziv,
        bice.opis,
        bice.visina_cm,
        bice.masa_kg,
        staniste.naziv AS staniste,
        rijetkost.naziv AS rijetkost,
        (SELECT tip.naziv
         FROM lab_bica.bice_tip AS veza
         JOIN lab_bica.tip_bica AS tip ON tip.tip_id = veza.tip_id
         WHERE veza.bice_id = bice.bice_id AND veza.redni_broj = 1) AS primarni_tip,
        (SELECT tip.naziv
         FROM lab_bica.bice_tip AS veza
         JOIN lab_bica.tip_bica AS tip ON tip.tip_id = veza.tip_id
         WHERE veza.bice_id = bice.bice_id AND veza.redni_broj = 2) AS sekundarni_tip,
        COALESCE((
            SELECT string_agg(
                sposobnost.naziv || CASE WHEN veza.skrivena THEN ' (skrivena)' ELSE '' END,
                '; ' ORDER BY veza.utor
            )
            FROM lab_bica.bice_sposobnost AS veza
            JOIN lab_bica.sposobnost AS sposobnost ON sposobnost.sposobnost_id = veza.sposobnost_id
            WHERE veza.bice_id = bice.bice_id
        ), '') AS sposobnosti,
        statistika.zdravlje,
        statistika.napad,
        statistika.obrana,
        statistika.specijalni_napad,
        statistika.specijalna_obrana,
        statistika.brzina,
        COALESCE((
            SELECT string_agg(roditelj.naziv, '; ' ORDER BY roditelj.naziv)
            FROM lab_bica.razvoj AS razvoj
            JOIN lab_bica.vrsta_bica AS roditelj ON roditelj.bice_id = razvoj.roditelj_id
            WHERE razvoj.dijete_id = bice.bice_id
        ), '') AS roditelji,
        COALESCE((
            SELECT string_agg(dijete.naziv, '; ' ORDER BY dijete.naziv)
            FROM lab_bica.razvoj AS razvoj
            JOIN lab_bica.vrsta_bica AS dijete ON dijete.bice_id = razvoj.dijete_id
            WHERE razvoj.roditelj_id = bice.bice_id
        ), '') AS djeca,
        COALESCE((
            SELECT string_agg(
                roditelj.naziv || ' → ' || dijete.naziv || ' (' || nacin.naziv ||
                COALESCE(': ' || (
                    SELECT string_agg(vrsta_uvjeta.naziv || ': ' || uvjet.vrijednost, ', ' ORDER BY vrsta_uvjeta.naziv)
                    FROM lab_bica.uvjet_razvoja AS uvjet
                    JOIN lab_bica.vrsta_uvjeta_razvoja AS vrsta_uvjeta
                      ON vrsta_uvjeta.vrsta_uvjeta_id = uvjet.vrsta_uvjeta_id
                    WHERE uvjet.razvoj_id = razvoj.razvoj_id
                ), '') || ')',
                '; ' ORDER BY roditelj.naziv, dijete.naziv
            )
            FROM lab_bica.razvoj AS razvoj
            JOIN lab_bica.vrsta_bica AS roditelj ON roditelj.bice_id = razvoj.roditelj_id
            JOIN lab_bica.vrsta_bica AS dijete ON dijete.bice_id = razvoj.dijete_id
            JOIN lab_bica.nacin_razvoja AS nacin ON nacin.nacin_razvoja_id = razvoj.nacin_razvoja_id
            WHERE razvoj.roditelj_id = bice.bice_id OR razvoj.dijete_id = bice.bice_id
        ), '') AS uvjeti_razvoja
    FROM lab_bica.vrsta_bica AS bice
    JOIN lab_bica.staniste AS staniste ON staniste.staniste_id = bice.staniste_id
    JOIN lab_bica.rijetkost AS rijetkost ON rijetkost.rijetkost_id = bice.rijetkost_id
    JOIN lab_bica.osnovna_statistika AS statistika ON statistika.bice_id = bice.bice_id
    ORDER BY bice.kataloski_broj
) TO STDOUT WITH (FORMAT CSV, HEADER TRUE);
