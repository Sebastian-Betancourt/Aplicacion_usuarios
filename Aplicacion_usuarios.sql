create database usuarios;
use usuarios;
-- Inicia sesión como super administrador (por ejemplo, root).

-- Crear usuario Super Administrador
CREATE USER 'superadmin'@'localhost' IDENTIFIED BY 'SuperSecurePassword1!';
GRANT CREATE, DROP ON *.* TO 'superadmin'@'localhost';
-- Super Administrador puede crear y eliminar bases de datos.

-- Crear usuario Administrador
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'AdminSecurePassword2!';
GRANT CREATE USER, PROCESS ON *.* TO 'admin'@'localhost';
-- Administrador puede crear usuarios y procesos.

-- Crear usuario CRUD
CREATE USER 'crud_user'@'localhost' IDENTIFIED BY 'CrudSecurePassword3!';
GRANT INSERT, UPDATE, DELETE ON *.* TO 'crud_user'@'localhost';
-- CRUD puede insertar, actualizar y eliminar datos.

-- Crear usuario CRU
CREATE USER 'cru_user'@'localhost' IDENTIFIED BY 'CruSecurePassword4!';
GRANT INSERT, UPDATE ON *.* TO 'cru_user'@'localhost';
-- CRU puede insertar y actualizar, pero no eliminar.

-- Crear usuario Solo Lectura
CREATE USER 'readonly_user'@'localhost' IDENTIFIED BY 'ReadOnlySecurePassword5!';
GRANT SELECT ON *.* TO 'readonly_user'@'localhost';
-- Solo Lectura puede realizar consultas a las tablas.

-- Verificación de permisos
SHOW GRANTS FOR 'superadmin'@'localhost';
SHOW GRANTS FOR 'admin'@'localhost';
SHOW GRANTS FOR 'crud_user'@'localhost';
SHOW GRANTS FOR 'cru_user'@'localhost';
SHOW GRANTS FOR 'readonly_user'@'localhost';

-- Parte 2
CREATE TABLE empleados (
    EmpID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Departamento VARCHAR(100) NOT NULL,
    Salario DECIMAL(10,2) NOT NULL
);

CREATE TABLE auditoria (
    AudID INT AUTO_INCREMENT PRIMARY KEY,
    Accion ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    EmpID INT,
    Nombre VARCHAR(100),
    Departamento VARCHAR(100),
    Salario DECIMAL(10,2),
    Fecha DATETIME NOT NULL
);
/*Trigger para AFTER INSERT*/
DELIMITER $$

CREATE TRIGGER trg_auditoria_empleados_insert
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('INSERT', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END$$

DELIMITER ;

/*Trigger para AFTER UPDATE*/
DELIMITER $$

CREATE TRIGGER trg_auditoria_empleados_update
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('UPDATE', NEW.EmpID, NEW.Nombre, NEW.Departamento, NEW.Salario, NOW());
END$$

DELIMITER ;



/*Trigger para AFTER DELETE*/
DELIMITER $$

CREATE TRIGGER trg_auditoria_empleados_delete
AFTER DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (Accion, EmpID, Nombre, Departamento, Salario, Fecha)
    VALUES ('DELETE', OLD.EmpID, OLD.Nombre, OLD.Departamento, OLD.Salario, NOW());
END$$

DELIMITER ;
 /*Verificar el funcionamiento*/
-- Inserción
INSERT INTO empleados (Nombre, Departamento, Salario) VALUES ('Juan Pérez', 'Ventas', 2500.00);

-- Actualización
UPDATE empleados SET Salario = 3000.00 WHERE EmpID = 1;

-- Eliminación
DELETE FROM empleados WHERE EmpID = 1;

-- Verificar auditoría
SELECT * FROM auditoria;

 


