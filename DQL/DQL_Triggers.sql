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
CREATE TRIGGER ProductoCancelado
AFTER INSERT ON Detalles_Ventas FOR EACH ROW
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
INSERT INTO `Detalles_Ventas` (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (1,432.93,32,1);
-- By @JavierEAcevedoN

-- 11. Actualizar la fecha de modificación en la tabla de productos.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 12. Prevenir la eliminación de un cliente si tiene ventas.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 13. Actualizar el contador de ventas en la tabla de empleados.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 14. Ajustar el saldo de un cliente al eliminar una venta.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 15. Registrar la fecha de última actividad de un cliente.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 16. Validar que el nombre del producto no esté vacío.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 17. Registrar el cambio de estado de un cliente.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 18. Ajustar el saldo del cliente al actualizar su información.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 19. Prevenir la inserción de un detalle de venta si la cantidad es negativa.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 20. Registrar cambios en la información del empleado.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

DELIMITER ;