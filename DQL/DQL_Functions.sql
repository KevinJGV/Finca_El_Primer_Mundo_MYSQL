USE Finca_El_Primer_Mundo;

DELIMITER / /

-- 1. Obtener el nombre completo del cliente.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 2. Calcular el total de ventas de un cliente.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 3. Obtener el precio de un producto.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 4. Calcular el total de productos vendidos en una venta.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 5. Obtener el nombre de la categoría de un producto.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 6. Calcular el descuento aplicado a una venta.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 7. Obtener el empleado que realizó la venta.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 8. Calcular el precio total de un producto con impuestos.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 9. Obtener el número de ventas realizadas por un empleado.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 10. Calcular el promedio de precios de los productos de una categoría.

CREATE FUNCTION nombrefuncion(parametros INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- CODE
END//

-- 11. Obtener el número total de clientes registrados.
DELIMITER //
CREATE FUNCTION TotalClientes()
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TotalClientes';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Clientes";
    DECLARE Detalle TEXT DEFAULT 'Contados Todos Los Clientes';
    DECLARE Cantidad_Total INT;

    SELECT
        COUNT(ID) INTO Cantidad_Total
    FROM
        Clientes;
    
    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);

    RETURN Cantidad_Total;
END//

SELECT TotalClientes();

-- 12. Calcular el total de ingresos generados en un mes.
DELIMITER //
CREATE FUNCTION TotalIngresosMesYAño(pMes INT,pAño INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TotalIngresosMesYAño';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Ventas";
    DECLARE Detalle TEXT DEFAULT 'Total de Ingresos en un Mes Calculado';
    DECLARE Valor_ DECIMAL(9,2);

    SELECT
        SUM(Total) INTO Valor_
    FROM
        Ventas
    WHERE
        YEAR(Fecha) = pAño AND MONTH(Fecha) = pMes;

    IF pMes BETWEEN 1 AND 12 AND pAño <= CURDATE() THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
    END IF;
    RETURN Valor_;
END//

SELECT TotalIngresosMesYAño(11,2024);

-- 13. Obtener el nombre completo del cliente que más ha comprado. (Según cantidad de productos)
DELIMITER //
CREATE FUNCTION NombreClienteMayorCompras()
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NombreClienteMayorCompras';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Clientes";
    DECLARE Detalle TEXT DEFAULT 'Nombre del Cliente con Mas Compras Obtenido';
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
    ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,ID_);
    RETURN Nombre_;
END//

SELECT NombreClienteMayorCompras();

-- 14. Calcular el monto total de una venta específica.
DELIMITER //
CREATE FUNCTION MontoTotalVenta(pVenta_ID INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'MontoTotalVenta';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Ventas";
    DECLARE Detalle TEXT DEFAULT 'Monto Total de Venta Calculado';
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
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pVenta_ID);
    END IF;
    RETURN Valor_;
END//

SELECT MontoTotalVenta(10000);

-- 15. Obtener el nombre del producto más vendido.
DELIMITER //
CREATE FUNCTION NombreProductoMasVendido()
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NombreProductoMasVendido';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Productos";
    DECLARE Detalle TEXT DEFAULT 'Nombre del Producto Mas Caro Obtenido';
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
    ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,ID_);
    RETURN Nombre_;
END//

SELECT NombreProductoMasVendido();

-- 16. Calcular el porcentaje de ventas de un empleado.
DELIMITER //
CREATE FUNCTION PorcentajeVentasxEmpleado(pEmpleado_ID INT)
RETURNS DECIMAL(3,1)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'PorcentajeVentasxEmpleado';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Ventas";
    DECLARE Detalle TEXT DEFAULT 'Porcentaje de Ventas por Empleado Obtenido';
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

    IF pEmpleado_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pEmpleado_ID);
    END IF;
    RETURN Porcentaje;
END//

SELECT PorcentajeVentasxEmpleado(1);

-- 17. Obtener el nombre del producto más caro.
DELIMITER //
CREATE FUNCTION NombreProductoMasCaro()
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NombreProductoMasCaro';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Productos";
    DECLARE Detalle TEXT DEFAULT 'Nombre del Producto Mas Caro Obtenido';
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
    ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,ID_);
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
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Tablas 'Tipos_'";
    DECLARE Detalle TEXT DEFAULT 'Contados Todos Los Tipos';
    DECLARE Cantidad_Total INT DEFAULT 0;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM Tipos_Empleados T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM Tipos_Productos T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM Tipos_Proveedores T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM Tipos_Recursos T;

    SELECT
        (COUNT(T.ID) + Cantidad_Total) INTO Cantidad_Total
    FROM Tipos_Tareas T;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);

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
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Detalles_Ventas';
    DECLARE Detalle TEXT DEFAULT 'Producto Menos Vendido Obtenido';
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
    ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,ID_);

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
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Empleados';
    DECLARE Detalle TEXT DEFAULT 'Ganancias Totales de Usuario Calculado';
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
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pID_Empleado);
    END IF;

    RETURN Total;
END//

SELECT CalcularGananciasEmpleado (1);

-- 20. Obtener nombre de recursos segun ID.

CREATE FUNCTION ObtenerTipoRecurso(pRecurso_ID INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ObtenerTipoRecurso';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Tipos_Recursos';
    DECLARE Detalle TEXT DEFAULT 'Obtenido Tipo de Recurso.';
    DECLARE Nombre_ VARCHAR(50);
    SET @max_ID = 0;

    SELECT
        Tipo INTO Nombre_
    FROM
        Tipos_Recursos
    WHERE
        ID = pRecurso_ID;

    SELECT
        MAX(R.ID) INTO @max_ID
    FROM
        Tipos_Recursos R;

    IF pRecurso_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pRecurso_ID);
    END IF;

    RETURN Nombre_;
END //

select ObtenerTipoRecurso(2);
DELIMITER;