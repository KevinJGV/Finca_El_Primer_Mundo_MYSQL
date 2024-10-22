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

-- 11. Calcular el costo de Recursos en Stock.

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

CREATE TRIGGER PrevenirCambioEstadoClienteConVentas
BEFORE UPDATE ON Clientes FOR EACH ROW
BEGIN
    IF NumeroVentasCliente(OLD.ID) > 0 AND OLD.ID_Estado = 2 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: No es posible Eliminar a un usuario con Ventas registradas';
    END IF;
END//

-- 13. Registrar las ventas en los logs.

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

DELIMITER ;