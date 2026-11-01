-- Ugniježđeni JSON izvoz svih bića, tipova, sposobnosti i razvojnih veza.
SELECT COALESCE(json_agg(redak.zapis ORDER BY redak.kataloski_broj), '[]'::json)
FROM (
    SELECT
        bice.kataloski_broj,
        json_build_object(
            'kataloski_broj', bice.kataloski_broj,
            'naziv', bice.naziv,
            'opis', bice.opis,
            'visina_cm', bice.visina_cm,
            'masa_kg', bice.masa_kg,
            'staniste', staniste.naziv,
            'rijetkost', rijetkost.naziv,
            'tipovi', COALESCE((
                SELECT json_agg(
                    json_build_object('redni_broj', veza.redni_broj, 'naziv', tip.naziv)
                    ORDER BY veza.redni_broj
                )
                FROM lab_bica.bice_tip AS veza
                JOIN lab_bica.tip_bica AS tip ON tip.tip_id = veza.tip_id
                WHERE veza.bice_id = bice.bice_id
            ), '[]'::json),
            'sposobnosti', COALESCE((
                SELECT json_agg(
                    json_build_object(
                        'naziv', sposobnost.naziv,
                        'utor', veza.utor,
                        'skrivena', veza.skrivena
                    ) ORDER BY veza.utor
                )
                FROM lab_bica.bice_sposobnost AS veza
                JOIN lab_bica.sposobnost AS sposobnost ON sposobnost.sposobnost_id = veza.sposobnost_id
                WHERE veza.bice_id = bice.bice_id
            ), '[]'::json),
            'osnovne_statistike', json_build_object(
                'zdravlje', statistika.zdravlje,
                'napad', statistika.napad,
                'obrana', statistika.obrana,
                'specijalni_napad', statistika.specijalni_napad,
                'specijalna_obrana', statistika.specijalna_obrana,
                'brzina', statistika.brzina
            ),
            'razvija_se_iz', COALESCE((
                SELECT json_agg(
                    json_build_object(
                        'naziv_roditelja', roditelj.naziv,
                        'nacin', nacin.naziv,
                        'uvjeti', COALESCE((
                            SELECT json_agg(
                                json_build_object('vrsta', vrsta_uvjeta.naziv, 'vrijednost', uvjet.vrijednost)
                                ORDER BY vrsta_uvjeta.naziv
                            )
                            FROM lab_bica.uvjet_razvoja AS uvjet
                            JOIN lab_bica.vrsta_uvjeta_razvoja AS vrsta_uvjeta
                              ON vrsta_uvjeta.vrsta_uvjeta_id = uvjet.vrsta_uvjeta_id
                            WHERE uvjet.razvoj_id = razvoj.razvoj_id
                        ), '[]'::json)
                    ) ORDER BY roditelj.naziv
                )
                FROM lab_bica.razvoj AS razvoj
                JOIN lab_bica.vrsta_bica AS roditelj ON roditelj.bice_id = razvoj.roditelj_id
                JOIN lab_bica.nacin_razvoja AS nacin ON nacin.nacin_razvoja_id = razvoj.nacin_razvoja_id
                WHERE razvoj.dijete_id = bice.bice_id
            ), '[]'::json),
            'razvija_se_u', COALESCE((
                SELECT json_agg(
                    json_build_object(
                        'naziv_djeteta', dijete.naziv,
                        'nacin', nacin.naziv,
                        'uvjeti', COALESCE((
                            SELECT json_agg(
                                json_build_object('vrsta', vrsta_uvjeta.naziv, 'vrijednost', uvjet.vrijednost)
                                ORDER BY vrsta_uvjeta.naziv
                            )
                            FROM lab_bica.uvjet_razvoja AS uvjet
                            JOIN lab_bica.vrsta_uvjeta_razvoja AS vrsta_uvjeta
                              ON vrsta_uvjeta.vrsta_uvjeta_id = uvjet.vrsta_uvjeta_id
                            WHERE uvjet.razvoj_id = razvoj.razvoj_id
                        ), '[]'::json)
                    ) ORDER BY dijete.naziv
                )
                FROM lab_bica.razvoj AS razvoj
                JOIN lab_bica.vrsta_bica AS dijete ON dijete.bice_id = razvoj.dijete_id
                JOIN lab_bica.nacin_razvoja AS nacin ON nacin.nacin_razvoja_id = razvoj.nacin_razvoja_id
                WHERE razvoj.roditelj_id = bice.bice_id
            ), '[]'::json)
        ) AS zapis
    FROM lab_bica.vrsta_bica AS bice
    JOIN lab_bica.staniste AS staniste ON staniste.staniste_id = bice.staniste_id
    JOIN lab_bica.rijetkost AS rijetkost ON rijetkost.rijetkost_id = bice.rijetkost_id
    JOIN lab_bica.osnovna_statistika AS statistika ON statistika.bice_id = bice.bice_id
) AS redak;
