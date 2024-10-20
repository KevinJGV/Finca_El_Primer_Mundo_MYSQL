USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Obtener el nombre completo del cliente.
-- Obtiene el nombre completo del cliente por medio de su ID.
CREATE FUNCTION NombreCompletoCliente(ID_Cliente INT)
RETURNS VARCHAR(105)
DETERMINISTIC
BEGIN
    DECLARE NombreCompleto VARCHAR(105);

    SELECT
        CONCAT(Nombre," ",Apellido)
    INTO NombreCompleto
    FROM clientes
    WHERE ID = ID_Cliente;

    RETURN NombreCompleto;
END//
-- SELECT NombreCompletoCliente(1);
-- By @JavierEAcevedoN

-- 2. Calcular el total de ventas de un cliente.
-- Calcula el total de ventas que ha hecho un cliente por medio de su ID.
CREATE FUNCTION TotalVentasCliente(ID_Cliente INT)
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE Subtotal DECIMAL(9,2);

    SELECT
        SUM(dv.Subtotal)
    INTO Subtotal
    FROM Ventas ve
    INNER JOIN detalles_ventas dv ON ve.ID = dv.ID_Venta
    WHERE ve.ID_Cliente = ID_Cliente
    GROUP BY ve.ID_Cliente;

    RETURN Subtotal;
END//
-- SELECT TotalVentasCliente(1);
-- By @JavierEAcevedoN

-- 3. Obtener el precio de un producto.
-- Obtiene el precio del una producto por medio de su ID.
CREATE FUNCTION ObtenerPrecioproducto(ID_Producto INT)
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE Precio DECIMAL(9,2);

    SELECT
        Valor
    INTO Precio
    FROM productos
    WHERE ID = ID_Producto;

    RETURN Precio;
END//
-- SELECT ObtenerPrecioproducto(1);
-- By @JavierEAcevedoN

-- 4. Calcular el total de productos vendidos en una venta.
-- Calcula el total de ventas de una venta por medio de su ID.
CREATE FUNCTION TotalProductosVenta(Venta_ID INT)
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE Total DECIMAL(9,2);

    SELECT
        SUM(Subtotal)
    INTO Total
    FROM detalles_ventas
    WHERE ID_Venta = Venta_ID
    GROUP BY ID_Venta;

    RETURN Total;
END//
-- SELECT TotalProductosVenta(2);
-- By @JavierEAcevedoN

-- 5. Obtener el nombre del tipo de un producto.
-- Obtiene el tipo de producto por medio de su ID.
CREATE FUNCTION ObtenerTipoProducto(ID_Producto INT)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    DECLARE TipoProducto VARCHAR(50);

    SELECT
        tp.Tipo
    INTO TipoProducto
    FROM productos pr
    INNER JOIN tipos_productos tp ON pr.ID_Tipo_Producto = tp.ID
    WHERE pr.ID = ID_Producto;

    RETURN TipoProducto;
END//
-- SELECT ObtenerTipoProducto(2);
-- By @JavierEAcevedoN

-- 6. Calcular el descuento aplicado a un producto.
-- Se calcula el descuento de un producto por medio de su ID.
CREATE FUNCTION CalcularDescuentoProducto(ID_Producto INT)
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE Precio DECIMAL(9,2);
    DECLARE Descuento DECIMAL(9,2);

    SELECT
        pr.Valor,
        ds.Valor
    INTO
        Precio,
        Descuento
    FROM productos pr
    INNER JOIN descuentos ds ON pr.ID_Descuento = ds.ID
    WHERE pr.ID = ID_Producto;

    RETURN (Precio - (Precio * (Descuento/100)));
END//
-- SELECT CalcularDescuentoProducto(8);
-- By @JavierEAcevedoN

-- 7. Obtener el empleado que realizó la venta.
-- Se obtiene el nombre del empleado que realizo la venta, la venta se selecciona por medio de su ID.
CREATE FUNCTION NombreEmpledoVenta(ID_Venta INT)
RETURNS VARCHAR(105)
DETERMINISTIC
BEGIN
    DECLARE NombreCompleto VARCHAR(105);

    SELECT
        CONCAT(em.Nombre," ",em.Apellido)
    INTO NombreCompleto
    FROM Ventas ve
    INNER JOIN empleados em ON ve.ID_Empleado = em.ID
    WHERE ve.ID = ID_Venta;

    RETURN NombreCompleto;
END//
-- SELECT NombreEmpledoVenta(2);
-- By @JavierEAcevedoN

-- 8. Calcular el precio total de un producto si se le aplica un impuesto (19%).
-- Se calcula el suma el impuesto del 19% al precio del producto por medio de su ID.
CREATE FUNCTION CalcularImpuestoProducto(ID_Producto INT)
RETURNS DECIMAL(9,2)
DETERMINISTIC
BEGIN
    DECLARE Precio DECIMAL(9,2);

    SELECT
        Valor
    INTO
        Precio
    FROM productos
    WHERE ID = ID_Producto;

    RETURN (Precio + (Precio * (19/100)));
END//
-- SELECT CalcularImpuestoProducto(43);
-- By @JavierEAcevedoN

-- 9. Obtener el número de ventas realizadas por un empleado.
-- Calcula la cantidad de productos por un empleado pormedio de su ID.
CREATE FUNCTION NumeroVentasEmpleado(Empleado_ID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE Total INT;

    SELECT
        COUNT(ID)
    INTO Total
    FROM Ventas
    WHERE ID_Empleado = Empleado_ID;

    RETURN Total;
END//
-- SELECT NumeroVentasEmpleado(1);
-- By @JavierEAcevedoN

-- 10. Calcular el promedio de precios de los productos de un tipo.
-- Se calcula el promedio de productos por medio del tipo, el tipo se selecciona por medio de nombre.
CREATE FUNCTION PromedioProductosTipo(TipoProducto VARCHAR(50))
RETURNS DECIMAL (9,2)
DETERMINISTIC
BEGIN
    DECLARE Promedio DECIMAL(9,2);

    SELECT
        AVG(pr.`Valor`)
    INTO Promedio
    FROM productos pr
    INNER JOIN tipos_productos tp ON pr.ID_Tipo_Producto = tp.ID
    WHERE tp.Tipo = TipoProducto;

    RETURN Promedio;
END//
-- SELECT PromedioProductosTipo("Lacteo");
-- By @JavierEAcevedoN

-- 11. Obtener el número total de clientes registrados.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 12. Calcular el total de ingresos generados en un mes.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 13. Obtener el nombre del cliente que más ha comprado.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 14. Calcular el monto total de una venta específica.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 15. Obtener el nombre del producto más vendido.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 16. Calcular el porcentaje de ventas de un empleado.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 17. Obtener el nombre del producto más caro.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 18. Obtener el número total de categorías.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 19. Obtener el producto menos vendido.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 20. Calcular el total de ganancias de un empleado.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS retorno INT
DETERMINISTIC
BEGIN
    -- CODE
END//

DELIMITER ;