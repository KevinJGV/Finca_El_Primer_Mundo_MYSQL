USE Finca_El_Primer_Mundo;

-- Administrador.
-- Tiene todos los permisos a todas las tablas de las base de datos (Finca_El_Primer_Mundo).
CREATE USER 'AdministradorFinca'@'localhost' IDENTIFIED BY 'QLD3214@rtv';
GRANT ALL PRIVILEGES ON Finca_El_Primer_Mundo.* TO 'AdministradorFinca'@'localhost';
-- By @JavierEAcevedoN

-- Vendedor.
CREATE USER 'VendedorFinca'@'localhost' IDENTIFIED BY 'SDQ3324@fes';
GRANT SELECT, INSERT, UPDATE ON Finca_El_Primer_Mundo.Ventas TO 'VendedorFinca'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Finca_El_Primer_Mundo.Detalles_Ventas TO 'VendedorFinca'@'localhost';
GRANT SELECT, INSERT ON Finca_El_Primer_Mundo.Clientes TO 'VendedorFinca'@'localhost';
GRANT SELECT  ON Finca_El_Primer_Mundo.Productos TO 'VendedorFinca'@'localhost';
-- By @JavierEAcevedoN

-- Contador.
CREATE USER 'ContadorFinca'@'localhost' IDENTIFIED BY 'HTG1224@dac';
GRANT SELECT ON Finca_El_Primer_Mundo.Ventas TO 'ContadorFinca'@'localhost';
GRANT SELECT ON Finca_El_Primer_Mundo.Detalles_Ventas TO 'ContadorFinca'@'localhost';
GRANT SELECT ON Finca_El_Primer_Mundo.Compras TO 'ContadorFinca'@'localhost';
GRANT SELECT ON Finca_El_Primer_Mundo.Detalles_Compras TO 'ContadorFinca'@'localhost';
-- By @JavierEAcevedoN

-- Cliente.
CREATE USER 'ClienteFinca'@'localhost' IDENTIFIED BY 'TGDD3684@bnf';
GRANT SELECT (ID, Nombre, Stock, Valor, ID_Descuento, ID_Estado, ID_Tipo_Producto, ID_Lote)  ON Finca_El_Primer_Mundo.Productos TO 'ClienteFinca'@'localhost';

-- EspecialistaDeInventario.
CREATE USER 'EspecialistaDeInventarioFinca'@'localhost' IDENTIFIED BY 'GHJ859@fer';
GRANT SELECT, INSERT, UPDATE ON Finca_El_Primer_Mundo.Recursos TO 'EspecialistaDeInventarioFinca'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Finca_El_Primer_Mundo.Detalles_Compras TO 'EspecialistaDeInventarioFinca'@'localhost';
GRANT SELECT, INSERT, UPDATE ON Finca_El_Primer_Mundo.Compras TO 'EspecialistaDeInventarioFinca'@'localhost';
GRANT SELECT ON Finca_El_Primer_Mundo.Proveedores TO 'EspecialistaDeInventarioFinca'@'localhost';
-- By @JavierEAcevedoN