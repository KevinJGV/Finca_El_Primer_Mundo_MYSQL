USE Finca_El_Primer_Mundo;

DELIMITER //
-- 1. Registrar la fecha de creación de un cliente.
-- Al resgistrar un nuevo cliente se agrega a la tabla de Logs.
CREATE TRIGGER RegistroCliente
AFTER INSERT ON Clientes FOR EACH ROW
BEGIN
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
            "TRIGGER",
            "RegistroCliente",
            NOW(),
            USER(),
            CONCAT("Se registro el cliente: ",NEW.ID," con el nombre: ",NEW.Nombre," ",NEW.Apellido),
            "Clientes",
            NEW.ID
        );
END //
-- CALL InsertarClinte('Edgan','Quintero','1970-12-01',30119072312,4,2,17);
-- By @JavierEAcevedoN

-- 2. Actualizar el stock después de una venta.
-- Se actualiza el stock del producto, despues de la insersion del detalle_venta.
CREATE TRIGGER ActualizarStockVenta
AFTER INSERT ON Detalles_Ventas FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Stock = Stock - NEW.Cantidad
    WHERE ID = NEW.ID_Producto;

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
            "TRIGGER",
            "ActualizarStockVenta",
            NOW(),
            USER(),
            CONCAT("Se actualizo el stock del producto: ",NEW.ID_Producto," y se le desconto: ",NEW.Cantidad," unidades del Stock"),
            "Productos",
            NEW.ID_Producto
        );
END//
-- INSERT INTO Detalles_Ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (5,432.93,48,1);
-- By @JavierEAcevedoN

-- 3. Mantener un historial de cambios en los precios de productos.
-- Al hacer un cambio en el precio de un producto ya existente, se hace el registro en la tabla de Logs.
CREATE TRIGGER RegistroPrecioProducto
AFTER UPDATE ON Productos FOR EACH ROW
BEGIN
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
            "TRIGGER",
            "RegistroPrecioProducto",
            NOW(),
            USER(),
            CONCAT("Se hizo el cambio de precio del producto: ",NEW.ID," con el nombre: ",NEW.Nombre," con el precio: ",OLD.Valor," al precio ",NEW.Valor),
            "Productos",
            NEW.ID
        );
END//
-- UPDATE Productos SET Valor = Valor + 1000 WHERE ID = 1;
-- By @JavierEAcevedoN

-- 4. Calcular el total de una venta automáticamente.
-- Calcula el nuevo total de la venta, despues de la insersion del detalle_venta.
CREATE TRIGGER TotalVenta
AFTER INSERT ON Detalles_Ventas FOR EACH ROW
BEGIN
    UPDATE Ventas
    SET Total = Total + (NEW.Cantidad  * NEW.Subtotal)
    WHERE ID = NEW.ID_Venta;

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
            "TRIGGER",
            "TotalVenta",
            NOW(),
            USER(),
            CONCAT("Se actualizo el total de la venta: ",NEW.ID_Venta),
            "Venta",
            NEW.ID_Venta
        );
END//
-- INSERT INTO Detalles_Ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (5,432.93,24,1);
-- By @JavierEAcevedoN

-- 5. Prevenir la eliminación de un producto si tiene ventas.
-- Evita que se elimine el producto si tieve aunque sea una venta.
CREATE TRIGGER PrevenirEliminacionVentas
BEFORE DELETE ON Productos FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Detalles_Ventas WHERE ID_Producto = OLD.ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el producto porque tiene ventas asociadas.';
    END IF;

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
            "TRIGGER",
            "PrevenirEliminacionVentas",
            NOW(),
            USER(),
            CONCAT("Se elimino el producto: ",OLD.ID),
            "Productos",
            OLD.ID
        );
END//
-- DELETE FROM Productos WHERE ID = 43;
-- By @JavierEAcevedoN

-- 6. Actualizar el stock al eliminar un detalle de venta.
-- Al eliminar un registro de detalle_venta se actualiza el stock del producto relacionado.
CREATE TRIGGER ActualizarStockEliminarVenta
BEFORE DELETE ON Detalles_Ventas FOR EACH ROW
BEGIN
    UPDATE Productos
    SET Stock = Stock + OLD.Cantidad
    WHERE ID = OLD.ID_Producto;

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
            "TRIGGER",
            "ActualizarStockEliminarVenta",
            NOW(),
            USER(),
            CONCAT("Se actualizo el stock del producto: ",OLD.ID_Producto," y se le adiciono: ",OLD.Cantidad," unidades del Stock"),
            "Productos",
            OLD.ID
        );
END//
-- DELETE FROM Detalles_Ventas WHERE ID = 32;
-- By @JavierEAcevedoN

-- 7. Prevenir la creación de un cliente con el mismo telefono.
-- Previene que se inserte un nuevo cliente si tiene el telefoo repetido.
CREATE TRIGGER PrevenirClienteTelefono
BEFORE INSERT ON Clientes FOR EACH ROW
BEGIN
    IF EXISTS (SELECT Telefono FROM Clientes WHERE Telefono = NEW.Telefono) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya existe un cliente con ese telefono";
    END IF;

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
            "TRIGGER",
            "PrevenirClienteTelefono",
            NOW(),
            USER(),
            CONCAT("Se registro un cliente con el nombre: ",NEW.Nombre," ",NEW.Apellido," con el telefono: ",NEW.Telefono),
            "Clientes",
            NULL
        );
END//
-- CALL InsertarClinte('Edgan','Quintero','1970-12-01',1333322,4,2,17);
-- By @JavierEAcevedoN

-- 8. Establecer el estado de un producto a "cancelada".
-- Cuando el Stock de un producto llaga a 0 se pone automaticamente el estado a cancelado.
CREATE TRIGGER ProductoCanceladoInsert
AFTER INSERT ON Detalles_Ventas FOR EACH ROW
BEGIN
    UPDATE Productos 
    SET ID_Estado = 6 
    WHERE ID = NEW.ID_Producto AND Stock < 1;
END;

CREATE TRIGGER ProductoCanceladoUpdate
AFTER UPDATE ON Detalles_Ventas FOR EACH ROW
BEGIN
    UPDATE Productos 
    SET ID_Estado = 6 
    WHERE ID = NEW.ID_Producto AND Stock < 1;
END;
-- INSERT INTO Detalles_Ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (1,432.93,32,1);
-- By @JavierEAcevedoN

-- 9. Establecer el estado de un producto a "Activo".
-- Cuando el Stock de un producto sube de 0 se pone automaticamente el estado a activo.
CREATE TRIGGER ProductoActivo
AFTER DELETE ON Detalles_Ventas FOR EACH ROW
BEGIN
    UPDATE Productos 
    SET ID_Estado = 1
    WHERE ID = OLD.ID_Producto AND Stock > 0;
END//
-- DELETE FROM Detalles_Ventas WHERE ID = 110;
-- By @JavierEAcevedoN

-- 10. Comprobar el stock antes de insertar un detalle de venta.
-- Si no hay suficiente stock en el producto no se completa la compra.
CREATE TRIGGER ComprobarStock
BEFORE INSERT ON Detalles_Ventas FOR EACH ROW
BEGIN
    IF NEW.Cantidad > (SELECT Stock FROM Productos WHERE ID = NEW.ID_Producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para del producto para la venta.';
    END IF;
END//

INSERT INTO
    Detalles_Ventas (
        Cantidad,
        Subtotal,
        ID_Venta,
        ID_Producto
    )
VALUES (1, 432.93, 32, 1);
-- By @JavierEAcevedoN

-- 11. Calcular el costo de Recursos en Stock.
-- By @KevinGV
CREATE TRIGGER CalcularCostoRecursos
BEFORE UPDATE ON Recursos FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'CalcularCostoRecursos';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Recursos';
    DECLARE Detalle TEXT DEFAULT 'Costo de recurso calculado';
    DECLARE pUnitario DECIMAL(9,2) DEFAULT 0;

    SET pUnitario = ObtenerPrecioUnitario(NEW.ID);

    SET NEW.Costo = pUnitario * NEW.Stock;

    INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,NEW.ID);
END//

-- 12. Prevenir la eliminación de un cliente si tiene ventas.
-- By @KevinGV
CREATE TRIGGER PrevenirCambioEstadoClienteConVentas
BEFORE UPDATE ON Clientes FOR EACH ROW
BEGIN
    IF NumeroVentasCliente(OLD.ID) > 0 AND OLD.ID_Estado = 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No es posible Eliminar a un usuario con Ventas registradas';
    END IF;
END//

-- 13. Registrar las ventas en los logs.
-- By @KevinGV
CREATE TRIGGER RegistroVentaLog
AFTER INSERT ON Ventas FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'RegistroVentaLog';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Ventas';
    DECLARE Detalle TEXT DEFAULT 'Venta registrada';

    INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,NEW.ID);
END//

-- 14. Reajustar el stock de recursos de tipo semilla, insumo quimico, riego, material de construccion, energia si tiene un estado diferente a 'activo'.
-- By @KevinGV
CREATE TRIGGER ReajustesStockInventarioTipo
BEFORE UPDATE ON Recursos FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ReajustesStockInventarioTipo';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Recursos';
    DECLARE Detalle TEXT DEFAULT 'Stock reajustado según estado.';
    DECLARE Tipo VARCHAR(50);
    
    IF NEW.ID_Estado <> 1 AND ObtenerTipoRecurso(NEW.ID_Tipo_Recurso) COLLATE utf8mb4_unicode_ci IN ('Semilla', 'Insumo químico', 'Riego', 'Material de construcción', 'Energía') THEN
        SET NEW.Stock = 0;
    END IF;
    INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,OLD.ID);
END//

-- 15. Registrar la fecha de última actividad de un cliente.
-- By @KevinGV
CREATE TRIGGER UltimaCompraCliente
AFTER INSERT ON Ventas FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'UltimaCompraCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Ventas';
    DECLARE Detalle TEXT DEFAULT CONCAT('ID Cliente: ', NEW.ID_Cliente);
    INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,NEW.ID);
END//

-- 16. Validar que el nombre del producto no esté vacío.
-- By @KevinGV
CREATE TRIGGER ProductoNombreNoVacioInsert
BEFORE INSERT ON Productos FOR EACH ROW
BEGIN
    IF LENGTH(NEW.Nombre) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede insertar un nombre Vacío en Detalles_Ventas';
    END IF;
END//

CREATE TRIGGER ProductoNombreNoVacioUpdate
BEFORE UPDATE ON Productos FOR EACH ROW
BEGIN
    IF LENGTH(NEW.Nombre) = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No se puede actualizar a un nombre Vacío en Detalles_Ventas';
    END IF;
END//

-- 17. Registrar el cambio de estado de un cliente.
-- By @KevinGV
CREATE TRIGGER RegistrarNuevoEstadoCliente
AFTER UPDATE ON Clientes FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'RegistrarNuevoEstadoCliente';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT CONCAT('Nuevo Estado: ', NEW.ID_Estado);
    IF OLD.ID_Estado <> NEW.ID_Estado THEN
        INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
        ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,OLD.ID);
    END IF;
END//

-- 18. Calcular el subtotal de un detalle de venta automáticamente.
-- By @KevinGV
CREATE TRIGGER SubtotalCalculado
BEFORE INSERT ON Detalles_Ventas FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'SubtotalCalculado';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Detalles_Ventas';
    DECLARE Detalle TEXT DEFAULT 'Subtotal Calculado';
    SET @Precio = 0;

    SELECT
        Valor INTO @Precio
    FROM
        Productos
    WHERE
        ID = NEW.ID_Producto;

    SET NEW.Subtotal = @Precio * NEW.Cantidad;

    INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,NEW.ID);
END//

-- 19. Prevenir la inserción de un detalle de venta si la cantidad es negativa.
-- By @KevinGV
CREATE TRIGGER AnularDetalle_VentaCantidadNegativa
BEFORE INSERT ON Detalles_Ventas 
FOR EACH ROW
BEGIN
    IF NEW.Cantidad <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: No se puede insertar una cantidad menor o igual a cero en Detalles_Ventas';
    END IF;
END//

-- 20. Registrar cambios en la información del empleado.
-- By @KevinGV
CREATE TRIGGER RegistrarCambioEmpleado
AFTER UPDATE ON Empleados FOR EACH ROW
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'RegistrarCambioEmpleado';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Empleados';
    DECLARE Detalle TEXT DEFAULT 'Actualizacion en: ';
    DECLARE Separador VARCHAR(2) DEFAULT ', ';

    IF OLD.Nombre <> NEW.Nombre THEN
        SET Detalle = CONCAT(Detalle, 'Nombre - ', NEW.Nombre, Separador);
    END IF;

    IF OLD.Apellido <> NEW.Apellido THEN
        SET Detalle = CONCAT(Detalle, 'Apellido - ', NEW.Apellido, Separador);
    END IF;

    IF OLD.Salario <> NEW.Salario THEN
        SET Detalle = CONCAT(Detalle, 'Salario - ', NEW.Salario, Separador);
    END IF;

    IF OLD.Fecha_Contratacion <> NEW.Fecha_Contratacion THEN
        SET Detalle = CONCAT(Detalle, 'Fecha_Contratacion - ', NEW.Fecha_Contratacion, Separador);
    END IF;

    IF LENGTH(Detalle) > 0 THEN
        SET Detalle = LEFT(Detalle, LENGTH(Detalle) - LENGTH(Separador));
    END IF;
    
    INSERT INTO Logs (Tipo_Actividad,Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
    ('TRIGGER',proceso_nombre,NOW(),USER(),Detalle,tabla_nombre, NEW.ID);
END//

DELIMITER;