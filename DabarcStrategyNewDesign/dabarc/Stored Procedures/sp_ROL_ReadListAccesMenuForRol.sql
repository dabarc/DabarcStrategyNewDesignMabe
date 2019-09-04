CREATE PROCEDURE [dabarc].[sp_ROL_ReadListAccesMenuForRol] @Id_Rol INT AS


	SELECT  Id_RolPermissions,
			Active,
			b.Node_Name,
			Per_Name,
			Per_Execute,
			Per_Insert,
			Per_Modify,
			Per_Delete 
	FROM	dabarc.t_User_RolPermissions d
			INNER JOIN dabarc.asp_InfoTreeview_Base b ON d.Id_TreeViewB = b.Id_TreeviewB 
	WHERE Id_Rol = @Id_Rol
