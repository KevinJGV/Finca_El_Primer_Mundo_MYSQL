USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Limpiar la tabla de historial de precios.
-- Limpia el historia de la tabla se registros_prductos cada 6 meses.
CREATE EVENT LimpiarPreciosProductos
ON SCHEDULE EVERY 6 MONTH
DO
    DELETE FROM registro_productos;
-- By @JavierEAcevedoN

-- 2. Actualizar el stock de productos a cero.
-- Se pone el stock a 0 y se cambia de estadoa cancelado, cuando el producto no ha vendido nada en el intervalo de 1 año.
CREATE EVENT CancelarProductos
ON SCHEDULE EVERY 1 YEAR
DO
    UPDATE productos
    SET stock = 0,
    ID_Estado = 6
    WHERE ID NOT IN (SELECT DISTINCT ID_Producto FROM detalles_ventas);
-- By @JavierEAcevedoN

-- 3. Notificar clientes inactivos.
-- Se crea un mensaje a cada cliente que ha estado inactivo por mas de 1 mes.
CREATE EVENT NotificarClientesInactivos
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO notificaciones  (ID_Cliente, Mensaje, Fecha)
    SELECT ID, 'Hemos notado que no has comprado recientemente. ¡Te extrañamos!', NOW()
    FROM clientes
    WHERE ID_Estado = 2;
-- By @JavierEAcevedoN

-- 4. Realizar un resumen diario de ventas.
-- Hace un resumen diari de las ventas.
CREATE EVENT ResumenVentasDiario
ON SCHEDULE EVERY 1 DAY
DO
    INSERT INTO resumen_ventas (Fecha, TotalVentas)
    SELECT CURDATE(), SUM(total) FROM ventas WHERE Fecha = CURDATE();
-- By @JavierEAcevedoN

-- 5. Recordar la fecha de contratacion de los empleados.
-- Hace un recoradtorio de la fecha en la que se contrato el empleado.
CREATE EVENT RecordarFechaContratacionEmpleados
ON SCHEDULE EVERY 1 MONTH
DO
    INSERT INTO recordatorios (ID_Empleado, Mensaje, Fecha)
    SELECT `ID`, CONCAT('¡Feliz aniversario, ',Nombre," ",Apellido,'!'), NOW()
    FROM empleados
    WHERE MONTH(Fecha_Contratacion) = MONTH(NOW()) AND DAY(Fecha_Contratacion) = DAY(NOW());
-- By @JavierEAcevedoN

-- 6. Limpiar registros recordatorios.
-- Elimina todos los registros de recordatorios cada 6 meses.
CREATE EVENT EliminarRegistrosRecordatorios
ON SCHEDULE EVERY 6 MONTH
DO
    DELETE FROM recordatorios;
-- By @JavierEAcevedoN

-- 7. Eliminar registros de ventas antiguas.
-- Elimina los registros de ventas atiguas de mas de 5 años de antiguedad cada año.
CREATE EVENT EliminarVentasAntiguas
ON SCHEDULE EVERY 1 YEAR
DO
    DELETE FROM detalles_ventas WHERE `ID_Venta` IN (
        SELECT `ID` FROM ventas WHERE Fecha < NOW() - INTERVAL 5 YEAR
    );
    DELETE FROM ventas WHERE Fecha < NOW() - INTERVAL 5 YEAR;
-- By @JavierEAcevedoN

-- 8. Eliminar registros de resumen de ventas.
-- Se eliminan registros de ventas de mas de 5 años de antiguedad.
CREATE EVENT LimpiarResumenVentas
ON SCHEDULE EVERY 5 YEAR
DO
    DELETE FROM resumen_ventas;
-- By @JavierEAcevedoN

-- 9. LimpiarNotificaciones
-- Limpia los registros de notificaciones.
CREATE EVENT nombreevento
ON SCHEDULE EVERY 1 YEAR
DO
    DELETE FROM notificaciones;
-- By @JavierEAcevedoN

-- 10. Aumentar el salario de los empleados.
-- Aumenta el salario de los empleados anualmente en un 10%.
CREATE EVENT AumentarSalario
ON SCHEDULE EVERY 1 YEAR
DO
    UPDATE empleados
    SET `Salario` = `Salario` + (`Salario` * 0.1);
-- By @JavierEAcevedoN

-- 11. Reiniciar el saldo de clientes premium.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
    -- CODE;

-- 12. Enviar recordatorios de pago a clientes morosos.

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