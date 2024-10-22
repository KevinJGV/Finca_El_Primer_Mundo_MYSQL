USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Limpiar la tabla de historial de precios.
-- Limpia el historia de la tabla se registros_productos cada 6 meses.
CREATE EVENT LimpiarPreciosProductos
ON SCHEDULE EVERY 6 MONTH
DO
BEGIN
    DELETE FROM Logs WHERE Nombre_Actividad = "RegistroPrecioProducto";

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
            "EVENTO",
            "LimpiarPreciosProductos",
            NOW(),
            USER(),
            "Se limpio los registros de precio de producto en la tabla logs",
            "Logs"
        );
END//
-- By @JavierEAcevedoN

-- 2. Actualizar el stock de productos a cero.
-- Se pone el stock a 0 y se cambia de estadoa cancelado, cuando el producto no ha vendido nada en el intervalo de 1 año.
CREATE EVENT CancelarProductos
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    UPDATE Productos
    SET Stock = 0,
    ID_Estado = 6
    WHERE ID NOT IN (SELECT DISTINCT ID_Producto FROM Detalles_Ventas);

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
            "EVENTO",
            "CancelarProductos",
            NOW(),
            USER(),
            "Se actualizo el stock de los productos que no han tenido ventas en mas de 1 año",
            "Productos"
        );
END//
-- By @JavierEAcevedoN

-- 3. Notificar clientes inactivos.
-- Se crea un mensaje a cada cliente que ha estado inactivo por mas de 1 mes.
CREATE EVENT NotificarClientesInactivos
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO Notificaciones (ID_Cliente, Mensaje, Fecha)
    SELECT ID, 'Hemos notado que no has comprado recientemente. ¡Te extrañamos!', NOW()
    FROM Clientes
    WHERE ID_Estado = 2;

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
            "EVENTO",
            "NotificarClientesInactivos",
            NOW(),
            USER(),
            "Se ha creado una nueva notificacion",
            "Notificaciones"
        );
END//
-- By @JavierEAcevedoN

-- 4. Realizar un resumen diario de ventas.
-- Hace un resumen diari de las ventas.
CREATE EVENT ResumenVentasDiario
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO ResumenVentas (Fecha, TotalVentas)
    SELECT CURDATE(), SUM(Total) FROM Ventas WHERE Fecha = CURDATE();

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
            "EVENTO",
            "ResumenVentasDiario",
            NOW(),
            USER(),
            "Se ha creado el resumen diario de ventas",
            "ResumenVentas"
        );
END//
-- By @JavierEAcevedoN

-- 5. Recordar la fecha de contratacion de los empleados.
-- Hace un recoradtorio de la fecha en la que se contrato el empleado.
CREATE EVENT RecordarFechaContratacionEmpleados
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    INSERT INTO Recordatorios (ID_Empleado, Mensaje, Fecha)
    SELECT ID, CONCAT('¡Feliz aniversario, ',Nombre," ",Apellido,'!'), NOW()
    FROM Empleados
    WHERE MONTH(Fecha_Contratacion) = MONTH(NOW()) AND DAY(Fecha_Contratacion) = DAY(NOW());

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
            "EVENTO",
            "RecordarFechaContratacionEmpleados",
            NOW(),
            USER(),
            "Se creo un nuevo recordatorio",
            "Recordatorios"
        );
END//
-- By @JavierEAcevedoN

-- 6. Limpiar registros Recordatorios.
-- Elimina todos los registros de Recordatorios cada 6 meses.
CREATE EVENT EliminarRegistrosRecordatorios
ON SCHEDULE EVERY 6 MONTH
DO
BEGIN
    DELETE FROM Recordatorios;

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
            "EVENTO",
            "EliminarRegistrosRecordatorios",
            NOW(),
            USER(),
            "Se limpio el historial de recordatorios",
            "Recordatorios"
        );
END//
-- By @JavierEAcevedoN

-- 7. Eliminar registros de ventas antiguas.
-- Elimina los registros de ventas atiguas de mas de 5 años de antiguedad cada año.
CREATE EVENT EliminarVentasAntiguas
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    DELETE FROM Detalles_Ventas WHERE ID_Venta IN (
        SELECT ID FROM Ventas WHERE Fecha < NOW() - INTERVAL 5 YEAR
    );
    DELETE FROM Ventas WHERE Fecha < NOW() - INTERVAL 5 YEAR;

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
            "EVENTO",
            "EliminarVentasAntiguas",
            NOW(),
            USER(),
            "Se elimino el historial de las ventas viejas de mas de 5 años",
            "Ventas y Detalles_ventas"
        );
END//
-- By @JavierEAcevedoN

-- 8. Eliminar registros de resumen de ventas.
-- Se eliminan registros de ventas de mas de 5 años de antiguedad.
CREATE EVENT LimpiarResumenVentas
ON SCHEDULE EVERY 5 YEAR
DO
BEGIN
    DELETE FROM ResumenVentas;

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
            "EVENTO",
            "LimpiarResumenVentas",
            NOW(),
            USER(),
            "Se elimino el historial del resumen de ventas",
            "ResumenVentas"
        );
END//
-- By @JavierEAcevedoN

-- 9. Limpiar notificaciones
-- Limpia los registros de Notificaciones.
CREATE EVENT LimpiarNotificaciones
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    DELETE FROM Notificaciones;
    
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
            "EVENTO",
            "LimpiarNotificaciones",
            NOW(),
            USER(),
            "Se elimino el historial de las notificaciones",
            "Notificaciones"
        );
END//
-- By @JavierEAcevedoN

-- 10. Aumentar el salario de los empleados.
-- Aumenta el salario de los empleados anualmente en un 10%.
CREATE EVENT AumentarSalario
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    UPDATE Empleados
    SET Salario = Salario + (Salario * 0.1);

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
            "EVENTO",
            "AumentarSalario",
            NOW(),
            USER(),
            "Se aumento el salario de los empleados",
            "Empleados"
        );
END//
-- By @JavierEAcevedoN

-- 11. Reiniciar el saldo de clientes premium.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 12. Enviar Recordatorios de pago a clientes morosos.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 13. Revisar el stock de productos semanalmente.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 14. Verificar actualizaciones de precios.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 15. Enviar informes de ventas a los gerentes.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 16. Realizar auditorías mensuales de clientes.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 17. Evaluar el rendimiento de los empleados.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 18. Actualizar el estado de clientes inactivos.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 19. Ajustar precios de productos automáticamente.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 20. revisar los descuentos aplicados

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

DELIMITER ;