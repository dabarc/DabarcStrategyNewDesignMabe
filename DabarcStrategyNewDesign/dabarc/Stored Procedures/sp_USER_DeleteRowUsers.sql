CREATE PROCEDURE dabarc.sp_USER_DeleteRowUsers
@Id_User INT			
AS
   SET NOCOUNT ON;
 --Damos de Baja al Usuario por medio de la fecha
 
   UPDATE	dabarc.t_User
		SET	Dat_Delete = GETDATE()
   WHERE	Id_User = @Id_User AND 
            UPPER(User_NameShort) <> 'ADMIN';
