
Create DATABASE Minimarket;

Show DATABASES

Use Minimarket;

Create table Productos
(id_producto INT PRIMARY KEY,
  nombre_producto VARCHAR(150),
  categoria VARCHAR(50),
  unidad_medida VARCHAR(20),
  precio_venta DECIMAL(10,2),
  costo_compra DECIMAL(10,2),
  stock_disponible INT,
  stock_minimo INT,
  id_proveedor INT
);

CREATE TABLE Cliente (
  id_cliente INT PRIMARY KEY,
  nombre VARCHAR(200),
  tipo_cliente VARCHAR(30),
  telefono VARCHAR(20),
  correo VARCHAR(100),
  direccion VARCHAR(255)
);

CREATE TABLE Ventas (
  id_venta INT PRIMARY KEY,
  id_cliente INT NULL,
  fecha_venta DATETIME,
  forma_pago VARCHAR(20),
  subtotal DECIMAL(12,2),
  impuestos DECIMAL(12,2),
  total_final DECIMAL(12,2)
);

CREATE TABLE DetalleVenta (
  id_detalle INT PRIMARY KEY,
  id_venta INT,
  id_producto INT,
  cantidad_vendida INT,
  precio_unitario DECIMAL(10,2),
  subtotal_detalle DECIMAL(12,2)
);


SELECT * FROM Productos;
SELECT * FROM Cliente;
SELECT * FROM Ventas;
SELECT * FROM DetalleVenta;
  

  Drop table DetalleVenta
