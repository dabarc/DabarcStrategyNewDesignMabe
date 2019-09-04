CREATE PROCEDURE [dabarc].[sp_ROL_UpdateRowRoles] 
			@Id_Rol INT
		   ,@Rol_Name nvarchar(50)
           ,@Rol_Description nvarchar(250)
           ,@Active bit
           ,@Rol_AccesUser bit
		   ,@Rol_AccesSsis bit
		   ,@Rol_AccesMethod bit
		   ,@Rol_AccesLog bit
		   ,@Rol_AccesExecute bit
AS


	UPDATE dabarc.t_User_Roles
	SET		Rol_Name = @Rol_Name
           ,Rol_Description = @Rol_Description
           ,Active = @Active
           ,Rol_AccesUser = @Rol_AccesUser
		   ,Rol_AccesSsis = @Rol_AccesSsis
		   ,Rol_AccesMethod = @Rol_AccesMethod
		   ,Rol_AccesLog = @Rol_AccesLog
		   ,Rol_AccesExecute = @Rol_AccesExecute
           ,Dat_Update = GETDATE()
	WHERE  Id_Rol = @Id_Rol --AND UPPER(User_NameShort) != 'ADMIN'
