USE Finca_El_Primer_Mundo;

DELIMITER / /

-- 1. Obtener el nombre completo del cliente.
-- Obtiene el nombre completo del cliente por medio de su ID.
CREATE FUNCTION NombreCompletoCliente(ID_Cliente INT)
RETURNS VARCHAR(105)
READS SQL DATA
BEGIN
    DECLARE NombreCompleto VARCHAR(105);

    SELECT
        CONCAT(Nombre," ",Apellido)
    INTO NombreCompleto
    FROM Clientes
    WHERE ID = ID_Cliente;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "NombreCompletoCliente",
            NOW(),
            USER(),
            "Se utilizo la funcion para mostrar el nombre completo de un cliente",
            "Clientes"
        );

    RETURN NombreCompleto;
END//
-- SELECT NombreCompletoCliente(1);
-- By @JavierEAcevedoN

-- 2. Calcular el total de ventas de un cliente.
-- Calcula el total de ventas que ha hecho un cliente por medio de su ID.
CREATE FUNCTION TotalVentasCliente(ID_Cliente INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Subtotal DECIMAL(9,2);

    SELECT
        SUM(dv.Subtotal)
    INTO Subtotal
    FROM Ventas ve
    INNER JOIN Detalles_Ventas dv ON ve.ID = dv.ID_Venta
    WHERE ve.ID_Cliente = ID_Cliente
    GROUP BY ve.ID_Cliente;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "TotalVentasCliente",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular el total de ventas de un cliente",
            "Ventas"
        );
    
    RETURN Subtotal;
END//
-- SELECT TotalVentasCliente(1);
-- By @JavierEAcevedoN

-- 3. Obtener el precio de un producto.
-- Obtiene el precio del una producto por medio de su ID.
CREATE FUNCTION ObtenerPrecioproducto(ID_Producto INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Precio DECIMAL(9,2);

    SELECT
        Valor
    INTO Precio
    FROM Productos
    WHERE ID = ID_Producto;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "ObtenerPrecioproducto",
            NOW(),
            USER(),
            "Se utilizo la funcion para obtener el precio de un producto",
            "Producto"
        );

    RETURN Precio;
END//
-- SELECT ObtenerPrecioproducto(1);
-- By @JavierEAcevedoN

-- 4. Calcular el total de productos vendidos en una venta.
-- Calcula el total de ventas de una venta por medio de su ID.
CREATE FUNCTION TotalProductosVenta(Venta_ID INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Total DECIMAL(9,2);

    SELECT
        SUM(Subtotal)
    INTO Total
    FROM Detalles_Ventas
    WHERE ID_Venta = Venta_ID
    GROUP BY ID_Venta;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "TotalProductosVenta",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular el total de detalles de venta de una venta",
            "Venta"
        );

    RETURN Total;
END//
-- SELECT TotalProductosVenta(2);
-- By @JavierEAcevedoN

-- 5. Obtener el nombre del tipo de un producto.
-- Obtiene el tipo de producto por medio de su ID.
CREATE FUNCTION ObtenerTipoProducto(ID_Producto INT)
RETURNS VARCHAR(50)
READS SQL DATA
BEGIN
    DECLARE TipoProducto VARCHAR(50);

    SELECT
        tp.Tipo
    INTO TipoProducto
    FROM Productos pr
    INNER JOIN Tipos_Productos tp ON pr.ID_Tipo_Producto = tp.ID
    WHERE pr.ID = ID_Producto;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "ObtenerTipoProducto",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular el total de detalles de venta de una venta",
            "Tipos_Productos"
        );

    RETURN TipoProducto;
END//
-- SELECT ObtenerTipoProducto(2);
-- By @JavierEAcevedoN

-- 6. Calcular el descuento aplicado a un producto.
-- Se calcula el descuento de un producto por medio de su ID.
CREATE FUNCTION CalcularDescuentoProducto(ID_Producto INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Precio DECIMAL(9,2);
    DECLARE Descuento DECIMAL(9,2);

    SELECT
        pr.Valor,
        ds.Valor
    INTO
        Precio,
        Descuento
    FROM Productos pr
    INNER JOIN Descuentos ds ON pr.ID_Descuento = ds.ID
    WHERE pr.ID = ID_Producto;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "CalcularDescuentoProducto",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular el descuento del precio de un producto",
            "Productos"
        );

    RETURN (Precio - (Precio * (Descuento/100)));
END//
-- SELECT CalcularDescuentoProducto(8);
-- By @JavierEAcevedoN

-- 7. Obtener el empleado que realizó la venta.
-- Se obtiene el nombre del empleado que realizo la venta, la venta se selecciona por medio de su ID.
CREATE FUNCTION NombreEmpledoVenta(ID_Venta INT)
RETURNS VARCHAR(105)
READS SQL DATA
BEGIN
    DECLARE NombreCompleto VARCHAR(105);

    SELECT
        CONCAT(em.Nombre," ",em.Apellido)
    INTO NombreCompleto
    FROM Ventas ve
    INNER JOIN Empleados em ON ve.ID_Empleado = em.ID
    WHERE ve.ID = ID_Venta;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "NombreEmpledoVenta",
            NOW(),
            USER(),
            "Se utilizo la funcion para obtener el nombre del empleado que hizo la venta",
            "Empleados"
        );

    RETURN NombreCompleto;
END//
-- SELECT NombreEmpledoVenta(2);
-- By @JavierEAcevedoN

-- 8. Calcular el precio total de un producto si se le aplica un impuesto (19%).
-- Se calcula el suma el impuesto del 19% al precio del producto por medio de su ID.
CREATE FUNCTION CalcularImpuestoProducto(ID_Producto INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE Precio DECIMAL(9,2);

    SELECT
        Valor
    INTO
        Precio
    FROM Productos
    WHERE ID = ID_Producto;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "CalcularImpuestoProducto",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular el precio de un producto aplicandole el impuesto",
            "Productos"
        );

    RETURN (Precio + (Precio * (19/100)));
END//
-- SELECT CalcularImpuestoProducto(43);
-- By @JavierEAcevedoN

-- 9. Obtener el número de ventas realizadas por un empleado.
-- Calcula la cantidad de productos por un empleado pormedio de su ID.
CREATE FUNCTION NumeroVentasEmpleado(Empleado_ID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE Total INT;

    SELECT
        COUNT(ID)
    INTO Total
    FROM Ventas
    WHERE ID_Empleado = Empleado_ID;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "NumeroVentasEmpleado",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular la cantidad de ventas de un empleado",
            "Empleado"
        );

    RETURN Total;
END//
-- SELECT NumeroVentasEmpleado(1);
-- By @JavierEAcevedoN

-- 10. Calcular el promedio de precios de los productos de un tipo.
-- Se calcula el promedio de productos por medio del tipo, el tipo se selecciona por medio de nombre.
CREATE FUNCTION PromedioProductosTipo(TipoProducto VARCHAR(50))
RETURNS DECIMAL (9,2)
READS SQL DATA
BEGIN
    DECLARE Promedio DECIMAL(9,2);

    SELECT
        AVG(pr.Valor)
    INTO Promedio
    FROM Productos pr
    INNER JOIN Tipos_Productos tp ON pr.ID_Tipo_Producto = tp.ID
    WHERE tp.Tipo = TipoProducto;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada
        ) 
        VALUES
        (
            "FUNCION",
            "PromedioProductosTipo",
            NOW(),
            USER(),
            "Se utilizo la funcion para calcular el promedio del precio de productos por medio de su tipo",
            "Empleado"
        );

    RETURN Promedio;
END//
-- SELECT PromedioProductosTipo("Lacteo");
-- By @JavierEAcevedoN

-- 11. Obtener el número total de clientes registrados.
-- Contar la cantidad total de clientes registrados en la base de datos.
-- By @KevinGV
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

-- 12. Calcular el total de ingresos generados en un mes.
-- Sumar el total de ingresos generados en un mes específico.
-- By @KevinGV
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

-- 13. Obtener el nombre completo del cliente que más ha comprado. (Según cantidad de productos)
-- Retorna el nombre completo del cliente que más ha comprado en cantidad de productos.
-- By @KevinGV
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

-- 14. Calcular el monto total de una venta específica.
-- By @KevinGV
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

-- 15. Obtener el nombre del producto más vendido.
-- By @KevinGV
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

-- 16. Calcular el porcentaje de ventas de un empleado.
-- By @KevinGV
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

-- 17. Obtener el nombre del producto más caro.
-- By @KevinGV
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

-- 18. Obtener el número total de tipos registrados.
-- By @KevinGV
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

-- 19. Obtener el producto menos vendido.
-- By @KevinGV
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

-- 20. Calcular el total de ganancias de un empleado.
-- By @KevinGV
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

-- 21. Obtener nombre de recursos segun ID.
-- By @KevinGV
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

-- 22. Obtener el número de ventas realizadas por un cliente.
-- By @KevinGV
CREATE FUNCTION NumeroVentasCliente(pCliente_ID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NumeroVentasCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT 'Numero de ventas por Cliente Obtenido';
    DECLARE Nombre_ VARCHAR(50);
    DECLARE Total INT;
    SET @max_ID = 0;

    SELECT
        COUNT(ID) INTO Total
    FROM Ventas
    WHERE ID_Cliente = pCliente_ID;

    SELECT
        MAX(ID) INTO @max_ID
    FROM
        Clientes;

    IF pCliente_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pCliente_ID);
    END IF;

    RETURN Total;
END//

-- 23. Obtener el precio unitario de un recurso
-- By @KevinGV
CREATE FUNCTION ObtenerPrecioUnitario(pRecurso_ID INT)
RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ObtenerPrecioUnitario';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Recursos';
    DECLARE Detalle TEXT DEFAULT 'Valor unitario de recurso Obtenido';
    DECLARE Valor DECIMAL(9,2);
    SET @max_ID = 0;

    SELECT
        Precio_Unitario INTO Valor
    FROM
        Detalles_Compras
    WHERE
        ID_Recurso = pRecurso_ID
    ORDER BY
        Valor DESC
    LIMIT 1;

    SELECT
        MAX(ID) INTO @max_ID
    FROM
        Recursos;

    IF pRecurso_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pRecurso_ID);
    END IF;

    RETURN Valor;
END //

-- 24. Obtener antiguedad de cliente
-- By @KevinGV
CREATE FUNCTION AntiguedadCliente(pClientes_ID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'AntiguedadCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Ventas';
    DECLARE Detalle TEXT DEFAULT 'Fecha de antiguedad segun Cliente Obtenida';
    DECLARE Fecha_ DATE;
    DECLARE Meses INT;
    SET @max_ID = 0;

    SELECT
        MAX(Fecha) INTO Fecha_
    FROM
        Logs
    WHERE
        Detalles = "Cliente Activado" AND ID_Referencia = pClientes_ID;

    IF Fecha_ IS NULL THEN
        SELECT
            MIN(Fecha) INTO Fecha_
        FROM
            Ventas
        WHERE
            ID_Cliente = pClientes_ID;
    END IF;

    IF Fecha_ IS NOT NULL THEN
        SET Meses = TIMESTAMPDIFF(MONTH, Fecha_, NOW());
    END IF;

    SELECT
        MAX(ID) INTO @max_ID
    FROM
        Clientes;

    IF pClientes_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pClientes_ID);
    END IF;

    RETURN Meses;
END //

-- 25. Obtener ultima venta de un cliente
-- By @KevinGV
CREATE FUNCTION FechaUltimaVentaCliente(pCliente_ID INT)
RETURNS DATE
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'FechaUltimaVentaCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Venta';
    DECLARE Detalle TEXT DEFAULT 'Fecha de Ultima Venta segun Cliente Obtenida';
    DECLARE Fecha_ DATE;
    SET @max_ID = 0;

    SELECT
        MAX(Fecha) INTO Fecha_
    FROM
        Ventas
    WHERE
        ID_Cliente = pCliente_ID;

    SELECT
        MAX(ID) INTO @max_ID
    FROM
        Clientes;

    IF pCliente_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pCliente_ID);
    END IF;

    RETURN Fecha_;
END //

-- 26. Obtener el id tipo de empleado
-- By @KevinGV
CREATE FUNCTION ObtenerTipoEmpledo(pEmpleado_ID INT)
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ObtenerTipoEmpledo';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Empleado';
    DECLARE Detalle TEXT DEFAULT 'Tipo de empleado Obtenido';
    DECLARE Tipo_ INT;

    SELECT
        ID_Tipo_Empleado INTO Tipo_
    FROM
        Empleados
    WHERE
        ID = pEmpleado_ID;
    
    SELECT
        MAX(ID) INTO @max_ID
    FROM
        Empleados;

    IF pEmpleado_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pEmpleado_ID);
    END IF;

    RETURN Tipo_;
END //

-- 27. Calcular el porcentaje de compras de un cliente.
-- By @KevinGV
DELIMITER //
CREATE FUNCTION PorcentajeComprasxCliente(pCliente_ID INT)
RETURNS DECIMAL(3,1)
READS SQL DATA
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'PorcentajeComprasxCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT "Ventas";
    DECLARE Detalle TEXT DEFAULT 'Porcentaje de Compras por Cliente Obtenido';
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
        ID_Cliente = pCliente_ID;

    SELECT
        MAX(C.ID) INTO @max_ID
    FROM Clientes C;

    IF pCliente_ID <= @max_ID THEN
        INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ("FUNCION",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pCliente_ID);
    END IF;
    RETURN Porcentaje;
END//

DELIMITER;