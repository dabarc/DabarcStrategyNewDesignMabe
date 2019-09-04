CREATE PROCEDURE [dabarc].[sp_ROL_ReadListAccesForRol] @Id_Rol INT AS

	--------------------------------------------------------------------------------------------------------
	--- Tabla Temporal
	--------------------------------------------------------------------------------------------------------
			
	CREATE TABLE #Return(Clave NVARCHAR(5),Name_Rol NVARCHAR(40))

	--------------------------------------------------------------------------------------------------------
	--- Tabla Temporal
	--------------------------------------------------------------------------------------------------------
	
	INSERT INTO #Return
	SELECT 'AU','Acceso a usuarios'		FROM dabarc.t_User_Roles WHERE Id_Rol = @Id_Rol and Rol_AccesUser = 1
	UNION
	SELECT 'AS','Acceso a paquetes'		FROM dabarc.t_User_Roles WHERE Id_Rol = @Id_Rol and Rol_AccesSsis = 1
	UNION
	SELECT 'AM','Acceso a metodología'	FROM dabarc.t_User_Roles WHERE Id_Rol = @Id_Rol and Rol_AccesMethod = 1
	UNION
	SELECT 'AL','Acceso a la bitácora'		FROM dabarc.t_User_Roles WHERE Id_Rol = @Id_Rol and Rol_AccesLog = 1
	UNION
	SELECT 'AE','Acceso a las ejecuciones'	FROM dabarc.t_User_Roles WHERE Id_Rol = @Id_Rol and Rol_AccesExecute = 1
	
	SELECT * FROM #Return
