CREATE PROCEDURE [dabarc].[sp_ROL_UpdateListAccesMenuForRol_Active] 
	@Id_RolPermissions INT,
	@Active BIT,
	@Per_Execute BIT,
	@Per_Insert BIT,
	@Per_Modify BIT,
	@Per_Delete BIT 
AS
	UPDATE	dabarc.t_User_RolPermissions
	SET		Active = @Active,
			Per_Execute = @Per_Execute,
			Per_Insert = @Per_Insert,
			Per_Modify = @Per_Modify,
			Per_Delete = @Per_Delete 
	WHERE	Id_RolPermissions = @Id_RolPermissions
