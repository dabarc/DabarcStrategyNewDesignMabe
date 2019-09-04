CREATE PROCEDURE [dabarc].[sp_ROL_ReadListAccesMenuForRol_Reg] @IsRegister BIT, @Id_Rol INT, @CveAccess NCHAR(2) AS

	--------------------------------------------------------------------------------------------------------
	--- Tabla Temporal
	--------------------------------------------------------------------------------------------------------
			
	CREATE TABLE #Return(	id_RolPermissions	INT,
							Id_TreeViewB		INT, 
							Per_id				INT, 
							Per_table			NVARCHAR(50), 
							Per_name			NVARCHAR(50))
							
	CREATE TABLE #existe(	Id_TreeViewB		INT, 
							Per_id				INT, 
							Per_table			NVARCHAR(50))							

	--------------------------------------------------------------------------------------------------------
	--- Tabla Temporal
	--------------------------------------------------------------------------------------------------------
	INSERT INTO #existe 
	SELECT  o.Id_TreeViewB,
			o.Per_Id,
			o.Per_Table
	FROM dabarc.t_User_RolPermissions o 
	WHERE o.Id_Rol = @Id_Rol 

	--------------------------------------------------------------------------------------------------------
	--- Tabla Temporal
	--------------------------------------------------------------------------------------------------------
	IF (@IsRegister = 1)
	BEGIN
	 INSERT INTO #Return
	 SELECT Id_RolPermissions,0,0,'',Per_Name FROM dabarc.t_User_RolPermissions	 where Id_Rol = @Id_Rol
	 
	 
	 	SELECT	id_RolPermissions,
			Id_TreeViewB,
			Per_id, 
			Per_table, 
			Per_name
		FROM #Return	
		

	
	 RETURN
	END
	
	--------------------------------------------------------------------------------------------------------
	--- Acceso al módulo de Seguridad
	--------------------------------------------------------------------------------------------------------	
	 
	IF (@CveAccess = 'AU')
	BEGIN
		 INSERT INTO #Return
		 SELECT 0,Id_TreeviewB,0, '', Node_Name
		 FROM	dabarc.asp_InfoTreeview_Base 
		 WHERE  Node_Parent = 'SEG'
		 ORDER BY Node_Position ASC
	END
	
	--------------------------------------------------------------------------------------------------------
	--- Acceso al módulo de paqueteria
	--------------------------------------------------------------------------------------------------------
		
	IF (@CveAccess = 'AS')
	BEGIN
		 INSERT INTO #Return
		 SELECT 0,Id_TreeviewB,0, '', Node_Name
		 FROM	dabarc.asp_InfoTreeview_Base 
		 WHERE  Node_Parent = 'MIS'
		 ORDER BY Node_Position ASC
	END

	--------------------------------------------------------------------------------------------------------
	--- Acceso al módulo métodologia
	--------------------------------------------------------------------------------------------------------	
	IF (@CveAccess = 'AM')
	BEGIN
		 INSERT INTO #Return
		 SELECT 0,Id_TreeviewB,0, '', Node_Name
		 FROM	dabarc.asp_InfoTreeview_Base 
		 WHERE  Node_Parent = 'MET' AND (Node_Clave <> 'METF' AND Node_Clave <> 'METD')
		 ORDER BY Node_Position ASC
		 
		 -- Base de datos fuente
		 INSERT INTO #Return		 				 
		 SELECT DISTINCT 0,a.Id_TreeviewB, database_id, 't_BDF', a.Node_Name + '\' + d.name
				name 
		 FROM	dabarc.t_BDF d
				FULL OUTER JOIN dabarc.asp_InfoTreeview_Base  a ON a.Node_Clave = 'METF'
		 WHERE active = 1 AND registered = 1
		 
		 -- Base de datos manejo
		 INSERT INTO #Return		 				 
		 SELECT DISTINCT 0,a.Id_TreeviewB, database_id, 't_BDM', a.Node_Name + '\' + d.name
				name 
		 FROM	dabarc.t_BDM d
				FULL OUTER JOIN dabarc.asp_InfoTreeview_Base  a ON a.Node_Clave = 'METD'
		 WHERE active = 1 AND registered = 1
	 
	END
	
	--IF (@CveAccess = 'AL')
	--BEGIN
	--			 SELECT * 
	--	 FROM	dabarc.asp_InfoTreeview_Base 
	--	 WHERE  Node_Parent = 'MET'
	--END			


	
	SELECT	id_RolPermissions,
			Id_TreeViewB,
			Per_id, 
			Per_table, 
			Per_name
	FROM #Return r	
	WHERE NOT EXISTS (	SELECT * 
						FROM #existe o 
						WHERE o.Id_TreeViewB = r.Id_TreeViewB
						AND o.Per_id = r.Per_id
						AND o.Per_table = r.Per_table
						)
