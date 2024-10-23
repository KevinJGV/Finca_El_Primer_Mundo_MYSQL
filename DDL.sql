DROP DATABASE IF EXISTS Finca_El_Primer_Mundo;

CREATE DATABASE IF NOT EXISTS Finca_El_Primer_Mundo;

USE Finca_El_Primer_Mundo;

CREATE TABLE IF NOT EXISTS
    Estados (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Departamentos (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Ciudades (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL,
        ID_Departamento INT NOT NULL,
        FOREIGN KEY (ID_Departamento) REFERENCES Departamentos (ID),
        UNIQUE (Nombre, ID_Departamento)
    );

CREATE TABLE IF NOT EXISTS
    Descuentos (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Valor INT NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Tipos_Proveedores (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Tipos_Recursos (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Tipos_Productos (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Tipos_Empleados (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Tipos_Tareas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Medios_de_Pago (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo VARCHAR(50) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Unidades_Medida (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Unidad VARCHAR(20) NOT NULL UNIQUE
    );

CREATE TABLE IF NOT EXISTS
    Lotes (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Fecha_Produccion DATE NOT NULL,
        Cantidad INT NOT NULL
    );

CREATE TABLE IF NOT EXISTS
    Sectores (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL UNIQUE,
        Hectareas DECIMAL(9, 2) NOT NULL
    );

CREATE TABLE IF NOT EXISTS
    Clientes (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Fecha_Nacimiento DATE NOT NULL,
        Telefono BIGINT,
        ID_Estado INT NOT NULL,
        ID_Descuento INT NOT NULL,
        ID_Ciudad INT NOT NULL,
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID),
        FOREIGN KEY (ID_Descuento) REFERENCES Descuentos (ID),
        FOREIGN KEY (ID_Ciudad) REFERENCES Ciudades (ID)
    );

CREATE TABLE IF NOT EXISTS
    Empleados (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL,
        Apellido VARCHAR(50) NOT NULL,
        Salario DECIMAL(9, 2) NOT NULL,
        Fecha_Contratacion DATE NOT NULL,
        ID_Estado INT NOT NULL,
        ID_Tipo_Empleado INT NOT NULL,
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID),
        FOREIGN KEY (ID_Tipo_Empleado) REFERENCES Tipos_Empleados (ID)
    );

CREATE TABLE IF NOT EXISTS
    Ventas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Fecha DATE NOT NULL,
        Total DECIMAL(9, 2) NOT NULL,
        ID_Cliente INT NOT NULL,
        ID_Empleado INT NOT NULL,
        ID_Medio_de_Pago INT NOT NULL,
        FOREIGN KEY (ID_Cliente) REFERENCES Clientes (ID),
        FOREIGN KEY (ID_Empleado) REFERENCES Empleados (ID),
        FOREIGN KEY (ID_Medio_de_Pago) REFERENCES Medios_de_Pago (ID)
    );

CREATE TABLE IF NOT EXISTS
    Recursos (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL,
        Stock INT NOT NULL,
        Costo DECIMAL(9, 2) NOT NULL,
        Recurso_Padre_ID INT,
        Recurso_Generador_ID INT,
        ID_Estado INT NOT NULL,
        ID_Tipo_Recurso INT NOT NULL,
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID),
        FOREIGN KEY (ID_Tipo_Recurso) REFERENCES Tipos_Recursos (ID),
        FOREIGN KEY (Recurso_Padre_ID) REFERENCES Recursos (ID),
        FOREIGN KEY (Recurso_Generador_ID) REFERENCES Recursos (ID)
    );

CREATE TABLE IF NOT EXISTS
    Productos (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL,
        Stock INT NOT NULL,
        Valor DECIMAL(9, 2) NOT NULL,
        Costo DECIMAL(9, 2) NOT NULL,
        ID_Descuento INT NOT NULL,
        ID_Estado INT NOT NULL,
        ID_Tipo_Producto INT NOT NULL,
        ID_Lote INT NOT NULL,
        ID_Recurso INT NOT NULL,
        FOREIGN KEY (ID_Descuento) REFERENCES Descuentos (ID),
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID),
        FOREIGN KEY (ID_Tipo_Producto) REFERENCES Tipos_Productos (ID),
        FOREIGN KEY (ID_Lote) REFERENCES Lotes (ID),
        FOREIGN KEY (ID_Recurso) REFERENCES Recursos (ID)
    );

CREATE TABLE IF NOT EXISTS
    Detalles_Ventas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Cantidad INT NOT NULL,
        Subtotal DECIMAL(9, 2) NOT NULL,
        ID_Venta INT NOT NULL,
        ID_Producto INT NOT NULL,
        FOREIGN KEY (ID_Venta) REFERENCES Ventas (ID),
        FOREIGN KEY (ID_Producto) REFERENCES Productos (ID)
    );

CREATE TABLE IF NOT EXISTS
    Proveedores (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Nombre VARCHAR(50) NOT NULL UNIQUE,
        ID_Estado INT NOT NULL,
        ID_Tipo_Proveedor INT NOT NULL,
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID),
        FOREIGN KEY (ID_Tipo_Proveedor) REFERENCES Tipos_Proveedores (ID)
    );

CREATE TABLE IF NOT EXISTS
    Compras (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Fecha DATE NOT NULL,
        Total DECIMAL(9, 2) NOT NULL,
        ID_Proveedor INT NOT NULL,
        ID_Estado INT NOT NULL,
        FOREIGN KEY (ID_Proveedor) REFERENCES Proveedores (ID),
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID)
    );

CREATE TABLE IF NOT EXISTS
    Detalles_Compras (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Precio_Unitario DECIMAL(9, 2) NOT NULL,
        Cantidad INT NOT NULL,
        Subtotal DECIMAL(9, 2) NOT NULL,
        ID_Compra INT NOT NULL,
        ID_Recurso INT NOT NULL,
        FOREIGN KEY (ID_Compra) REFERENCES Compras (ID),
        FOREIGN KEY (ID_Recurso) REFERENCES Recursos (ID)
    );

CREATE TABLE IF NOT EXISTS
    Tareas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Descripción TEXT NOT NULL,
        Fecha_inicio DATE NOT NULL,
        Fecha_fin DATE NOT NULL,
        Resultado_Porcentaje DECIMAL(9, 2) NOT NULL,
        ID_Sector INT NOT NULL,
        ID_Estado INT NOT NULL,
        ID_Tipo_Tarea INT NOT NULL,
        FOREIGN KEY (ID_Sector) REFERENCES Sectores (ID),
        FOREIGN KEY (ID_Estado) REFERENCES Estados (ID),
        FOREIGN KEY (ID_Tipo_Tarea) REFERENCES Tipos_Tareas (ID)
    );

CREATE TABLE IF NOT EXISTS
    Recursos_Tareas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        ID_Recurso INT NOT NULL,
        ID_Tarea INT NOT NULL,
        FOREIGN KEY (ID_Recurso) REFERENCES Recursos (ID),
        FOREIGN KEY (ID_Tarea) REFERENCES Tareas (ID)
    );

CREATE TABLE IF NOT EXISTS
    Empleados_Tareas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        ID_Empleado INT NOT NULL,
        ID_Tarea INT NOT NULL,
        FOREIGN KEY (ID_Empleado) REFERENCES Empleados (ID),
        FOREIGN KEY (ID_Tarea) REFERENCES Tareas (ID)
    );








-- Tablas de registro.

CREATE TABLE IF NOT EXISTS
    Notificaciones (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        ID_Cliente INT NOT NULL,
        Mensaje TEXT NOT NULL,
        Fecha DATETIME NOT NULL
    );

CREATE TABLE IF NOT EXISTS
    ResumenVentas (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Fecha DATE NOT NULL,
        TotalVentas DECIMAL(9,2)
    );

CREATE TABLE IF NOT EXISTS
    Recordatorios (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        ID_Empleado INT NOT NULL,
        Mensaje TEXT NOT NULL,
        Fecha DATETIME NOT NULL
    );

CREATE TABLE IF NOT EXISTS
    Logs (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tipo_Actividad ENUM('PROCEDIMIENTO', 'FUNCION', 'TRIGGER', 'EVENTO') NOT NULL,
        Nombre_Actividad VARCHAR(50) NOT NULL,
        Fecha DATETIME NOT NULL,
        Usuario_Ejecutor VARCHAR(50),
        Detalles TEXT NOT NULL,
        Tabla_Afectada VARCHAR(50) NOT NULL,
        ID_Referencia INT
    );

CREATE TABLE
    Resultados_Mensuales (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tabla_Nombre VARCHAR(50) NOT NULL,
        ID_Referencia INT,
        Nombre_Resultado VARCHAR(50) NOT NULL,
        Fecha_Resultado DATETIME NOT NULL,
        Descripcion VARCHAR(100) NOT NULL,
        Resultado DECIMAL(9,2) NOT NULL
    );

CREATE TABLE
    Resultados_Anuales (
        ID INT PRIMARY KEY AUTO_INCREMENT,
        Tabla_Nombre VARCHAR(50) NOT NULL,
        ID_Referencia INT,
        Nombre_Resultado VARCHAR(50) NOT NULL,
        Año_Resultado YEAR NOT NULL,
        Descripcion VARCHAR(100) NOT NULL,
        Resultado DECIMAL(9,2) NOT NULL
    );