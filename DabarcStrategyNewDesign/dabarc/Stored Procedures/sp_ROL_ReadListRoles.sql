CREATE PROCEDURE [dabarc].[sp_ROL_ReadListRoles] 			
AS

	 SELECT Id_Rol
		  ,Rol_Name
		  ,Rol_Description
		  ,Active
		  ,Rol_AccesUser
		  ,Rol_AccesSsis
		  ,Rol_AccesMethod
		  ,Rol_AccesLog
		  ,Rol_AccesExecute
		  ,Dat_Insert
		  ,Dat_Delete
	 FROM	dabarc.t_User_Roles 
	 WHERE Dat_Delete IS NULL
