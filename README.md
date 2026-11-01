# orlab-Pokemon

Repozitorij laboratorijske vježbe FER kolegija Otvoreno računarstvo.

### Verzija v1.0

Jezik: hrvatski

## Skup podataka

Direktorij [`skup_podataka_bica/`](skup_podataka_bica/) sadrži normaliziranu PostgreSQL bazu i izvorne datoteke za skup **Izmišljena bića**:

- 15 zapisa, s najmanje 10 atributa po zapisu u CSV-u i JSON-u;
- 10 usmjerenih roditelj–dijete veza raspoređenih u pet razvojnih nizova;
- SQL shemu i podatke, upite za izvoz, automatiziranu skriptu, CSV/JSON snimke i početni SQL ispis baze;
- metapodatke, opis modela i upute za provjeru u `skup_podataka_bica/README.md`.

Bića i njihovi nazivi/opisi izvorno su osmišljeni za ovu vježbu. Razvojni nizovi tematski su nadahnuti igrama Pokémon, ali skup ne sadrži službene likove, slike ni službene podatke te nije povezan s vlasnicima te franšize.

### Opis skupa podataka

- nacin razvoja - za sada je osmisljen samo jedan nacin razvoja, a oznacava nacin na koji zamisljena bica prelaze iz jedne forme u drugu
- rijetkost - informacija o tome koliko cesto se izmisljeno bice moze susresti u prirodi
- sposobnost - posebne sposobnosti koje ima bica
- staniste - lokacija na kojoj se bica najcesce moze susresti
- tip-bica - posebna karakteristika koja opisuje bica i grupira ih medusobno
- vrsta-uvijeta-razvoja - posebna karakteristika koja opisuje uvijet razvoja bica
- vrsta-bica - detalji o bicu, naziv, prosjecka velicina i poveznica sa ostalim velicinama

## Pokretanje i provjera

Iz mape `skup_podataka_bica/` postavite `DATABASE_URL` u svom lokalnom okruženju, a zatim pokrenite:

```bash
psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -f shema.sql -f podaci.sql
./izvezi.sh
python3 provjeri_izvoz.py
```

Ne spremajte vezu baze u repozitorij. CSV i JSON koji su već uključeni u mapu su početne snimke; `izvezi.sh` stvara izlaz iz stvarne PostgreSQL baze te SQL ispis sheme `lab_bica`. Izvoz iz stvarne Neon baze nije potvrđen u ovom okruženju.

## Licencija

Repozitorij koristi licenciju CC0 1.0 Universal iz datoteke [`LICENSE`](LICENSE). Ona se odnosi na izvorni sadržaj ovog skupa; ne daje prava na Pokémon žigove, likove, slike ni druge materijale trećih strana.

## Autor

Viktorija Sturlic-Tupek
