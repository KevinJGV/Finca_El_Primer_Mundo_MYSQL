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

-- 37 Muestra los clientes con su descuento.
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

-- 41 Muestra todos los recursos que pertenecen al sector de Ganaderia por medio de las tareas.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    se.Nombre AS Sector,
    se.Hectareas
FROM Recursos_Tareas rt
INNER JOIN Recursos re ON rt.ID_Recurso = re.ID
INNER JOIN Tareas ta ON rt.ID_Tarea = ta.ID
INNER JOIN Sectores se ON ta.ID_Sector = se.ID
WHERE se.Nombre = "Ganaderia";
-- By @JavierEAcevedoN

-- 42 Muestra todos los clientes que tiene un 30% de descuento.
SELECT 
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.Fecha_Nacimiento,
    cl.Telefono,
    CONCAT(de.Valor,"%") AS Descuento
FROM Clientes cl
INNER JOIN Descuentos de ON cl.ID_Descuento = de.ID
WHERE de.Valor = 30;
-- By @JavierEAcevedoN

-- 43 Muestra el stock total de todos los productos.
SELECT
    SUM(Stock) AS TotalStock
FROM Productos;
-- By @JavierEAcevedoN

-- 44
SELECT
    AVG(Valor) AS TotalStock
FROM Productos;
-- By @JavierEAcevedoN

-- 45 Muestra los productos que se han vendido.
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
INNER JOIN Productos pr ON dv.ID_Producto = pr.ID
WHERE ve.ID IN (
    SELECT ID_Venta FROM Detalles_Ventas
);
-- By @JavierEAcevedoN

-- 46 Muestra los productos que valen menos de 1000.
SELECT 
    Nombre,
    Stock,
    Valor,
    Costo
FROM Productos
WHERE Valor < 1000;
-- By @JavierEAcevedoN

-- 47
SELECT 
    Nombre,
    Stock,
    Valor,
    Costo
FROM Productos
WHERE Stock < 5;
-- By @JavierEAcevedoN

-- 48 Muestra los recursos utilizados en una tarea especifica.
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
INNER JOIN Tareas ta ON rt.ID_Tarea = ta.ID
WHERE rt.ID = 1;
-- By @JavierEAcevedoN

-- 49 Muestra los empleados que estan relacionados con el sector de Crianza de Aves por medio de las tareas.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    se.Nombre AS Sector
FROM Empleados_Tareas et
INNER JOIN Empleados em ON et.ID_Empleado = em.ID
INNER JOIN Tareas ta ON et.ID_Tarea = ta.ID
INNER JOIN Sectores se ON ta.ID_Sector = se.ID
WHERE se.Nombre = "Crianza de Aves";
-- By @JavierEAcevedoN

-- 50 Muestra los empleados que estan relacionados con el sector que tiene mas de 15 hectarias por medio de las tareas.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    se.Nombre AS Sector,
    se.Hectareas
FROM Empleados_Tareas et
INNER JOIN Empleados em ON et.ID_Empleado = em.ID
INNER JOIN Tareas ta ON et.ID_Tarea = ta.ID
INNER JOIN Sectores se ON ta.ID_Sector = se.ID
WHERE se.Hectareas > 15;
-- By @JavierEAcevedoN

-- 51 Muestra los recursos comprados que vienen por cada proveedor.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    pr.Nombre AS Proveedor
FROM Detalles_Compras dc
INNER JOIN Recursos re ON dc.ID_Recurso = re.ID
INNER JOIN Compras co ON dc.ID_Compra = co.ID
INNER JOIN Proveedores pr ON co.ID_Proveedor = pr.ID;
-- By @JavierEAcevedoN

-- 52 Muestra la cantidad de recursos por cada tipo.
SELECT
    COUNT(re.ID) AS CantidadRecursos,
    tr.Tipo
FROM Recursos re
INNER JOIN Tipos_Recursos tr ON re.ID_Tipo_Recurso = tr.ID
GROUP BY tr.Tipo;
-- By @JavierEAcevedoN

-- 53 Muestra la cantidad de recursos comprados por cada proveedor.
SELECT
    COUNT(re.ID) AS CantidadRecursos,
    pr.Nombre AS Proveedor
FROM Detalles_Compras dc
INNER JOIN Recursos re ON dc.ID_Recurso = re.ID
INNER JOIN Compras co ON dc.ID_Compra = co.ID
INNER JOIN Proveedores pr ON co.ID_Proveedor = pr.ID
GROUP BY pr.Nombre;
-- By @JavierEAcevedoN

-- 54 Muestra la cantidad de tareas por sector.
SELECT
    COUNT(ta.ID) AS CantidadTareas,
    se.Nombre AS Sector
FROM Tareas ta
INNER JOIN Sectores se ON ta.ID_Sector = se.ID
GROUP BY se.Nombre;
-- By @JavierEAcevedoN

-- 55 Muestra la cantidad de tareas por tipo de tarea.
SELECT 
    COUNT(ta.ID) AS CantidadTareas,
    tt.Tipo
FROM Tareas ta
INNER JOIN Tipos_Tareas tt ON ta.ID_Tipo_Tarea = tt.ID
GROUP BY tt.Tipo;
-- By @JavierEAcevedoN

-- 56 Muestra la cantidad de clientes por ciudad.
SELECT
    COUNT(cl.ID) AS CantidadClientes,
    ci.Nombre AS Ciudad,
    GROUP_CONCAT(DISTINCT de.Nombre SEPARATOR ", ") AS Departamento
FROM Clientes cl
INNER JOIN Ciudades ci ON cl.ID_Ciudad = ci.ID
INNER JOIN Departamentos de ON ci.ID_Departamento = de.ID
GROUP BY ci.Nombre;
-- By @JavierEAcevedoN

-- 57 Muestra la cantidad de clientes por departamento.
SELECT
    COUNT(cl.ID) AS CantidadClientes,
    de.Nombre AS Departamento
FROM Clientes cl
INNER JOIN Ciudades ci ON cl.ID_Ciudad = ci.ID
INNER JOIN Departamentos de ON ci.ID_Departamento = de.ID
GROUP BY de.Nombre;
-- By @JavierEAcevedoN

-- 58 Muestra la cantidad de ventas por cada medio de pago.
SELECT
    COUNT(ve.ID) AS CantidadVentas,
    mp.Tipo AS MedioDePago
FROM Ventas ve
INNER JOIN Medios_de_Pago mp ON ve.ID_Medio_de_Pago = mp.ID
GROUP BY mp.Tipo;
-- By @JavierEAcevedoN

-- 59 Muestra las ventas por cada empleado.
SELECT
    NumeroVentasEmpleado(em.ID),
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto
FROM Ventas ve
INNER JOIN Empleados em ON ve.ID_Empleado = em.ID
GROUP BY em.ID;
-- By @JavierEAcevedoN

-- 60 Muestra las ventas por cada cliente.
SELECT
    NumeroVentasCliente(cl.ID) AS CantidadVentas,
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto
FROM Ventas ve
INNER JOIN Clientes cl ON ve.ID_Cliente = cl.ID
GROUP BY cl.ID;
-- By @JavierEAcevedoN

-- 61 Cantidad de productos por cada descuento.
SELECT 
    COUNT(pr.ID) AS CantidadProductos,
    CONCAT(de.Valor,"%") AS Descuento
FROM Productos pr
INNER JOIN Descuentos de ON pr.ID_Descuento = de.ID
GROUP BY de.Valor;
-- By @JavierEAcevedoN

-- 62 Muestra las cantidad de productos por tipo de producto.
SELECT
    COUNT(ID) AS CantidadProductos,
    GROUP_CONCAT(DISTINCT ObtenerTipoProducto(ID) SEPARATOR ", ") AS TipoProducto
FROM Productos
GROUP BY ID_Tipo_Producto;
-- By @JavierEAcevedoN

-- 63 Muestra los productos por cada lote.
SELECT 
    COUNT(pr.ID),
    lo.Cantidad,
    lo.Fecha_Produccion
FROM Productos pr
INNER JOIN Lotes lo ON pr.ID_Lote = lo.ID
GROUP BY pr.ID_Lote;
-- By @JavierEAcevedoN

-- 64 Clientes que han realizado compras cuyo total es mayor que el promedio de todas las ventas.
SELECT
    CONCAT(Nombre,' ',Apellido) AS NombreCompleto,
    Fecha_Nacimiento,
    Telefono
FROM Clientes
WHERE ID IN (
    SELECT
        ID_Cliente
    FROM Ventas
    WHERE Total > (
        SELECT
            AVG(Total)
        FROM Ventas
    )
)
-- By @JavierEAcevedoN

-- 65 Empleados que han trabajado en tareas de sectores con el mayor número de hectáreas
SELECT
    CONCAT(E.Nombre,' ',E.Apellido) AS NombreCompleto,
    E.Fecha_Contratacion,
    E.Salario
FROM Empleados E
WHERE E.ID IN (SELECT ET.ID_Empleado 
               FROM Empleados_Tareas ET
               JOIN Tareas T ON ET.ID_Tarea = T.ID
               WHERE T.ID_Sector = (SELECT ID FROM Sectores 
                                    ORDER BY Hectareas DESC LIMIT 1));


-- By @JavierEAcevedoN

-- 66 Proveedores que han realizado compras en el estado con el mayor total de compras.
SELECT
    Nombre
FROM Proveedores 
WHERE ID IN (SELECT ID_Proveedor 
               FROM Compras 
               WHERE ID_Estado = (SELECT ID_Estado 
                                  FROM Compras 
                                  GROUP BY ID_Estado 
                                  ORDER BY SUM(Total) DESC LIMIT 1));
-- By @JavierEAcevedoN

-- 67 Ventas realizadas por empleados cuyo salario es superior al salario promedio de todos los empleados.
SELECT 
    ID,
    Fecha,
    Total
FROM Ventas
WHERE ID_Empleado IN (SELECT ID 
                      FROM Empleados 
                      WHERE Salario > (SELECT AVG(Salario) FROM Empleados));
-- By @JavierEAcevedoN

-- 68 Recursos que han sido utilizados en el mayor número de tareas.
SELECT
    Nombre
FROM Recursos
WHERE ID IN (SELECT ID_Recurso 
             FROM Recursos_Tareas 
             GROUP BY ID_Recurso 
             ORDER BY COUNT(*));
-- By @JavierEAcevedoN

-- 69 Descuentos aplicados a productos cuyo costo es superior al costo promedio de productos de su tipo.
SELECT
    Nombre
FROM Productos
WHERE Costo > (SELECT AVG(Costo) 
               FROM Productos AS P2 
               WHERE P2.ID_Tipo_Producto = Productos.ID_Tipo_Producto);

-- By @JavierEAcevedoN

-- 70 Los productos con un el valor mayor al promedio del valor de los productos.
SELECT
    Nombre,
    Valor
FROM Productos
WHERE Costo > (SELECT AVG(Valor) 
               FROM Productos);
-- By @JavierEAcevedoN

-- 71 Los productos con un el valor menor al promedio del valor de los productos.
SELECT
    Nombre,
    Valor
FROM Productos
WHERE Costo < (SELECT AVG(Valor) 
               FROM Productos);
-- By @JavierEAcevedoN

-- 72 Los productos con un el costo mayor al promedio del costo de los productos.
SELECT
    Nombre,
    Costo
FROM Productos
WHERE Costo > (SELECT AVG(Costo) 
               FROM Productos);
-- By @JavierEAcevedoN

-- 73 Los productos con un el costo menor al promedio del costo de los productos.
SELECT
    Nombre,
    Costo
FROM Productos
WHERE Costo < (SELECT AVG(Costo) 
               FROM Productos);
-- By @JavierEAcevedoN

-- 74 Empleados con ventas con el total mayor que el promedio del total de ventas.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    ve.Fecha,
    ve.Total
FROM Ventas ve
INNER JOIN Empleados em ON ve.ID_Empleado = em.ID
WHERE `Total` > (
    SELECT
        AVG(`Total`)
    FROM `Ventas`
);
-- By @JavierEAcevedoN

-- 75 Empleados que han vendido un producto con un tipo especifico.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    ve.Fecha,
    ve.Total,
    dv.Cantidad,
    dv.Subtotal,
    pr.Nombre AS Producto,
    pr.Stock,
    pr.Valor,
    pr.Costo,
    tp.`Tipo` AS TipoProducto
FROM Detalles_Ventas dv
INNER JOIN Ventas ve ON dv.ID_Venta = ve.ID
INNER JOIN `Empleados` em ON ve.`ID_Empleado` = em.`ID`
INNER JOIN Productos pr ON dv.ID_Producto = pr.ID
INNER JOIN `Tipos_Productos` tp ON pr.`ID_Tipo_Producto` = tp.`ID`
WHERE tp.`Tipo` = "Fruta";
-- By @JavierEAcevedoN

-- 76 Empleados con ventas con el total menor que el promedio del total de ventas.
SELECT
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario,
    ve.Fecha,
    ve.Total
FROM Ventas ve
INNER JOIN Empleados em ON ve.ID_Empleado = em.ID
WHERE `Total` < (
    SELECT
        AVG(`Total`)
    FROM `Ventas`
);
-- By @JavierEAcevedoN

-- 77 Clientes que han vendido un producto con un tipo especifico.
SELECT
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.`Fecha_Nacimiento`,
    cl.`Telefono`,
    ve.Fecha,
    ve.Total,
    dv.Cantidad,
    dv.Subtotal,
    pr.Nombre AS Producto,
    pr.Stock,
    pr.Valor,
    pr.Costo,
    tp.`Tipo` AS TipoProducto
FROM Detalles_Ventas dv
INNER JOIN Ventas ve ON dv.ID_Venta = ve.ID
INNER JOIN `Clientes` cl ON ve.`ID_Empleado` = cl.`ID`
INNER JOIN Productos pr ON dv.ID_Producto = pr.ID
INNER JOIN `Tipos_Productos` tp ON pr.`ID_Tipo_Producto` = tp.`ID`
WHERE tp.`Tipo` = "Huevo";
-- By @JavierEAcevedoN

-- 78 Los clientes que tienen el mismo decuento que un productos.
SELECT
    CONCAT(cl.Nombre,' ',cl.Apellido) AS NombreCompleto,
    cl.Fecha_Nacimiento,
    cl.Telefono,
    CONCAT(de.Valor,'%') AS Descuento,
    pr.`Nombre`,
    pr.Stock,
    pr.Valor,
    pr.Costo
FROM Clientes cl
INNER JOIN Descuentos de ON cl.ID_Descuento = de.ID
INNER JOIN `Productos` pr ON de.`ID` = pr.`ID_Descuento`
-- By @JavierEAcevedoN

-- 79 Empleados que estan relacionados a tareas que estan relacionados a recursos.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    CONCAT(em.Nombre,' ',em.Apellido) AS NombreCompleto,
    em.Fecha_Contratacion,
    em.Salario
FROM Recursos_Tareas rt
INNER JOIN Recursos re ON rt.ID_Recurso = re.ID
INNER JOIN Tareas ta ON rt.ID_Tarea = ta.ID
INNER JOIN Empleados_Tareas et ON et.`ID_Tarea` = ta.`ID`
INNER JOIN Empleados em ON et.ID_Empleado = em.ID;
-- By @JavierEAcevedoN

-- 80 Proveedores que tienen recursos asignados a tareas.
SELECT
    pr.Nombre AS Proveedor,
    co.Fecha,
    co.Total,
    dc.Cantidad,
    dc.Subtotal,
    ta.Descripción,
    re.Nombre
FROM Recursos re
INNER JOIN Detalles_Compras dc ON re.`ID` = dc.`ID_Compra`
INNER JOIN Compras co ON dc.ID_Compra = co.ID
INNER JOIN Proveedores pr ON co.ID_Proveedor = pr.ID
INNER JOIN Recursos_Tareas rt ON rt.ID_Recurso = re.ID
INNER JOIN Tareas ta ON rt.ID_Tarea = ta.ID
-- By @JavierEAcevedoN

-- 81 Muestra los recursos que se usan en tareas de tipo Siembra.
SELECT 
    re.Nombre,
    re.Stock,
    re.Costo,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    tt.Tipo
FROM `Recursos_Tareas` rt
INNER JOIN `Tareas` ta ON rt.`ID_Tarea` = ta.`ID`
INNER JOIN Recursos re ON rt.ID_Recurso = re.ID
INNER JOIN `Tipos_Tareas` tt ON  ta.`ID_Tipo_Tarea` = tt.`ID`
WHERE tt.`Tipo` = "Siembra"
-- By @JavierEAcevedoN

-- 82 Muestra los recursos que se usan en tareas de tipo Mantenimiento de cultivos.
SELECT 
    re.Nombre,
    re.Stock,
    re.Costo,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    tt.Tipo
FROM `Recursos_Tareas` rt
INNER JOIN `Tareas` ta ON rt.`ID_Tarea` = ta.`ID`
INNER JOIN Recursos re ON rt.ID_Recurso = re.ID
INNER JOIN `Tipos_Tareas` tt ON  ta.`ID_Tipo_Tarea` = tt.`ID`
WHERE tt.`Tipo` = "Mantenimiento de cultivos"
-- By @JavierEAcevedoN

-- 83 Muestra los recursos que se usan en tareas de tipo Control de calidad.
SELECT 
    re.Nombre,
    re.Stock,
    re.Costo,
    ta.Descripción,
    ta.Fecha_inicio,
    ta.Fecha_fin,
    ta.Resultado_Porcentaje,
    tt.Tipo
FROM `Recursos_Tareas` rt
INNER JOIN `Tareas` ta ON rt.`ID_Tarea` = ta.`ID`
INNER JOIN Recursos re ON rt.ID_Recurso = re.ID
INNER JOIN `Tipos_Tareas` tt ON  ta.`ID_Tipo_Tarea` = tt.`ID`
WHERE tt.`Tipo` = "Control de calidad"
-- By @JavierEAcevedoN

-- 84
SELECT * FROM

-- 85
SELECT * FROM

-- 86
SELECT * FROM

-- 87
SELECT * FROM

-- 88
SELECT * FROM

-- 89
SELECT * FROM

-- 90
SELECT * FROM

-- 91
SELECT * FROM

-- 92
SELECT * FROM

-- 93
SELECT * FROM

-- 94
SELECT * FROM

-- 95
SELECT * FROM

-- 96
SELECT * FROM

-- 97
SELECT * FROM

-- 98
SELECT * FROM

-- 99
SELECT * FROM

-- 100
SELECT * FROM