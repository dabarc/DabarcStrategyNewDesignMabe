
CREATE PROCEDURE [dabarc].[sp_ROL_DeleteRowRoles] @Id_Rol INT			
AS

 --Damos de Baja al Usuario por medio de la fecha
 
 IF (SELECT COUNT(*) FROM t_User_Permissions WHERE Id_Rol = @Id_Rol) > 0
	   BEGIN
		--RAISERROR('El rol no puede eliminarse ya que está asignado a uno o más usuarios.', 16, 1);	
		 RAISERROR (50010,16,1, '','')
		
			RETURN;
		 
		
		
		RETURN;
	   END
 
	UPDATE	dabarc.t_User_Roles
   SET		Dat_Delete = GETDATE()
   WHERE	Id_Rol = @Id_Rol
