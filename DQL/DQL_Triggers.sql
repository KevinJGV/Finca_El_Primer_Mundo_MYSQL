USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Registrar la fecha de creación de un cliente.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 2. Actualizar el stock después de una venta.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 3. Mantener un historial de cambios en los precios de productos.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 4. Calcular el total de una venta automáticamente.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 5. Prevenir la eliminación de un producto si tiene ventas.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 6. Actualizar el stock al eliminar un detalle de venta.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 7. Prevenir la creación de un cliente con el mismo correo.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 8. Establecer el estado de una venta a "cancelada".

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 9. Mantener el saldo de un cliente actualizado.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

-- 10. Comprobar el stock antes de insertar un detalle de venta.

CREATE TRIGGER nombretrigger
AFTER|BEFORE INSERT|UPDATE|DELETE ON nombretabla FOR EACH ROW
BEGIN
    -- CODE
END//

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