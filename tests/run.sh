#!/usr/bin/env bash
# Ejecuta el laboratorio sobre una base temporal: aplica esquema y datos,
# comprueba cada consulta contra su resultado esperado y falla si algo difiere.
set -euo pipefail
cd "$(dirname "$0")/.."

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
db="$tmp/lab.db"

sqlite3 "$db" < sql/schema.sql
sqlite3 "$db" < sql/datos.sql

comprobar() {
  local nombre="$1" consulta="$2" esperado="$3" obtenido
  obtenido="$(sqlite3 -noheader "$db" "$consulta")"
  if [[ "$obtenido" != "$esperado" ]]; then
    printf 'FALLA %s\n  esperado: %s\n  obtenido: %s\n' "$nombre" "$esperado" "$obtenido" >&2
    exit 1
  fi
  printf 'ok %s\n' "$nombre"
}

# Para violaciones que la base debe rechazar: exige código distinto de cero y
# que el mensaje de error contenga el texto esperado.
comprobar_error() {
  local nombre="$1" consulta="$2" esperado="$3" salida
  if salida="$(sqlite3 "$db" "$consulta" 2>&1)"; then
    printf 'FALLA %s: se esperaba un rechazo y la sentencia pasó\n' "$nombre" >&2
    exit 1
  fi
  if [[ "$salida" != *"$esperado"* ]]; then
    printf 'FALLA %s\n  esperado en el error: %s\n  obtenido: %s\n' "$nombre" "$esperado" "$salida" >&2
    exit 1
  fi
  printf 'ok %s (rechazado)\n' "$nombre"
}

comprobar "valor por almacen" "SELECT group_concat(almacen || '=' || valor, '|') FROM (SELECT a.nombre AS almacen, SUM(p.precio*e.cantidad) AS valor FROM existencias e JOIN productos p ON p.id=e.producto_id JOIN almacenes a ON a.id=e.almacen_id GROUP BY a.nombre ORDER BY valor DESC)" "norte=16650.0|centro=11650.0"
comprobar "sin existencia en centro" "SELECT sku FROM productos p WHERE NOT EXISTS (SELECT 1 FROM existencias e WHERE e.producto_id=p.id AND e.almacen_id=1) ORDER BY sku" "MON-001"
comprobar "bajo minimo" "SELECT group_concat(sku || ':' || cantidad, '|') FROM (SELECT p.sku, e.cantidad FROM existencias e JOIN productos p ON p.id=e.producto_id WHERE e.cantidad < 5 ORDER BY e.cantidad, p.sku)" "TEC-001:3|MON-001:4"
comprobar "integridad referencial" "SELECT COUNT(*) FROM existencias e LEFT JOIN productos p ON p.id=e.producto_id WHERE p.id IS NULL" "0"

printf 'OK 4 consultas\n'
if [[ "${1:-}" == "--demo" ]]; then
  sqlite3 -header -column "$db" "SELECT a.nombre AS almacen, SUM(p.precio*e.cantidad) AS valor FROM existencias e JOIN productos p ON p.id=e.producto_id JOIN almacenes a ON a.id=e.almacen_id GROUP BY a.nombre ORDER BY valor DESC;"
fi
