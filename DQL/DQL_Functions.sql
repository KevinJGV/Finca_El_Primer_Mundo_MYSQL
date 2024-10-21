USE Finca_El_Primer_Mundo;

DELIMITER / /

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

CREATE FUNCTION TotalClientes()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TotalClientes';
    DECLARE Cantidad_Total INT;

    SELECT
        COUNT(ID) INTO Cantidad_Total
    FROM
        Clientes;
    
    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),"Contados Todos Los Clientes","Clientes");

    RETURN Cantidad_Total;
END//

SELECT TotalClientes();

-- 12. Calcular el total de ingresos generados en un mes.

CREATE FUNCTION TotalIngresosMesYAño(pMes INT,pAño INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TotalIngresosMesYAño';
    DECLARE Valor_ DECIMAL(9,2);

    SELECT
        SUM(Total) INTO Valor_
    FROM
        Ventas
    WHERE
        YEAR(Fecha) = pAño AND MONTH(Fecha) = pMes;

    IF pMes BETWEEN 1 AND 12 AND pAño <= CURDATE() THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),"Total de Ingresos en un Mes Calculado","Ventas");
    END IF;
    RETURN Valor_;
END//

SELECT TotalIngresosMesYAño(11,2024);

-- 13. Obtener el nombre completo del cliente que más ha comprado. (Según cantidad de productos)

CREATE FUNCTION NombreClienteMayorCompras()
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NombreClienteMayorCompras';
    DECLARE ID_ INT;
    DECLARE Nombre_ VARCHAR(50);

    SELECT
        ID INTO ID_
    FROM (
        SELECT
            C.ID,
            SUM(DV.Cantidad) AS Cantidades
        FROM
            Clientes C
            JOIN Ventas V ON C.ID = V.ID_Cliente
            JOIN Detalles_Ventas DV ON V.ID = DV.ID_Venta
        GROUP BY
            C.ID
        ORDER BY
            Cantidades DESC
        LIMIT 1
    ) AS SUB;

    SELECT
        Nombre INTO Nombre_
    FROM (
        SELECT
            CONCAT(C.Nombre, ' ',C.Apellido) AS Nombre,
            SUM(DV.Cantidad) AS Cantidades
        FROM
            Clientes C
            JOIN Ventas V ON C.ID = V.ID_Cliente
            JOIN Detalles_Ventas DV ON V.ID = DV.ID_Venta
        GROUP BY
            C.ID
        ORDER BY
            Cantidades DESC
        LIMIT 1
    ) AS SUB;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),"Nombre del Cliente con Mas Compras Obtenido","Clientes",ID_);
    RETURN Nombre_;
END//

SELECT NombreClienteMayorCompras();

-- 14. Calcular el monto total de una venta específica.

CREATE FUNCTION MontoTotalVenta(pVenta_ID INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'MontoTotalVenta';
    DECLARE Valor_ DECIMAL(9,2);
    SET @max_ID = 0;

    SELECT
        SUM(DV.Subtotal) INTO Valor_
    FROM
        Ventas V
        JOIN Detalles_Ventas DV ON V.ID = DV.ID_Venta
    WHERE
        V.ID = pVenta_ID;
    
    SELECT
        MAX(V.ID) INTO @max_ID
    FROM Ventas V;
    
    IF pVenta_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),"Monto Total de Venta Calculado","Ventas",pVenta_ID);
    END IF;
    RETURN Valor_;
END//

SELECT MontoTotalVenta(10000);

-- 15. Obtener el nombre del producto más vendido.
CREATE FUNCTION NombreProductoMasVendido()
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NombreProductoMasVendido';
    DECLARE ID_ INT;
    DECLARE Nombre_ VARCHAR(50);

    SELECT
        Nombre INTO Nombre_
    FROM (
        SELECT
            P.Nombre,
            SUM(DV.Cantidad) AS Cantidad
        FROM
            Productos P
            JOIN Detalles_Ventas DV ON P.ID = DV.ID_Producto
        GROUP BY
            Nombre
        ORDER BY
            Cantidad DESC
        LIMIT 1
    ) AS Sub;

    SELECT
        ID INTO ID_
    FROM (
        SELECT
            P.ID,
            SUM(DV.Cantidad) AS Cantidad
        FROM
            Productos P
            JOIN Detalles_Ventas DV ON P.ID = DV.ID_Producto
        GROUP BY
            ID
        ORDER BY
            Cantidad DESC
        LIMIT 1
    ) AS Sub;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),"Nombre del Producto Mas Caro Obtenido","Productos",ID_);
    RETURN Nombre_;
END//

SELECT NombreProductoMasVendido();

-- 16. Calcular el porcentaje de ventas de un empleado.
CREATE FUNCTION PorcentajeVentasxEmpleado(pEmpleado_ID INT)
RETURNS DECIMAL(3,1)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'PorcentajeVentasxEmpleado';
    DECLARE Porcentaje DECIMAL(3,1);
    DECLARE TOTAL_V INT;
    SET @max_ID = 0;

    SELECT
        COUNT(ID) INTO TOTAL_V
    FROM
        Ventas;
    
    SELECT
        ((COUNT(ID) / TOTAL_V) * 100) INTO Porcentaje
    FROM
        Ventas
    WHERE
        ID_Empleado = pEmpleado_ID;

    SELECT
        MAX(E.ID) INTO @max_ID
    FROM Empleados E;

    IF pID_Empleado <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),"Porcentaje de Ventas por Empleado Obtenido","Ventas",pEmpleado_ID);
    END IF;
    RETURN Porcentaje;
END//

SELECT PorcentajeVentasxEmpleado(3);

-- 17. Obtener el nombre del producto más caro.
CREATE FUNCTION NombreProductoMasCaro()
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NombreProductoMasCaro';
    DECLARE ID_ INT;
    DECLARE Nombre_ VARCHAR(50);

    SELECT
        ID INTO ID_
    FROM
        Productos
    ORDER BY
        Valor DESC
    LIMIT 1;

    SELECT
        Nombre INTO Nombre_
    FROM
        Productos
    ORDER BY
        Valor DESC
    LIMIT 1;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),"Nombre del Producto Mas Caro Obtenido","Productos",ID_);
    RETURN Nombre_;
END//

SELECT NombreProductoMasCaro();
-- 18. Obtener el número total de tipos registrados.
DELIMITER //
CREATE FUNCTION CantidadTipos()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TodosLosTipos';
    DECLARE Cantidad_Total INT DEFAULT 0;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM tipos_empleados T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM tipos_productos T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM tipos_proveedores T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM tipos_recursos T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM tipos_tareas T;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),"Contados Todos Los Tipos","Tablas 'Tipos_'");

    RETURN Cantidad_Total;
END//

SELECT CantidadTipos();

-- 19. Obtener el producto menos vendido.
DELIMITER //
CREATE FUNCTION ProductoMenosVendido()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ProductoMenosVendido';
    DECLARE ID_ INT;

    SELECT
        ID_P INTO ID_
    FROM 
        (
            SELECT
                DV.ID_Producto AS ID_P,
                SUM(DV.Cantidad) AS Cantidad
            FROM
                Productos P
            JOIN Detalles_Ventas DV ON P.ID = DV.ID_Producto
            GROUP BY
                ID_P
            ORDER BY
                Cantidad ASC
            LIMIT 1
        ) AS S;
    
    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),"Producto Menos Vendido Obtenido","Detalles_Ventas",ID_);

    RETURN ID_;
END//

SELECT ProductoMenosVendido();
-- 20. Calcular el total de ganancias de un empleado.
DELIMITER //

CREATE FUNCTION CalcularGananciasEmpleado(pID_Empleado INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'CalcularGananciasEmpleado';
    DECLARE Total DECIMAL(9,2);
    DECLARE Meses INT;
    SET @max_ID = 0;

    SELECT
        CASE
            WHEN E.ID_Estado = 2 THEN
            (SELECT
                TIMESTAMPDIFF(MONTH,E.Fecha_Contratacion,Fecha)
            FROM Logs
            WHERE
                Detalles = "Empleado desactivado" AND ID_Referencia = pID_Empleado
            ORDER BY
                Fecha ASC
            LIMIT 1)
            ELSE TIMESTAMPDIFF(MONTH,E.Fecha_Contratacion,NOW())
        END INTO Meses
    FROM Empleados E
    WHERE E.ID = pID_Empleado;

    SELECT
        E.Salario * Meses INTO Total
    FROM Empleados E
    WHERE E.ID = pID_Empleado;

    SELECT
        MAX(E.ID) INTO @max_ID
    FROM Empleados E;

    IF pID_Empleado <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),"Ganancias Totales de Usuario Calculado","Empleados",pID_Empleado);
    END IF;

    RETURN Total;
END//

SELECT CalcularGananciasEmpleado (1);

DELIMITER;