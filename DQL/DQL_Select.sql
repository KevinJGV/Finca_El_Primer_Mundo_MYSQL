USE Finca_El_Primer_Mundo;

-- 1 Muestra todos los productos con su estado actual.
SELECT 
    pr.Nombre,
    pr.Stock,
    pr.Valor,
    pr.Costo,
    es.Nombre AS Estado
FROM Productos pr
INNER JOIN Estados es ON pr.ID_Estado = es.ID;
-- By @JavierEAcevedoN

-- 2 Muestra todos los productos con su porcentaje de descuento y su descuento.
SELECT 
    pr.Nombre,
    pr.Stock,
    pr.Valor,
    pr.Costo,
    CONCAT(de.Valor,"%") AS Descuento,
    CalcularDescuentoProducto(pr.ID) AS ValorDescuento
FROM Productos pr
INNER JOIN Descuentos de ON pr.ID_Descuento = de.ID;
-- By @JavierEAcevedoN

-- 3 Mustra el tipo de producto de cada producto.
SELECT 
    Nombre,
    Stock,
    Valor,
    Costo,
    ObtenerTipoProducto(ID) AS TipoProducto
FROM Productos;
-- By @JavierEAcevedoN

-- 4 Muestra el lote de cada producto que esta relacionado.
SELECT 
    pr.Nombre,
    pr.Stock,
    pr.Valor,
    pr.Costo,
    lo.Cantidad,
    lo.Fecha_Produccion
FROM Productos pr
INNER JOIN Lotes lo ON pr.ID_Lote = lo.ID;
-- By @JavierEAcevedoN

-- 5 Muestra todos los productos con sus recursos especificos.
SELECT 
    pr.Nombre,
    pr.Stock,
    pr.Valor,
    pr.Costo,
    re.Nombre AS Recurso,
    re.Stock AS RecursoStock,
    re.Costo AS RecursoCosto
FROM Productos pr
INNER JOIN Recursos re ON pr.ID_Recurso = re.ID;
-- By @JavierEAcevedoN

-- 6 Muestra los recursos con su estado.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    es.Nombre
FROM Recursos re
INNER JOIN Estados es ON re.ID_Estado = es.ID;
-- By @JavierEAcevedoN

-- 7 Muestra los tipos de recurso de los recursos.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    tr.Tipo
FROM Recursos re
INNER JOIN Tipos_Recursos tr ON re.ID_Tipo_Recurso = tr.ID;
-- By @JavierEAcevedoN

-- 8 Muestra los recursos padres relacionados de los recursos.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    rp.Nombre AS RecursoPadre,
    rp.Stock,
    rp.Costo
FROM Recursos re
INNER JOIN Recursos rp ON re.Recurso_Padre_ID = rp.ID;
-- By @JavierEAcevedoN

-- 9 Muestra los recursos con sus recursos generadores.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    rp.Nombre AS RecursoGenerador,
    rp.Stock,
    rp.Costo
FROM Recursos re
INNER JOIN Recursos rp ON re.Recurso_Generador_ID = rp.ID;
-- By @JavierEAcevedoN

-- 10 Muestra los Logs que tienen que ver con eventos.
SELECT * FROM Logs WHERE Tipo_Actividad = "EVENTO";
-- By @JavierEAcevedoN

-- 11 Muestra los Logs que tienen que ver con triggers.
SELECT * FROM Logs WHERE Tipo_Actividad = "TRIGGER";
-- By @JavierEAcevedoN

-- 12 Muestra los Logs que tienen que ver con procedimientos.
SELECT * FROM Logs WHERE Tipo_Actividad = "PROCEDIMIENTO";
-- By @JavierEAcevedoN

-- 13 Muestra los Logs que tienen que ver con funciones.
SELECT * FROM Logs WHERE Tipo_Actividad = "FUNCION";
-- By @JavierEAcevedoN

-- 14 Muestra las notificaciones a los clientes.
SELECT * FROM Notificaciones;
-- By @JavierEAcevedoN

-- 15 Muestra el resumen de ventas diario.
SELECT * FROM ResumenVentas;
-- By @JavierEAcevedoN

-- 16 Muestra los recordatorios a los empleados.
SELECT * FROM Recordatorios;
-- By @JavierEAcevedoN

-- 17 Muestra los resultados de ventas mensuales.
SELECT * FROM Resultados_Mensuales;
-- By @JavierEAcevedoN

-- 18 Muestra los resultados de ventas anuales.
SELECT * FROM Resultados_Anuales;
-- By @JavierEAcevedoN

-- 19 Muestra las notoficacioens del sistema.
SELECT * FROM Notificaciones_Sistema;
-- By @JavierEAcevedoN

-- 20 Muestra cuando se uso con que tarea se uso y que recurso se uso.
SELECT * FROM Reporte_Recursos_Usados;
-- By @JavierEAcevedoN

-- 21 Muestra las Tareas que hay con su tipo.
SELECT 
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    tt.Tipo
FROM Tareas ta
INNER JOIN Tipos_Tareas tt ON ta.ID_Tipo_Tarea = tt.ID;
-- By @JavierEAcevedoN

-- 22 Muestra las tareas con sus sectores a los que estan asignadas.
SELECT
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    se.Nombre AS Sector,
    se.Hectareas
FROM Tareas ta
INNER JOIN Sectores se ON ta.ID_Sector = se.ID;
-- By @JavierEAcevedoN

-- 23 Muestra las tareas con sus estados.
SELECT
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    es.Nombre AS EstadoTarea
FROM Tareas ta
INNER JOIN Estados es ON ta.ID_Estado = es.ID;
-- By @JavierEAcevedoN

-- 24 Muestra las empleados con sus tareas asignadas.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje
FROM Empleados_Tareas et
INNER JOIN Empleados em ON et.ID_Empleado = em.ID
INNER JOIN Tareas ta ON et.ID_Tarea = ta.ID;
-- By @JavierEAcevedoN

-- 25 Muestra los recursos con las tareas relacionadas.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje
FROM Recursos_Tareas rt
INNER JOIN Recursos re ON rt.ID_Recurso = re.ID
INNER JOIN Tareas ta ON rt.ID_Tarea = ta.ID;
-- By @JavierEAcevedoN

-- 26 Muestra las compras con sus recursos relacionados.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    dc.Cantidad,
    dc.Precio_Unitario,
    dc.Subtotal,
    co.Fecha,
    co.Total
FROM Detalles_Compras dc
INNER JOIN Recursos re ON dc.ID_Recurso = re.ID
INNER JOIN Compras co ON dc.ID_Compra = co.ID;
-- By @JavierEAcevedoN

-- 27 Muestra las compras con su estado.
SELECT
    co.Fecha,
    co.Total,
    es.Nombre AS EstadoCompra
FROM Compras co
INNER JOIN Estados es ON co.ID_Estado = es.ID;
-- By @JavierEAcevedoN

-- 28 Muestra a que proveedor se le hizo la compra.
SELECT
    co.Fecha,
    co.Total,
    pr.Nombre AS Proveedor
FROM Compras co
INNER JOIN Proveedores pr ON co.ID_Proveedor = pr.ID;
-- By @JavierEAcevedoN

-- 29 Muestra los proveedores con su estado.
SELECT
    pr.Nombre,
    es.Nombre AS Estado
FROM Proveedores pr
INNER JOIN Estados es ON pr.ID_Estado = es.ID;
-- By @JavierEAcevedoN

-- 30 Muestra los Proveedores con su tipo.
SELECT
    pr.Nombre,
    tp.Tipo AS TipoProveedor
FROM Proveedores pr
INNER JOIN Tipos_Proveedores tp ON pr.ID_Tipo_Proveedor = tp.ID;
-- By @JavierEAcevedoN

-- 31 Muestra las ventas con sus productos relacionados.
SELECT
    ve.Fecha,
    ve.Total,
    dv.Cantidad,
    dv.Subtotal,
    pr.Nombre AS Producto,
    pr.Stock,
    pr.Valor,
    pr.Costo
FROM Detalles_Ventas dv
INNER JOIN Ventas ve ON dv.ID_Venta = ve.ID
INNER JOIN Productos pr ON dv.ID_Producto = pr.ID;
-- By @JavierEAcevedoN

-- 32 Muestra las ventas con su medio de pago.
SELECT
    ve.Fecha,
    ve.Total,
    mp.Tipo AS MedioDePago
FROM Ventas ve
INNER JOIN Medios_de_Pago mp ON ve.ID_Medio_de_Pago = mp.ID;
-- By @JavierEAcevedoN

-- 33 Muestra las ventas con los empleados relacionados.
SELECT
    ve.Fecha,
    ve.Total,
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario
FROM Ventas ve
INNER JOIN Empleados em ON ve.ID_Empleado = em.ID;
-- By @JavierEAcevedoN

-- 34 Muestra las ventas con sus clientes relacionados.
SELECT
    ve.Fecha,
    ve.Total,
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.Fecha_Nacimiento,
    cl.Telefono
FROM Ventas ve
INNER JOIN Clientes cl ON ve.ID_Cliente = cl.ID;
-- By @JavierEAcevedoN

-- 35 Muestra los empleados con su tipo.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    te.Tipo AS TipoEmpleado
FROM Empleados em
INNER JOIN Tipos_Empleados te ON em.ID_Tipo_Empleado = te.ID;
-- By @JavierEAcevedoN

-- 36 Muestra los empleados con su estado.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    es.Nombre AS Estado
FROM Empleados em
INNER JOIN Estados es ON em.ID_Estado = es.ID;
-- By @JavierEAcevedoN

-- 37 Muestra lso clientes con su descuento.
SELECT
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.Fecha_Nacimiento,
    cl.Telefono,
    CONCAT(de.Valor,'%') AS Descuento 
FROM Clientes cl
INNER JOIN Descuentos de ON cl.ID_Descuento = de.ID;
-- By @JavierEAcevedoN

-- 38 Muestra la ciudad y el departamento de cada cliente.
SELECT
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.Fecha_Nacimiento,
    cl.Telefono,
    ci.Nombre AS Ciudad,
    de.Nombre AS Departamento
FROM Clientes cl
INNER JOIN Ciudades ci ON cl.ID_Ciudad = ci.ID
INNER JOIN Departamentos de ON ci.ID_Departamento = de.ID;
-- By @JavierEAcevedoN

-- 39 Muestra el estado del cliente.
SELECT
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.Fecha_Nacimiento,
    cl.Telefono,
    es.Nombre AS Estado
FROM Clientes cl
INNER JOIN Estados es ON cl.ID_Estado  = es.ID;
-- By @JavierEAcevedoN

-- 40 Muestra la edad de los clientes.
SELECT 
    CONCAT(Nombre,' ',Apellido) AS NombreCompleto,
    Fecha_Nacimiento,
    Telefono,
    (YEAR(NOW()) - YEAR(Fecha_Nacimiento)) AS Edad
FROM Clientes;
-- By @JavierEAcevedoN

-- 41
SELECT * FROM

-- 42
SELECT * FROM

-- 43
SELECT * FROM

-- 44
SELECT * FROM

-- 45
SELECT * FROM

-- 46
SELECT * FROM

-- 47
SELECT * FROM

-- 48
SELECT * FROM

-- 49
SELECT * FROM

-- 50
SELECT * FROM

-- 51
SELECT * FROM

-- 52
SELECT * FROM

-- 53
SELECT * FROM

-- 54
SELECT * FROM

-- 55
SELECT * FROM

-- 56
SELECT * FROM

-- 57
SELECT * FROM

-- 58
SELECT * FROM

-- 59
SELECT * FROM

-- 60
SELECT * FROM

-- 61
SELECT * FROM

-- 62
SELECT * FROM

-- 63
SELECT * FROM

-- 64
SELECT * FROM

-- 65
SELECT * FROM

-- 66
SELECT * FROM

-- 67
SELECT * FROM

-- 68
SELECT * FROM

-- 69
SELECT * FROM

-- 70
SELECT * FROM

-- 71
SELECT * FROM

-- 72
SELECT * FROM

-- 73
SELECT * FROM

-- 74
SELECT * FROM

-- 75
SELECT * FROM

-- 76
SELECT * FROM

-- 77
SELECT * FROM

-- 78
SELECT * FROM

-- 79
SELECT * FROM

-- 80
SELECT * FROM

-- 81
SELECT * FROM

-- 82
SELECT * FROM

-- 83
SELECT * FROM

-- 84. Productos con descuento mayor al promedio
-- By @KevinJGV
SELECT 
    P.Nombre
FROM 
    Productos P
WHERE 
    P.ID_Descuento IN (
        SELECT 
            D.ID
        FROM 
            Descuentos D
        WHERE 
            D.Valor > (SELECT AVG(Valor) FROM Descuentos)
    );

-- 85. Tareas asignadas a empleados con el salario más alto de su tipo
-- By @KevinJGV
SELECT E.Nombre, T.Descripción
FROM Empleados_Tareas ET
JOIN Empleados E ON ET.ID_Empleado = E.ID
JOIN Tareas T ON ET.ID_Tarea = T.ID
WHERE E.Salario = (SELECT MAX(Salario) 
                   FROM Empleados 
                   WHERE ID_Tipo_Empleado = E.ID_Tipo_Empleado);

-- 86. Proveedores con recursos comprados en los últimos 3 meses
-- By @KevinJGV
SELECT 
    P.Nombre
FROM 
    Proveedores P
WHERE 
    P.ID IN (
        SELECT 
            C.ID_Proveedor
        FROM 
            Compras C
        WHERE 
            C.Fecha BETWEEN DATE_SUB(CURDATE(), INTERVAL 3 MONTH) AND CURDATE()
    );

-- 87. Recursos con costo mayor al costo promedio generado por otros
-- By @KevinJGV
SELECT 
    R.Nombre,
    R.Costo
FROM
    Recursos R
WHERE
    R.Costo > (
        SELECT
            AVG(R2.Costo)
        FROM
            Recursos R2
    );

-- 88. Sectores con más hectáreas que el promedio de todos los sectores
-- By @KevinJGV
SELECT
    S.Nombre,
    S.Hectareas
FROM
    Sectores S
WHERE
    S.Hectareas > (
        SELECT
            AVG(S2.Hectareas)
        FROM
            Sectores S2
    );

-- 89. Ciudad que tiene el mayor número de clientes
-- By @KevinJGV
SELECT
    Nombre
FROM
    Ciudades
WHERE
    ID = (
        SELECT
            ID_Ciudad
        FROM
            Clientes
        GROUP BY
            `ID_Ciudad`
        ORDER BY
            COUNT(*) DESC
        LIMIT 1
    );

-- 90. Tareas que han finalizado con un porcentaje superior al promedio de su sector
-- By @KevinJGV
SELECT 
    T.ID,
    T.Descripción
FROM
    Tareas T
WHERE
    T.Resultado_Porcentaje > (
        SELECT
            AVG(T2.Resultado_Porcentaje)
        FROM
            Tareas T2
        WHERE
            T.ID_Tipo_Tarea = T2.ID_Tipo_Tarea
    );

-- 91. Productos con valor superior al valor promedio de productos de su tipo
-- By @KevinJGV
SELECT
    P.Nombre,
    P.Valor
FROM
    Productos P
WHERE
    Valor > (
        SELECT
            AVG(P2.Valor)
        FROM
            Productos P2
        WHERE
            P.ID_Tipo_Producto = P2.ID_Tipo_Producto
    );

-- 92. Empleados con salario superior al promedio de su estado
-- By @KevinJGV
SELECT
    CONCAT(E.Nombre, ' ', E.Apellido) AS EMPLEADO,
    E.Salario
FROM
    Empleados E
WHERE
    Salario > (
        SELECT
            AVG(Salario)
        FROM
            Empleados E2
        WHERE
            E.ID_Estado = E2.ID_Estado);

-- 93. Proveedores con más de sus recursos en stock
-- By @KevinJGV
SELECT
    ID,
    Nombre
FROM
    Proveedores
WHERE
    ID_Estado = (
        SELECT
            ID_Estado
        FROM
            Recursos
        WHERE
            Stock = (
                SELECT
                    MAX(Stock)
                FROM
                    Recursos
            )
    );

-- 94. Clientes con el descuento más alto
-- By @KevinJGV
SELECT
    CONCAT(C.Nombre, ' ',C.Apellido) AS CLIENTE,
    D.Valor AS DESCUENTO
FROM
    Clientes C
    JOIN Descuentos D ON C.ID_Descuento = D.ID
WHERE
    C.ID_Descuento = (
        SELECT
            MAX(ID_Descuento)
        FROM
            Clientes
    );

-- 95. Tareas que a dia de hoy aun no hayan finalizado
-- By @KevinJGV
SELECT
    ID,
    Descripción,
    Fecha_inicio
FROM
    Tareas
WHERE
    Fecha_fin IS NULL;

-- 96. Empleados que realizan una tarea en un dia determinado
-- By @KevinJGV
SELECT 
    T.ID AS ID_TAREA,
    T.Descripción,
    CONCAT(E.Nombre, " ", E.Apellido) AS EMPLEADO,
    'Tarea en curso' AS ESTADO
FROM
    Tareas T
    JOIN Empleados_Tareas ET ON T.ID = ET.ID_Tarea
    JOIN Empleados E ON ET.ID_Empleado = E.ID
WHERE
    '2024-09-05' BETWEEN T.Fecha_inicio AND COALESCE(T.Fecha_fin,'2024-09-05');

-- 97. Ventas con productos que actualmente esten en estado Activo
-- By @KevinJGV
SELECT
    *
FROM
    Ventas V
    JOIN Detalles_Ventas DV ON V.ID = DV.ID_Venta
    JOIN Productos P ON DV.ID_Producto = P.ID
WHERE
    P.ID_Estado = 1

-- 98. Productos con un stock considerado bajo
-- By @KevinJGV
SELECT * FROM Productos WHERE Stock <= 80;

-- 99. Productos pertenecientes a un lote determinado que ademas sean de un tipo de producto determinado
-- By @KevinJGV
SELECT
    P.ID,
    P.Nombre AS Producto,
    P.ID_Lote,
    TP.Tipo
FROM
    Productos P
    JOIN Tipos_Productos TP ON P.ID_Tipo_Producto = TP.ID
WHERE
    P.ID_Lote = 2 AND P.ID_Tipo_Producto = 2;

-- 100. Tareas que tengan asignado un sector con igual o menos de 2 hectareas
-- By @KevinJGV
SELECT
    T.ID AS ID_TAREA,
    T.Descripción,
    T.ID_Sector,
    S.Hectareas
FROM
    Tareas T
    JOIN Sectores S ON T.ID_Sector = S.ID
WHERE
    S.Hectareas <= 2;