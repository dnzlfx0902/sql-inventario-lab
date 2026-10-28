INSERT INTO productos (id, sku, nombre, precio) VALUES
    (1, 'TEC-001', 'Teclado', 450.0),
    (2, 'TEC-002', 'Ratón', 250.0),
    (3, 'MON-001', 'Monitor 24"', 3200.0);

INSERT INTO almacenes (id, nombre) VALUES (1, 'centro'), (2, 'norte');

INSERT INTO existencias (producto_id, almacen_id, cantidad) VALUES
    (1, 1, 12), (1, 2, 3),
    (2, 1, 25), (2, 2, 10),
    (3, 2, 4);
