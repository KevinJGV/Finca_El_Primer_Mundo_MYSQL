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
BEGIN
END//

-- 12. Enviar Recordatorios de pago a clientes morosos.

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

-- 15. Enviar informes de ventas anuales a los gerentes.

CREATE EVENT ResultadosAnuales
ON SCHEDULE EVERY 1 YEAR
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ResultadosAnuales';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Resultados_Anuales';
    DECLARE Detalle TEXT DEFAULT 'Informe anual de ventas Generado';
    DECLARE Total_Ventas INT;
    DECLARE Total_Ingresos DECIMAL(9,2);
    SELECT COUNT(ID) INTO Total_Ventas FROM Ventas WHERE YEAR(Fecha) = YEAR(CURDATE());
    SELECT SUM(Total) INTO Total_Ingresos FROM Ventas WHERE YEAR(Fecha) = YEAR(CURDATE());

    INSERT INTO Resultados_Anuales(Tabla_Nombre,Nombre_Resultado,Fecha_Resultado,Descripcion,Resultado) VALUES
    ('Ventas','Resultados Anuales Ventas', YEAR(CURDATE()),'Cantidad de Ventas totales', Total_Ventas),
    ('Ventas','Resultados Anuales Ventas', YEAR(CURDATE()),'Ingresos Totales', Total_Ingresos);

    INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada) VALUES
    ("EVENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre);
END//

-- 16. Realizar auditorías mensuales de clientes.

CREATE EVENT AuditoriaCompras
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'AuditoriaCompras';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT 'Compras Cliente Calculado (Cantidad de ventas)';
    DECLARE pCliente_ID INT;
    DECLARE Compras DECIMAL(9,2);
    DECLARE fin INT;
    DECLARE cursor_clientes CURSOR FOR SELECT ID FROM Clientes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cursor_clientes;
        clientes_loop: LOOP
            FETCH cursor_clientes INTO pCliente_ID;
            IF fin THEN
                LEAVE clientes_loop;
            END IF;

            SET Compras = PorcentajeComprasxCliente(pCliente_ID);

            INSERT INTO Resultados_Mensuales(Tabla_Nombre,ID_Referencia,Nombre_Resultado,Fecha_Resultado,Descripcion,Resultado) VALUES
            (tabla_nombre,pCliente_ID, "Compras Mensual", NOW(),"Valor porcentual respecto a las ventas totales", Compras);

            INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
            ("EVENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pCliente_ID);
        END LOOP;
    CLOSE cursor_clientes;
END//

-- 17. Evaluar el rendimiento de los empleados.

CREATE EVENT RendimientoEmpleados
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'RendimientoEmpleados';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Empleados';
    DECLARE Detalle TEXT DEFAULT 'Rendimiento Empleado Calculado (Cantidad de ventas)';
    DECLARE pEmpleado_ID INT;
    DECLARE Rendimiento DECIMAL(9,2);
    DECLARE fin INT;
    DECLARE cursor_empleados CURSOR FOR SELECT ID FROM Empleados;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cursor_empleados;
        empleados_loop: LOOP
            FETCH cursor_empleados INTO pEmpleado_ID;
            IF fin THEN
                LEAVE empleados_loop;
            END IF;

            SET Rendimiento = PorcentajeVentasxEmpleado(pEmpleado_ID);
            IF ObtenerTipoEmpledo(pEmpleado_ID) = 2 THEN
                INSERT INTO Resultados_Mensuales(Tabla_Nombre,ID_Referencia,Nombre_Resultado,Fecha_Resultado,Descripcion,Resultado) VALUES
                (tabla_nombre,pEmpleado_ID, "Rendimiento Mensual", NOW(),"Valor porcentual respecto a las ventas totales", Rendimiento);
            END IF;

            INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
            ("EVENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pEmpleado_ID);
        END LOOP;
    CLOSE cursor_empleados;
END//

-- 18. Actualizar el estado de clientes inactivos.

CREATE EVENT ActivarClientes
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'ActivarClientes';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Clientes';
    DECLARE Detalle TEXT DEFAULT 'Cliente Activado';

    DECLARE pCliente_ID INT;
    DECLARE NEW_STATUS INT;
    DECLARE MAX_DATE DATE;
    DECLARE fin INT;
    DECLARE cursor_cliente CURSOR FOR SELECT ID FROM Clientes;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cursor_cliente;
        clientes_loop: LOOP
            FETCH cursor_cliente INTO pCliente_ID;
            IF fin THEN
                LEAVE clientes_loop;
            END IF;

            SET MAX_DATE = FechaUltimaVentaCliente(pCliente_ID);

            IF TIMESTAMPDIFF(YEAR,CURDATE(),MAX_DATE) <= 1 THEN
                UPDATE Clientes
                SET ID_Estado = 1
                WHERE ID = pCliente_ID;
            END IF;

            INSERT INTO Logs (Tipo_Actividad, Nombre_Actividad,Fecha,Usuario_Ejecutor,Detalles,Tabla_Afectada,ID_Referencia) VALUES
            ("EVENTO",proceso_nombre,NOW(),USER(),Detalle,tabla_nombre,pProducto_ID);
        END LOOP;
    CLOSE cursor_cliente;
END//

-- 19. Ajustar descuento de productos automáticamente segun un criterio especifico.

CREATE EVENT DCTOsegunProductoyDia
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    DECLARE proceso_nombre VARCHAR(50) DEFAULT 'DCTOsegunProductoyDia';
    DECLARE tabla_nombre VARCHAR(50) DEFAULT 'Productos';
    DECLARE Detalle TEXT DEFAULT 'Descuento de Producto Revisado';

    DECLARE pProducto_ID INT;
    DECLARE Tipo INT;
    DECLARE DCTO INT DEFAULT 5;
    DECLARE NEW_DCTO INT;
    DECLARE Dia VARCHAR(20);
    DECLARE fin INT DEFAULT 0;
    DECLARE cursor_producto CURSOR FOR SELECT ID FROM Productos; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    SET Dia = DAYNAME(CURDATE());

    OPEN cursor_producto;

        producto_loop: LOOP

            FETCH cursor_producto INTO pProducto_ID;

            IF fin THEN
                LEAVE producto_loop;
            END IF;

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
DELIMITER ;