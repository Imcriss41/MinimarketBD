
USE Minimarket;
-- =====================================================
-- 1. Igualdad en atributo entero
-- Obtiene un producto específico por su ID
-- =====================================================
SELECT *
FROM Productos
WHERE id_producto = 5;


-- =====================================================
-- 2. Igualdad en atributo cadena
-- Obtiene clientes que viven en una dirección específica
-- =====================================================
SELECT *
FROM Cliente
WHERE direccion = 'Centro';


-- =====================================================
-- 3. Mayor o igual en atributo decimal
-- Muestra productos con precio mayor o igual a 2.00
-- =====================================================
SELECT nombre_producto, precio_venta
FROM Productos
WHERE precio_venta >= 2.00;

-- =====================================================
-- 4. Distinto en atributo cadena
-- Muestra productos que NO sean de la categoría Granos
-- =====================================================
SELECT nombre_producto, categoria
FROM Productos
WHERE categoria <> 'Granos';

-- =====================================================
-- 5. IN sobre atributo cadena
-- Muestra productos de ciertas categorías
-- =====================================================
SELECT nombre_producto, categoria
FROM Productos
WHERE categoria IN ('Higiene', 'Bebidas', 'Lácteos');

-- =====================================================
-- 6. Dos condiciones con AND
-- Productos con precio alto y buen stock
-- =====================================================
SELECT nombre_producto, precio_venta, stock_disponible
FROM Productos
WHERE precio_venta > 1.50
AND stock_disponible >= 50;

-- =====================================================
-- 7. AND + proyección en 3 columnas + VISTA
-- Vista de productos caros con buen stock
-- =====================================================
DROP VIEW IF EXISTS Vista_Productos_Caros_Stock;

CREATE VIEW Vista_Productos_Caros_Stock AS
SELECT nombre_producto, precio_venta, stock_disponible
FROM Productos
WHERE precio_venta > 1.50
AND stock_disponible >= 50;

SELECT * from Vista_Productos_caros_Stock

-- =====================================================
-- 8. Dos condiciones con OR
-- Productos de higiene o bebidas
-- =====================================================
SELECT nombre_producto, categoria
FROM Productos
WHERE categoria = 'Higiene'
OR categoria = 'Bebidas';


-- =====================================================
-- 9. Uso del operador NOT
-- Productos que no pertenezcan a Granos
-- =====================================================
SELECT nombre_producto, categoria
FROM Productos
WHERE NOT categoria = 'Granos';

-- =====================================================
-- 10. JOIN con clave foránea
-- Relación productos con su proveedor
-- =====================================================
SELECT p.nombre_producto, pr.nombre AS proveedor
FROM Productos p
JOIN Proveedor pr ON p.id_proveedor = pr.id_proveedor;

-- =====================================================
-- 11. JOIN + 3 columnas + VISTA
-- Vista productos con proveedor y precio
-- =====================================================
DROP VIEW IF EXISTS Vista_Productos_Proveedor;

CREATE VIEW Vista_Productos_Proveedor AS
SELECT p.nombre_producto, p.precio_venta, pr.nombre AS proveedor
FROM Productos p
JOIN Proveedor pr ON p.id_proveedor = pr.id_proveedor;

SELECT * From Vista_Productos_Proveedor

-- =====================================================
-- 12. LEFT JOIN
-- Muestra todos los clientes y sus ventas (si existen)
-- =====================================================
SELECT c.nombre, v.id_venta, v.total_final
FROM Cliente c
LEFT JOIN Ventas v ON c.id_cliente = v.id_cliente;

-- =====================================================
-- 13. RIGHT JOIN
-- Muestra todas las ventas aunque no tengan cliente
-- =====================================================
SELECT c.nombre, v.id_venta, v.total_final
FROM Cliente c
RIGHT JOIN Ventas v ON c.id_cliente = v.id_cliente;

-- =====================================================
-- 14. Ordenamiento descendente
-- Productos ordenados por precio de mayor a menor
-- =====================================================
SELECT nombre_producto, precio_venta
FROM Productos
ORDER BY precio_venta DESC;


-- =====================================================
-- 15. Ordenamiento ASC y DESC
-- Categoría ascendente y precio descendente
-- =====================================================
SELECT nombre_producto, categoria, precio_venta
FROM Productos
ORDER BY categoria ASC, precio_venta DESC;


-- =====================================================
-- 16. Agrupamiento + COUNT
-- Cantidad de productos por categoría
-- =====================================================
SELECT categoria, COUNT(*) AS total_productos
FROM Productos
GROUP BY categoria;


-- =====================================================
-- 17. Proyección con cálculo matemático
-- Ganancia por producto
-- =====================================================
SELECT nombre_producto,
       precio_venta,
       (precio_venta - costo_compra) AS ganancia
FROM Productos;


-- =====================================================
-- 18. Proyección con CONCAT
-- Información de contacto del proveedor
-- =====================================================
SELECT nombre,
       telefono,
       CONCAT(nombre, ' - ', telefono) AS contacto
FROM Proveedor;

-- =====================================================
-- 19. CONCAT + VISTA
-- Vista de contacto por correo
-- =====================================================
DROP VIEW IF EXISTS Vista_Contacto_Proveedor;

CREATE VIEW Vista_Contacto_Proveedor AS
SELECT nombre,
       correo,
       CONCAT(nombre, ' <', correo, '>') AS contacto_email
FROM Proveedor;

SELECT * From Vista_Contacto_Proveedor

-- =====================================================
-- 20. Subconsulta con clave foránea
-- Productos del proveedor Nestlé
-- =====================================================
SELECT nombre_producto
FROM Productos
WHERE id_proveedor = (
    SELECT id_proveedor
    FROM Proveedor
    WHERE nombre = 'Nestlé'
);

-- =====================================================
-- 21. CURDATE + campo calculado
-- Días transcurridos desde la venta
-- =====================================================
SELECT id_venta,
       fecha_venta,
       DATEDIFF(CURDATE(), fecha_venta) AS dias_desde_venta
FROM Ventas;


-- =====================================================
-- 22. BETWEEN sobre fechas
-- Ventas en un rango de fechas
-- =====================================================
SELECT id_venta, fecha_venta, total_final
FROM Ventas
WHERE fecha_venta BETWEEN '2025-01-03' AND '2025-01-07';


-- =====================================================
-- 23. IS NULL / IS NOT NULL
-- Ventas que tienen cliente asociado
-- =====================================================
SELECT id_venta, id_cliente, total_final
FROM Ventas
WHERE id_cliente IS NOT NULL;

-- =====================================================
-- 24. DISTINCT
-- Categorías sin repetir
-- =====================================================
SELECT DISTINCT categoria
FROM Productos;

-- =====================================================
-- 25. CASE WHEN
-- Clasificación de productos por precio
-- =====================================================
SELECT nombre_producto,
       precio_venta,
       CASE
           WHEN precio_venta < 1.50 THEN 'Barato'
           WHEN precio_venta BETWEEN 1.50 AND 2.50 THEN 'Normal'
           ELSE 'Caro'
       END AS clasificacion
FROM Productos;


-- =====================================================
-- 26. UNION
-- Unir nombres de clientes y proveedores
-- =====================================================
SELECT nombre FROM Cliente
UNION
SELECT nombre FROM Proveedor;


-- =====================================================
-- 27. EXISTS
-- Productos que han sido vendidos
-- =====================================================
SELECT nombre_producto
FROM Productos p
WHERE EXISTS (
    SELECT 1
    FROM DetalleVenta d
    WHERE d.id_producto = p.id_producto
);

-- =====================================================
--  28. Vista de productos que necesitan reposición
--  Muestra productos cuyo stock es menor o igual al mínimo
-- =====================================================

DROP VIEW IF EXISTS Vista_Productos_Stock_Minimo;

CREATE VIEW Vista_Productos_Stock_Minimo AS
SELECT 
    nombre_producto,
    stock_disponible,
    stock_minimo
FROM Productos
WHERE stock_disponible <= stock_minimo;

UPDATE Productos
SET stock_disponible = 5
WHERE id_producto = 8;


Select * From Vista_Productos_Stock_Minimo