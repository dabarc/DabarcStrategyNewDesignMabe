CREATE PROCEDURE [dabarc].[sp_MAIL_InserRowOfNotification] @vIdObjects CHAR(10), 
			@idUser		   INT, 
			@name		   NVARCHAR(50), 
			@mail		   NVARCHAR(50),
			@InfoOutput    INT,
			@create_user   NVARCHAR(15),
			@individual	   BIT
			AS 

INSERT INTO [t_MAIL]
           ([mail_active]
           ,[mail_idobjects]
           ,[mail_objectstype]
           ,[mail_tablename]
           ,[mail_iduser]
           ,[mail_name]
           ,[mail_email]
           ,[mail_InfoOutput]
           ,[mail_insert]
           ,[mail_user]
           ,[mail_individual])
           
SELECT		1,
			objectid,
			object_type,
			table_name,
			@idUser,
			@name,
			@mail,
			@InfoOutput,
			GETDATE(),
			@create_user,
			@individual
FROM		vw_Active_Objects 
WHERE		object_id  = @vIdObjects
