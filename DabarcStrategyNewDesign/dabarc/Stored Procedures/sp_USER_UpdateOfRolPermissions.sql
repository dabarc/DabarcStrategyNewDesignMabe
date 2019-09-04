CREATE PROCEDURE [dabarc].[sp_USER_UpdateOfRolPermissions] @Id_Rol INT,@Id_User INT, @Active BIT AS

DECLARE @Id INT
	-------------------------------------------------------------------
	-- Buscamos el Maximo Id 
	-------------------------------------------------------------------

	SELECT @Id = MAX(ISNULL(Id_UserPermissions,1))  FROM dabarc.t_User_Permissions 

	IF (@Active = 1)
	BEGIN
		IF (SELECT COUNT(*) FROM dabarc.t_User_Permissions WHERE Id_Rol = @Id_Rol ANd Id_User = @Id_User) = 0
			INSERT INTO dabarc.t_User_Permissions(Id_UserPermissions,Id_Rol,Id_User) VALUES(@Id,@Id_Rol,@Id_User) 
	END
	ELSE
	BEGIN
		DELETE FROM dabarc.t_User_Permissions WHERE Id_Rol = @Id_Rol ANd Id_User = @Id_User
	END
