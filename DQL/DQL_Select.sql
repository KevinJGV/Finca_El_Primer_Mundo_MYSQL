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

-- 3 Mustra el tipo de producto de cada producto.
SELECT 
    Nombre,
    Stock,
    Valor,
    Costo,
    ObtenerTipoProducto(ID) AS TipoProducto
FROM Productos;

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

-- 6 Muestra los recursos con su estado.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    es.Nombre
FROM Recursos re
INNER JOIN Estados es ON re.ID_Estado = es.ID;

-- 7 Muestra los tipos de recurso de los recursos.
SELECT
    re.Nombre,
    re.Stock,
    re.Costo,
    tr.Tipo
FROM Recursos re
INNER JOIN Tipos_Recursos tr ON re.ID_Tipo_Recurso = tr.ID;

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

-- 10 Muestra los Logs que tienen que ver con eventos.
SELECT * FROM Logs WHERE `Tipo_Actividad` = "Evento";

-- 11
SELECT * FROM

-- 12
SELECT * FROM

-- 13
SELECT * FROM

-- 14
SELECT * FROM

-- 15
SELECT * FROM

-- 16
SELECT * FROM

-- 17
SELECT * FROM

-- 18
SELECT * FROM

-- 19
SELECT * FROM

-- 20
SELECT * FROM

-- 21
SELECT * FROM

-- 22
SELECT * FROM

-- 23
SELECT * FROM

-- 24
SELECT * FROM

-- 25
SELECT * FROM

-- 26
SELECT * FROM

-- 27
SELECT * FROM

-- 28
SELECT * FROM

-- 29
SELECT * FROM

-- 30
SELECT * FROM

-- 31
SELECT * FROM

-- 32
SELECT * FROM

-- 33
SELECT * FROM

-- 34
SELECT * FROM

-- 35
SELECT * FROM

-- 36
SELECT * FROM

-- 37
SELECT * FROM

-- 38
SELECT * FROM

-- 39
SELECT * FROM

-- 40
SELECT * FROM

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