USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Insertar nuevo cliente.
-- Inserta un nuevo cliente a la base de datos.
CREATE PROCEDURE InsertarClinte (IN Nombre VARCHAR(50),IN Apellido VARCHAR(50), IN FechaNacimiento DATE, IN Telefono BIGINT, IN ID_Descuento INT, IN ID_Estado INT, IN ID_Ciudad INT)
BEGIN
    INSERT INTO Clientes (Nombre, Apellido, Fecha_Nacimiento, Telefono, ID_Descuento, ID_Estado, ID_Ciudad)
    VALUES (Nombre, Apellido, FechaNacimiento, Telefono, ID_Descuento, ID_Estado, ID_Ciudad);
END//
-- CALL InsertarClinte('Edgan','Quintero','1970-12-01',30119072312,4,2,17);
-- By @JavierEAcevedoN

-- 2. Actualizar datos de un cliente.
-- Actualiza los datos de un cliente por medio de la ID de este.
CREATE PROCEDURE ActualizarCliente (IN ID_Cliente INT, IN Nombre VARCHAR(50),IN Apellido VARCHAR(50), IN FechaNacimiento DATE, IN Telefono BIGINT, IN ID_Descuento INT, IN ID_Estado INT, IN ID_Ciudad INT)
BEGIN
    UPDATE Clientes
    SET Nombre = Nombre,
    Apellido = Apellido,
    Fecha_Nacimiento = FechaNacimiento,
    Telefono = Telefono,
    ID_Descuento = ID_Descuento,
    ID_Estado = ID_Estado,
    ID_Ciudad = ID_Ciudad
    WHERE ID = ID_Cliente;
END//
-- CALL ActualizarCliente(47,'Edgan','Quintero','1970-12-01',30119072312,4,2,17);
-- By @JavierEAcevedoN

-- 3. Eliminar cliente.
-- Elimina un cliente por medio de la ID de este.
CREATE PROCEDURE EliminarCliente (IN ID_Cliente INT)
BEGIN
    DELETE FROM Clientes WHERE ID = ID_Cliente;
END//
-- CALL EliminarCliente(51);
-- By @JavierEAcevedoN

-- 4. Insertar nuevo producto.
-- Inserta un nuevo producto.
CREATE PROCEDURE InsertarProducto (IN Nombre VARCHAR(50), IN Stock INT, IN Valor DECIMAL(9,2), IN Costo DECIMAL(9,2), IN ID_Descuento INT, IN ID_Estado INT, IN ID_Tipo_Producto INT, IN ID_Lote INT, IN ID_Recurso INT)
BEGIN
    INSERT INTO Productos (Nombre, Stock, Valor, Costo, ID_Descuento, ID_Estado, ID_Tipo_Producto, ID_Lote, ID_Recurso)
    VALUES (Nombre, Stock, Valor, Costo, ID_Descuento, ID_Estado, ID_Tipo_Producto, ID_Lote, ID_Recurso);
END//
-- CALL InsertarProducto ('Cookie', 45,42.35,24.99,1,1,12,16,42);
-- By @JavierEAcevedoN

-- 5. Actualizar datos de un producto.
-- Actualiza un producto por medio de la ID de este.
CREATE PROCEDURE ActualizarProducto (IN ID_Producto INT, IN Nombre VARCHAR(50), IN Stock INT, IN Valor DECIMAL(9,2), IN Costo DECIMAL(9,2), IN ID_Descuento INT, IN ID_Estado INT, IN ID_Tipo_Producto INT, IN ID_Lote INT, IN ID_Recurso INT)
BEGIN
    UPDATE Productos
    SET Nombre = Nombre,
    Stock = Stock,
    Valor = Valor,
    Costo = Costo,
    ID_Descuento = ID_Descuento,
    ID_Estado = ID_Estado,
    ID_Tipo_Producto = ID_Tipo_Producto,
    ID_Lote = ID_Lote,
    ID_Recurso = ID_Recurso
    WHERE ID = ID_Producto;
END//
-- CALL ActualizarProducto (52,'Cookie',45,42.35,24.99,1,1,12,16,42);
-- By @JavierEAcevedoN

-- 6. Obtener productos por tipo de producto.
-- Obtiene los productos por medio del nombre del tipo de producto. 
CREATE PROCEDURE ObtenerPorTipoProducto (IN TipoProducto VARCHAR(50))
BEGIN
    SELECT
        pr.Nombre,
        pr.Stock,
        pr.Valor,
        pr.Costo,
        tp.Tipo
    FROM Productos pr
    INNER JOIN Tipos_Productos tp ON pr.ID_Tipo_Producto = tp.ID
    WHERE tp.Tipo = TipoProducto;
END//
-- CALL ObtenerPorTipoProducto("Carne");
-- By @JavierEAcevedoN

-- 7. Insertar nueva venta.
-- Inserta una nueva venta.
CREATE PROCEDURE InsesrtarVenta (IN Fecha DATE, IN Total DECIMAL(9,2), IN ID_Cliente INT, IN ID_Empleado INT, IN ID_Medio_de_Pago INT)
BEGIN
    INSERT INTO Ventas (Fecha, Total, ID_Cliente, ID_Empleado, ID_Medio_de_Pago)
    VALUES (Fecha, Total, ID_Cliente, ID_Empleado, ID_Medio_de_Pago);
END//
-- CALL InsesrtarVenta (DATE(NOW()),122.75,43,45,6);
-- By @JavierEAcevedoN

-- 8. Obtener ventas de un cliente.
-- Obtiene las ventas que ha heacho un cliente.
CREATE PROCEDURE ObtenerVentasCliente (IN ID_Cliente INT)
BEGIN
    SELECT
        CONCAT(cl.Nombre," ",cl.Apellido) AS NombreCompleto,
        ve.Fecha,
        ve.Total,
        pr.Nombre AS Producto
    FROM Ventas ve
    INNER JOIN Clientes cl ON ve.ID_Cliente = cl.ID
    INNER JOIN Detalles_Ventas dv ON ve.ID = dv.ID_Venta
    INNER JOIN Productos pr ON dv.ID_Producto = pr.ID
    WHERE ve.ID_Cliente = ID_Cliente;
END//
-- CALL ObtenerVentasCliente(1);
-- By @JavierEAcevedoN

-- 9. Obtener ventas por empleado.
-- Obtiene las ventas que ha hecho un empleado.
CREATE PROCEDURE ObtenerVentasEmpleado (IN ID_Empleado INT)
BEGIN
    SELECT
        CONCAT(em.Nombre," ",em.Apellido) AS NombreCompletoEmpleado,
        ve.Fecha,
        ve.Total,
        CONCAT(cl.Nombre," ",cl.Apellido) AS NombreCompletoCliente,
        mp.Tipo AS MedioDePago
    FROM Ventas ve
    INNER JOIN Empleados em ON ve.ID_Empleado = em.ID
    INNER JOIN Clientes cl ON ve.ID_Cliente = cl.ID
    INNER JOIN Medios_de_Pago mp ON ve.ID_Medio_de_Pago = mp.ID
    WHERE ve.ID_Empleado = ID_Empleado;
END//

-- CALL ObtenerVentasEmpleado(1);
-- By @JavierEAcevedoN

-- 10. Insertar nuevo tipo de producto.
-- Inserta un nuevo tipo de producto.
CREATE PROCEDURE InsetarTipoProducto (IN TipoProducto VARCHAR(50))
BEGIN
    INSERT INTO Tipos_Productos (Tipo)
    VALUES (TipoProducto);
END//
-- CALL InsetarTipoProducto ("Cookie");
-- By @JavierEAcevedoN

-- 11. Actualizar una categoría.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 12. Obtener clientes por rango de fechas de registro.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 13. Obtener total de ventas por cliente.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 14. Obtener total de ventas por empleado.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 15. Eliminar producto.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 16. Eliminar una venta.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 17. Obtener productos por precio mínimo y máximo.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 18. Obtener ventas por rango de fechas.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 19. Obtener cantidad total de productos vendidos por categoría.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

-- 20. Generar reporte de ventas mensuales.
CREATE PROCEDURE nombreprocedimiento (IN parametro INT)
BEGIN
    -- CODE
END//

DELIMITER ;