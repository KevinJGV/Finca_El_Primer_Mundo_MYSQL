USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Registrar la fecha de creación de un cliente.
-- Al resgistrar un nuevo cliente se agrega a la tabla de registro_clientes.
CREATE TRIGGER RegistroCliente
AFTER INSERT ON clientes FOR EACH ROW
BEGIN
    INSERT INTO registro_clientes (Mensaje)
    VALUES
        (
            CONCAT("Se registro el cliente: ",NEW.ID," con el nombre: ",NEW.Nombre," ",NEW.Apellido," el dia: ",DATE(NOW())," a la hora: ",TIME(NOW()))
        );
END//
-- CALL InsertarClinte('Edgan','Quintero','1970-12-01',30119072312,4,2,17);
-- By @JavierEAcevedoN

-- 2. Actualizar el stock después de una venta.
-- Se actualiza el stock del producto, despues de la insersion del detalle_venta.
CREATE TRIGGER ActualizarStockVenta
AFTER INSERT ON detalles_ventas FOR EACH ROW
BEGIN
    DECLARE CantidadDV INT;
    DECLARE Producto_ID INT;

    SELECT 
        Cantidad,
        ID_Producto
    INTO
        CantidadDV,
        Producto_ID
    FROM detalles_ventas 
    WHERE ID = NEW.ID;

    UPDATE productos
    SET Stock = Stock - CantidadDV
    WHERE ID = Producto_ID;
END//
-- INSERT INTO detalles_ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (5,432.93,55,1);
-- By @JavierEAcevedoN

-- 3. Mantener un historial de cambios en los precios de productos.
-- Al hacer un cambio en el precio de un producto ya existente, se hace el registro en la tabla de registro_productos.
CREATE TRIGGER RegistroPrecioProducto
AFTER UPDATE ON productos FOR EACH ROW
BEGIN
    INSERT INTO registro_productos (Mensaje)
    VALUES
        (
            CONCAT("Se hizo el cambio de precio del producto: ",NEW.ID," con el nombre: ",NEW.Nombre," con el precio: ",OLD.Valor," al precio ",NEW.Valor," el dia: ",DATE(NOW())," a la hora: ",TIME(NOW()))
        );
END//
-- UPDATE productos SET valor = valor + 1000 WHERE ID = 1;
-- By @JavierEAcevedoN

-- 4. Calcular el total de una venta automáticamente.
-- Calcula el nuevo total de la venta, despues de la insersion del detalle_venta.
CREATE TRIGGER TotalVenta
AFTER INSERT ON detalles_ventas FOR EACH ROW
BEGIN
    DECLARE CantidadDV INT;
    DECLARE SubtotalDV INT;
    DECLARE Venta_ID INT;

    SELECT 
        Cantidad,
        Subtotal,
        ID_Venta
    INTO
        CantidadDV,
        SubtotalDV,
        Venta_ID
    FROM detalles_ventas 
    WHERE ID = NEW.ID;

    UPDATE ventas
    SET Total = Total + (CantidadDV  * SubtotalDV)
    WHERE ID = Venta_ID;
END//
-- INSERT INTO detalles_ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (5,432.93,55,1);
-- By @JavierEAcevedoN

-- 5. Prevenir la eliminación de un producto si tiene ventas.
-- Evita que se elimine el producto si tieve aunque sea una venta.
CREATE TRIGGER PrevenirEliminacionVentas
BEFORE DELETE ON productos FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM detalles_ventas WHERE id_producto = OLD.ID) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede eliminar el producto porque tiene ventas asociadas.';
    END IF;
END//
-- DELETE FROM productos WHERE ID = 54;
-- By @JavierEAcevedoN

-- 6. Actualizar el stock al eliminar un detalle de venta.
-- Al eliminar un redistro de detalle_venta se actualiza el stock del producto relacionado.
CREATE TRIGGER ActualizarStockEliminarVenta
BEFORE DELETE ON detalles_ventas FOR EACH ROW
BEGIN
    DECLARE CantidadDV INT;
    DECLARE Producto_ID INT;

    SET CantidadDV = OLD.Cantidad;
    SET Producto_ID = OLD.ID_Producto;

    UPDATE productos
    SET Stock = Stock + CantidadDV
    WHERE ID = Producto_ID;
END//
-- DELETE FROM detalles_ventas WHERE ID = 2;
-- By @JavierEAcevedoN

-- 7. Prevenir la creación de un cliente con el mismo telefono.
-- Previene que se inserte un nuevo cliente si tiene el telefoo repetido.
CREATE TRIGGER PrevenirClienteTelefono
BEFORE INSERT ON clientes FOR EACH ROW
BEGIN
    IF EXISTS (SELECT Telefono FROM clientes WHERE Telefono = NEW.Telefono) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya existe un cliente con ese telefono";
    END IF;
END//
-- CALL InsertarClinte('Edgan','Quintero','1970-12-01',3011907231332,4,2,17);
-- By @JavierEAcevedoN

-- 8. Establecer el estado de un producto a "cancelada".
-- Cuando el Stock de un producto llaga a 0 se pone automaticamente el estado a cancelado.
CREATE TRIGGER ProductoCancelado
AFTER INSERT ON detalles_ventas FOR EACH ROW
BEGIN
    UPDATE productos 
    SET ID_Estado = 6 
    WHERE ID = NEW.ID_Producto AND Stock < 1;
END;
-- INSERT INTO detalles_ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (1,432.93,55,1);
-- By @JavierEAcevedoN

-- 9. Establecer el estado de un producto a "Activo".
-- Cuando el Stock de un producto sube de 0 se pone automaticamente el estado a activo.
CREATE TRIGGER ProductoActivo
AFTER DELETE ON detalles_ventas FOR EACH ROW
BEGIN
    UPDATE productos 
    SET ID_Estado = 1
    WHERE ID = OLD.ID_Producto AND Stock > 0;
END//
-- DELETE FROM detalles_ventas WHERE ID = 133;
-- By @JavierEAcevedoN

-- 10. Comprobar el stock antes de insertar un detalle de venta.
-- Si no hay suficiente stock en el producto no se completa la compra.
CREATE TRIGGER ComprobarStock
BEFORE INSERT ON detalles_ventas FOR EACH ROW
BEGIN
    IF NEW.Cantidad > (SELECT Stock FROM productos WHERE ID = NEW.ID_Producto) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay suficiente stock para del producto para la venta.';
    END IF;
END;
-- INSERT INTO detalles_ventas (Cantidad,Subtotal,ID_Venta,ID_Producto) VALUES (2,432.93,55,1);
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