-- Esquema mínimo de inventario: productos, almacenes y existencias.
PRAGMA foreign_keys = ON;

CREATE TABLE productos (
    id        INTEGER PRIMARY KEY,
    sku       TEXT NOT NULL UNIQUE,
    nombre    TEXT NOT NULL,
    precio    REAL NOT NULL CHECK (precio >= 0)
);

CREATE TABLE almacenes (
    id     INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL UNIQUE
);

CREATE TABLE existencias (
    producto_id INTEGER NOT NULL REFERENCES productos(id),
    almacen_id  INTEGER NOT NULL REFERENCES almacenes(id),
    cantidad    INTEGER NOT NULL CHECK (cantidad >= 0),
    PRIMARY KEY (producto_id, almacen_id)
);
