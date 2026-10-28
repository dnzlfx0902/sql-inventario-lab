-- 1. Valor total del inventario por almacén.
SELECT a.nombre AS almacen,
       SUM(p.precio * e.cantidad) AS valor
FROM existencias e
JOIN productos p ON p.id = e.producto_id
JOIN almacenes a ON a.id = e.almacen_id
GROUP BY a.nombre
ORDER BY valor DESC;

-- 2. Productos sin existencia en el almacén centro.
SELECT p.sku
FROM productos p
WHERE NOT EXISTS (
    SELECT 1 FROM existencias e
    WHERE e.producto_id = p.id AND e.almacen_id = 1
)
ORDER BY p.sku;

-- 3. Existencias por debajo del mínimo operativo (5 unidades).
SELECT p.sku, e.cantidad
FROM existencias e JOIN productos p ON p.id = e.producto_id
WHERE e.cantidad < 5
ORDER BY e.cantidad, p.sku;
