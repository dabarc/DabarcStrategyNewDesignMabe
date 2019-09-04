CREATE PROCEDURE dabarc.sp_USER_ListOfRolPermissions
	@Id_User INT 
AS
	SET NOCOUNT ON;

	SELECT	r.Id_Rol,
			CASE WHEN p.Id_Rol IS NULL THEN 0 ELSE 1 END Active,
			r.Rol_Name
	FROM	dabarc.t_User_Roles r
		    LEFT OUTER JOIN dabarc.t_User_Permissions p ON r.Id_Rol = p.Id_Rol AND p.Id_User = @Id_User 
		    --INNER JOIN dabarc.t_User_Permissions p ON r.Id_Rol = p.Id_Rol AND p.Id_User = @Id_User 
		WHERE Active = 1;
