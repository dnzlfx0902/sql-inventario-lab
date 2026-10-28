# Laboratorio de consultas de inventario (20 consultas)

Esquema de inventario con DDL y datos de prueba más 20 consultas resueltas, cada una con su resultado esperado comprobado por tests/run.sh sobre sqlite3.

`sql` · 2026-10-29

## Instalación

```bash
sqlite3 --version   # cualquier 3.35 o superior
```

## Uso

```bash
sqlite3 lab.db < sql/schema.sql
sqlite3 lab.db < sql/datos.sql
sqlite3 lab.db < sql/consultas.sql
bash tests/run.sh
```

Salida real de una corrida de ejemplo:

```text
almacen   valor
-------  -------
norte    16650.0
centro   11650.0
```

## Cómo probar

```bash
bash tests/run.sh
```

## Estructura

```text
2026-10-29-sql-inventario-lab/
├── .gitignore
├── LICENSE
├── sql/
│   ├── consultas.sql
│   ├── datos.sql
│   └── schema.sql
└── tests/
    └── run.sh
```

## Licencia

Distribuido bajo la licencia MIT.
