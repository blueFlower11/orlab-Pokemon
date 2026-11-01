#!/usr/bin/env bash
set -euo pipefail

mapa="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ -z "${DATABASE_URL:-}" ]]; then
    printf 'Postavite varijablu DATABASE_URL u svojem terminalu.\n' >&2
    exit 2
fi

for alat in psql pg_dump; do
    if ! command -v "$alat" >/dev/null 2>&1; then
        printf 'Nedostaje potreban alat: %s\n' "$alat" >&2
        exit 2
    fi
done

psql "$DATABASE_URL" -X -v ON_ERROR_STOP=1 -q \
    -f "$mapa/izvoz_csv.sql" > "$mapa/izmisljena-bica.csv"

psql "$DATABASE_URL" -X -v ON_ERROR_STOP=1 -q -A -t \
    -f "$mapa/izvoz_json.sql" > "$mapa/izmisljena-bica.json"

pg_dump "$DATABASE_URL" --schema=lab_bica --no-owner --no-privileges \
    > "$mapa/dump.sql"
