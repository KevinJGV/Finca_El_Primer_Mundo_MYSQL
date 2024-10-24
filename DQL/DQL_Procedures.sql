USE Finca_El_Primer_Mundo;

DELIMITER //
-- 1. Insertar nuevo cliente.
-- Inserta un nuevo cliente a la base de datos.
CREATE PROCEDURE InsertarClinte (IN Nombre VARCHAR(50),IN Apellido VARCHAR(50), IN FechaNacimiento DATE, IN Telefono BIGINT, IN ID_Descuento INT, IN ID_Estado INT, IN ID_Ciudad INT)
BEGIN
    INSERT INTO Clientes (Nombre, Apellido, Fecha_Nacimiento, Telefono, ID_Descuento, ID_Estado, ID_Ciudad)
    VALUES (Nombre, Apellido, FechaNacimiento, Telefono, ID_Descuento, ID_Estado, ID_Ciudad);

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
            "PROCEDIMIENTO",
            "InsertarClinte",
            NOW(),
            USER(),
            "Se creo un nuevo cliente",
            "Clientes"
        );
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

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada,
        ID_Referencia
        ) 
        VALUES
        (
            "PROCEDIMIENTO",
            "ActualizarCliente",
            NOW(),
            USER(),
            "Se actualizo la informacion del cliente",
            "Clientes",
            ID_Cliente
        );
END//
-- CALL ActualizarCliente(47,'Edgan','Quintero','1970-12-01',30119072312,4,2,17);
-- By @JavierEAcevedoN

-- 3. Eliminar cliente.
-- Elimina un cliente por medio de la ID de este.
CREATE PROCEDURE EliminarCliente (IN ID_Cliente INT)
BEGIN
    DELETE FROM Clientes WHERE ID = ID_Cliente;

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada,
        ID_Referencia
        ) 
        VALUES
        (
            "PROCEDIMIENTO",
            "EliminarCliente",
            NOW(),
            USER(),
            "Se elimino el cliente",
            "Clientes",
            ID_Cliente
        );
END//
-- CALL EliminarCliente(51);
-- By @JavierEAcevedoN

-- 4. Insertar nuevo producto.
-- Inserta un nuevo producto.
CREATE PROCEDURE InsertarProducto (IN Nombre VARCHAR(50), IN Stock INT, IN Valor DECIMAL(9,2), IN Costo DECIMAL(9,2), IN ID_Descuento INT, IN ID_Estado INT, IN ID_Tipo_Producto INT, IN ID_Lote INT, IN ID_Recurso INT)
BEGIN
    INSERT INTO Productos (Nombre, Stock, Valor, Costo, ID_Descuento, ID_Estado, ID_Tipo_Producto, ID_Lote, ID_Recurso)
    VALUES (Nombre, Stock, Valor, Costo, ID_Descuento, ID_Estado, ID_Tipo_Producto, ID_Lote, ID_Recurso);

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
            "PROCEDIMIENTO",
            "InsertarProducto",
            NOW(),
            USER(),
            "Se agrego un nuevo producto",
            "Producto"
        );
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

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada,
        ID_Referencia
        ) 
        VALUES
        (
            "PROCEDIMIENTO",
            "ActualizarProducto",
            NOW(),
            USER(),
            "Se actualizo la informacion del producto",
            "Producto",
            ID_Producto
        );
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
            "PROCEDIMIENTO",
            "ObtenerPorTipoProducto",
            NOW(),
            USER(),
            "Se utilizo el procedimiento para mostrar los productos que tiene un tipo especifico",
            "Producto"
        );
END//
-- CALL ObtenerPorTipoProducto("Carne");
-- By @JavierEAcevedoN

-- 7. Insertar nueva venta.
-- Inserta una nueva venta.
CREATE PROCEDURE InsesrtarVenta (IN Fecha DATE, IN Total DECIMAL(9,2), IN ID_Cliente INT, IN ID_Empleado INT, IN ID_Medio_de_Pago INT)
BEGIN
    INSERT INTO Ventas (Fecha, Total, ID_Cliente, ID_Empleado, ID_Medio_de_Pago)
    VALUES (Fecha, Total, ID_Cliente, ID_Empleado, ID_Medio_de_Pago);

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
            "PROCEDIMIENTO",
            "InsesrtarVenta",
            NOW(),
            USER(),
            "Se agrego una nueva venta",
            "Venta"
        );
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

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada,
        ID_Referencia
        ) 
        VALUES
        (
            "PROCEDIMIENTO",
            "ObtenerVentasCliente",
            NOW(),
            USER(),
            "Se utilizo el procedimiento para mostrar las ventas de un cliente especifico",
            "Cliente",
            ID_Cliente
        );
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

    INSERT INTO Logs (
        Tipo_Actividad,
        Nombre_Actividad,
        Fecha,
        Usuario_Ejecutor,
        Detalles,
        Tabla_Afectada,
        ID_Referencia
        ) 
        VALUES
        (
            "PROCEDIMIENTO",
            "ObtenerVentasEmpleado",
            NOW(),
            USER(),
            "Se utilizo el procedimiento para mostrar las ventas de un empleado especifico",
            "Empleado",
            ID_Empleado
        );
END//

-- CALL ObtenerVentasEmpleado(1);
-- By @JavierEAcevedoN

-- 10. Insertar nuevo tipo de producto.
-- Inserta un nuevo tipo de producto.
CREATE PROCEDURE InsetarTipoProducto (IN TipoProducto VARCHAR(50))
BEGIN
    INSERT INTO Tipos_Productos (Tipo)
    VALUES (TipoProducto);

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
            "PROCEDIMIENTO",
            "InsetarTipoProducto",
            NOW(),
            USER(),
            "Se agrego un nuevo tipo de producto",
            "Tipos_Productos"
        );
END//
-- CALL InsetarTipoProducto ("Cookie");
-- By @JavierEAcevedoN

-- 11. Agregar una categoría de Recursos.
-- By @KevinJGV
CREATE PROCEDURE NuevoTipoRecurso (IN pTipo VARCHAR(50))
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'NuevoTipoRecurso';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Recursos';
    DECLARE Detalle TEXT DEFAULT 'Creado Nuevo Tipo de Recurso';

    INSERT INTO Tipos_Recursos (Tipo) VALUES (pTipo);

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END//

-- 12. Obtener clientes por rango de fechas de nacimiento.
-- By @KevinJGV
CREATE PROCEDURE ClientesEntreFechasNacimiento (IN pFecha_inicio DATE, IN pFecha_fin DATE)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ClientesEntreFechasNacimiento';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT 'Total de Ventas por Cliente Obtenido';

    SELECT
        *
    FROM
        Clientes
    WHERE
        Fecha_Nacimiento BETWEEN pFecha_inicio AND pFecha_fin;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END//

-- 13. Obtener total de ventas por cliente.
-- By @KevinJGV
CREATE PROCEDURE TotalVentasCliente (IN pCliente_ID INT)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TotalVentasCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT 'Total de Ventas por Cliente Obtenido';

    SELECT
        COUNT(V.ID) AS Ventas,
        CONCAT(C.Nombre, ' ',C.Apellido) AS Cliente
    FROM
        Clientes C
    JOIN
        Ventas V ON C.ID = V.ID_Cliente
    WHERE
        C.ID = pCliente_ID
    GROUP BY
        Cliente;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pCliente_ID);
END//

-- 14. Obtener total de ventas por empleado.
-- By @KevinJGV
CREATE PROCEDURE TotalVentasEmpleado (IN pEmpleado_ID INT)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'TotalVentasEmpleado';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Empleado';
    DECLARE Detalle TEXT DEFAULT 'Total de Ventas por empleado Obtenido';

    SELECT
        COUNT(V.ID) AS Ventas,
        CONCAT(E.Nombre, ' ',E.Apellido) AS Empleado
    FROM
        Empleados E
    JOIN
        Ventas V ON E.ID = V.ID_Empleado
    WHERE
        E.ID = pEmpleado_ID
    GROUP BY
        Empleado;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pEmpleado_ID);
END//

-- 15. Eliminar producto.
-- By @KevinJGV
CREATE PROCEDURE DesactivarProducto (IN pProducto_ID INT)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'DesactivarProducto';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Productos';
    DECLARE Detalle TEXT DEFAULT 'Desactivacion de Producto';

    UPDATE Productos
    SET ID_Estado = 2
    WHERE ID = pProducto_ID;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pProducto_ID);
END//

-- 16. Eliminar una venta.
-- By @KevinJGV
CREATE PROCEDURE EliminarVenta (IN pVenta_ID INT)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'EliminarVenta';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Ventas';
    DECLARE Detalle TEXT DEFAULT 'Eliminacion de Venta';

    DELETE FROM Ventas
    WHERE ID = pVenta_ID;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pVenta_ID);
END//

-- 17. Obtener productos por precio mínimo y máximo.
-- By @KevinJGV
CREATE PROCEDURE ProductosEntreValores (IN pRango_inicial INT, IN pRango_final INT)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ProductosEntreValores';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Productos';
    DECLARE Detalle TEXT DEFAULT 'Productos en un rango de Precios obtenido';

    SELECT
        *
    FROM
        Productos
    WHERE
        Valor BETWEEN pRango_inicial AND pRango_final;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END//

-- 18. Obtener ventas por rango de fechas.
-- By @KevinJGV
CREATE PROCEDURE VentasEntreFechas (IN pFecha_inicial DATE, IN pFecha_final DATE)
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'VentasEntreFechas';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Ventas';
    DECLARE Detalle TEXT DEFAULT 'Ventas en un rango de fechas obtenido';

    SELECT
        *
    FROM
        Ventas
    WHERE
        Fecha BETWEEN pFecha_inicial AND pFecha_final;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END//

-- 19. Obtener cantidad total de productos vendidos por categoría.
-- By @KevinJGV
CREATE PROCEDURE CantidadVentasxTipo()
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'CantidadVentasxTipo';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Detalles_Ventas';
    DECLARE Detalle TEXT DEFAULT 'Productos Vendidos por tipo obtenido';

    Select
        SUM(DV.Cantidad) AS Vendidos,
        TP.Tipo
    FROM
        Detalles_Ventas DV
        JOIN Productos P ON DV.ID_Producto = P.ID
        JOIN Tipos_Productos TP ON P.ID_Tipo_Producto = TP.ID
    GROUP BY
        TP.Tipo;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END//

-- 20. Generar reporte de ventas mensual.
-- By @KevinJGV
CREATE PROCEDURE ReporteMensual (IN pReferencia_ID INT, IN Nombre_Resultado VARCHAR(50), IN Fecha_Resultado DATETIME, IN Descripcion VARCHAR(100),IN Resultado DECIMAL(9,2))
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ReporteMensual';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Resultados_Mensuales';
    DECLARE Detalle TEXT DEFAULT 'Reporte Realizado en Resultados_Mensuales';
    INSERT INTO Resultados_Mensuales(Tabla_Nombre,ID_Referencia,Nombre_Resultado,Fecha_Resultado,Descripcion,Resultado) VALUES
    (tabla_nombre,pReferencia_ID, Nombre_Resultado, Fecha_Resultado,Descripcion, Resultado);

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ("PROCEDIMIENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pReferencia_ID);
END//

DELIMITER ;