CREATE PROCEDURE dabarc.sp_USER_ReadListMailUser
AS 
 SET NOCOUNT ON;
 SELECT Id_User, 
		User_Name + ' | ' + User_Email As Usuario  
 FROM	dabarc.t_User 
 WHERE	User_Active = 1 and Dat_Delete is null   
 ORDER BY Usuario ASC ;
