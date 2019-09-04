CREATE PROCEDURE [dabarc].[sp_ROL_InsertRowRoles] 
			@Rol_Name nvarchar(50)
           ,@Rol_Description nvarchar(250)
           ,@Active bit
AS

DECLARE @Id INT

 IF (SELECT COUNT(*) FROM dabarc.t_User_Roles WHERE UPPER(Rol_Name) = UPPER(RTRIM(@Rol_Name))) > 0
 BEGIN
 	 --  RAISERROR('Ya existe un rol con ese nombre.', 16, 1);
	  
 RAISERROR (50064,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	  
	   RETURN;
 END

 SELECT @Id = MAX(ISNULL(Id_Rol,0)) + 1  FROM dabarc.t_User_Roles

INSERT INTO dabarc.t_User_Roles
           (Id_Rol,
           Rol_Name
           ,Rol_Description
           ,Rol_AccesUser
           ,Rol_AccesSsis
           ,Rol_AccesMethod
           ,Rol_AccesLog
           ,Rol_AccesExecute
           ,Active
           ,Dat_Insert)
     VALUES
           (@Id,
           @Rol_Name
           ,@Rol_Description
           ,0,0,0,0,0
           ,@Active
           ,GETDATE())
