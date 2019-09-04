CREATE PROCEDURE [dabarc].[sp_asp_Treeview_Base_Menuico] @User_NameShort NVARCHAR(10) AS


	-----------------------------------------------------------------------------------------------
	-- Consulta permiso de un usuario para los iconos del menu
	-----------------------------------------------------------------------------------------------

	-----------------------------------------------------------------------------------------------
	-- Creamos una tabla temporal para obtener el conjunto de permisos
	-----------------------------------------------------------------------------------------------
	CREATE TABLE #Permissions(User_NameShort NVARCHAR(10),
							  AccessUser	BIT,
							  AccessSSIS	BIT,
							  AccessMethod	BIT,
							  AccessLog		BIT,
							  AccessExecute BIT)

	-----------------------------------------------------------------------------------------------
	-- Creamos una tabla temporal para obtener el conjunto de permisos
	-----------------------------------------------------------------------------------------------
	
	INSERT INTO #Permissions
	SELECT	User_NameShort, 
			CASE WHEN SUM(CAST(ro.Rol_AccesUser AS INT)) > 0 THEN 1 ELSE 0 END, 
			CASE WHEN SUM(CAST(ro.Rol_AccesSsis  AS INT)) > 0 THEN 1 ELSE 0 END, 
			CASE WHEN SUM(CAST(ro.Rol_AccesMethod  AS INT)) > 0 THEN 1 ELSE 0 END, 
			CASE WHEN SUM(CAST(ro.Rol_AccesLog  AS INT)) > 0 THEN 1 ELSE 0 END, 
			CASE WHEN SUM(CAST(ro.Rol_AccesExecute  AS INT)) > 0 THEN 1 ELSE 0 END
	FROM	dabarc.t_User u
			inner join dabarc.t_User_Permissions pu ON u.Id_User = pu.Id_User
			inner join dabarc.t_User_Roles ro	ON pu.Id_Rol = ro.Id_Rol
	WHERE User_NameShort = @User_NameShort
	GROUP BY User_NameShort
	
	SELECT	AccessUser,
			AccessSSIS,
			AccessMethod,
			AccessLog,
			AccessExecute
	FROM	#Permissions
