CREATE PROCEDURE [dabarc].[sp_ROL_UpdateListAccesMenuForRol_Reg] 
	@IsRegister BIT, 
	@Id_RolPermissions INT,
	@Id_Rol INt,
	@Id_TreeViewB INT,
	@Per_Table nvarchar(50),
	@Per_Id INT,
	@Per_Name NVARCHAR(50)
AS
	DECLARE @ID INT

	
	 If (@IsRegister = 1)
	 BEGIN
		DELETE FROM dabarc.t_User_RolPermissions WHERE Id_RolPermissions = @Id_RolPermissions		
	 END
	 ELSE
	 BEGIN		
	 
		SELECT @ID = MAX(ISNULL(Id_RolPermissions,1)) FROM dabarc.t_User_RolPermissions
		
		SET @ID = @ID + 1
		
		INSERT INTO dabarc.t_User_RolPermissions(Id_RolPermissions, Id_Rol,Id_TreeViewB,Per_Table,Per_Id,Per_Name,Active)
		VALUES(@ID,@Id_Rol,@Id_TreeViewB,@Per_Table,@Per_Id,@Per_Name,1)	 	 
	 END
