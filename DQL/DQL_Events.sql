USE Finca_El_Primer_Mundo;

DELIMITER //

-- 1. Limpiar la tabla de historial de precios.

CREATE EVENT nombreevento
ON SCHEDULE EVERY 2 intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 2. Actualizar el stock de productos a cero.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 3. Notificar clientes inactivos.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 4. Realizar un resumen diario de ventas.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 5. Recordar la fecha de cumpleaños de los empleados.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 6. Restablecer contraseñas temporales.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 7. Eliminar registros de ventas antiguas.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 8. Archivar productos inactivos.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 9. Enviar ofertas especiales a clientes frecuentes.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 10. Calcular comisiones de empleados.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 11. Reiniciar el saldo de clientes premium.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 12. Enviar recordatorios de pago a clientes morosos.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 13. Revisar el stock de productos semanalmente.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 14. Verificar actualizaciones de precios.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 15. Enviar informes de ventas a los gerentes.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 16. Realizar auditorías mensuales de clientes.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 17. Evaluar el rendimiento de los empleados.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 18. Actualizar el estado de clientes inactivos.

CREATE EVENT nombreevento
ON SCHEDULE EVERY numero intervalodetiempo
STARTS fechaconhora -- opcional
ENDS fechaconhora -- opcional
DO
BEGIN
END//

-- 19. Ajustar descuento de productos automáticamente segun un criterio especifico.

CREATE EVENT DCTOsegunProductoyDia
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-20 00:00:00'
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'DCTOsegunProductoyDia';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Productos';
    DECLARE Detalle TEXT DEFAULT 'Descuento de Producto Revisado';

    DECLARE pProducto_ID INT;
    DECLARE tipo INT;
    DECLARE DCTO INT DEFAULT 5;
    DECLARE NEW_DCTO INT;
    DECLARE Dia VARCHAR(20);

    SET Dia = DAYNAME(CURDATE());

    DECLARE fin INT DEFAULT 0;
    DECLARE cursor_producto CURSOR SELECT ID FROM Productos;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cursor_producto;

        producto_loop: LOOP
            IF fin THEN
                LEAVE cursor_loop:
            END IF;

            FETCH cursor_producto INTO pProducto_ID;

            SELECT
                ID_Tipo_Producto INTO Tipo
            FROM
                Productos
            WHERE
                ID = pProducto_ID;

            SET NEW_DCTO = IF ((Dia = 'Monday' AND Tipo BETWEEN 1 AND 2) OR (Dia = 'Tuesday' AND Tipo BETWEEN 3 AND 4) OR (Dia = 'Wednesday' AND Tipo BETWEEN 5 AND 6) OR (Dia = 'Thursday' AND Tipo BETWEEN 7 AND 8) OR (Dia = 'Friday' AND Tipo BETWEEN 9 AND 10) OR (Dia = 'Saturday' AND Tipo BETWEEN 11 AND 12) OR (Dia = 'Sunday' AND Tipo BETWEEN 13 AND 14), DCTO, 1);

            UPDATE Productos
            SET ID_Descuento = NEW_DCTO
            WHERE ID = pProducto_ID;

            INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
            ("EVENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pProducto_ID);
        END LOOP;
    CLOSE cursor_producto;
END//

-- 20. revisar los descuentos aplicados a Clientes
CREATE EVENT RevisarDCTO
ON SCHEDULE EVERY 1 DAY
STARTS '2024-10-20 00:00:00'
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'RevisarDCTO';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT 'Descuento de Clientes Revisado';
    DECLARE fin INT DEFAULT 0;
    DECLARE pCliente_ID INT;
    DECLARE pMeses INT;
    DECLARE cursor_cliente CURSOR FOR SELECT ID FROM Clientes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cursor_cliente;

    clientes_loop: LOOP
        IF fin THEN
            LEAVE clientes_loop;
        END IF;
        FETCH cursor_cliente INTO pCliente_ID;

        SET pMeses = AntiguedadCliente(pCliente_ID);

        IF pMeses < 6 THEN
            UPDATE Clientes
            SET ID_Descuento = 1
            WHERE ID = pCliente_ID;
        ELSEIF pMeses >= 42 THEN
            UPDATE Clientes
            SET ID_Descuento = 8
            WHERE ID = pCliente_ID;
        ELSEIF pMeses >= 36 THEN
            UPDATE Clientes
            SET ID_Descuento = 7
            WHERE ID = pCliente_ID;
        ELSEIF pMeses >= 30 THEN
            UPDATE Clientes
            SET ID_Descuento = 6
            WHERE ID = pCliente_ID;
        ELSEIF pMeses >= 24 THEN
            UPDATE Clientes
            SET ID_Descuento = 5
            WHERE ID = pCliente_ID;
        ELSEIF pMeses >= 18 THEN
            UPDATE Clientes
            SET ID_Descuento = 4
            WHERE ID = pCliente_ID;
        ELSEIF pMeses >= 12 THEN
            UPDATE Clientes
            SET ID_Descuento = 3
            WHERE ID = pCliente_ID;
        ELSE
            UPDATE Clientes
            SET ID_Descuento = 2
            WHERE ID = pCliente_ID;
        END IF;
    END LOOP;

    CLOSE cursor_cliente;

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("EVENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END //

DROP EVENT RevisarDCTO
DELIMITER ;

SELECT 
    EVENT_SCHEMA AS Base_De_Datos,
    EVENT_NAME AS Nombre_Evento,
    EVENT_DEFINITION AS Definicion,
    EVENT_TYPE AS Tipo_Evento,
    EXECUTE_AT AS Fecha_Ejecucion_Unica,
    INTERVAL_VALUE AS Valor_Intervalo,
    INTERVAL_FIELD AS Unidad_Intervalo,
    STARTS AS Fecha_Inicio,
    ENDS AS Fecha_Finalizacion,
    STATUS AS Estado,
    LAST_EXECUTED AS Ultima_Ejecucion,
    ON_COMPLETION AS Comportamiento_Despues
FROM 
    information_schema.EVENTS
WHERE 
    EVENT_SCHEMA = 'finca_el_primer_mundo';