CREATE PROCEDURE dabarc.sp_USER_InsertRowUsers
			@User_Name nvarchar(100)
           ,@User_NameShort nchar(10)
           ,@User_Password nvarchar(300)
           ,@User_Email nvarchar(50)
           ,@User_Active bit
           ,@User_OwnerOnlyData bit
           ,@User_Lng_Id nchar(5)
		   ,@User_Blocked bit  =  0 
AS

 IF (SELECT COUNT(*) FROM t_User WHERE UPPER(RTRIM(User_NameShort)) = UPPER(RTRIM(@User_NameShort))) > 0
 BEGIN
 	 --  RAISERROR('Ya existe un usuario con esa clave.', 16, 1);
 	   RAISERROR (50065,16,1,'','');   
	   RETURN;
 END
 
INSERT INTO dabarc.t_User
           (
            User_Name
           ,User_NameShort
           ,User_Password
           ,User_Email
           ,User_Active
           ,User_OwnerOnlyData
           ,Is_Admin
           ,Dat_Insert
           ,lng_id
		   ,User_Blocked)
     VALUES
           (
            @User_Name
           ,@User_NameShort
           ,@User_Password
           ,@User_Email
           ,@User_Active
           ,@User_OwnerOnlyData
           ,0
           ,GETDATE()
           ,@User_Lng_Id
		   ,@User_Blocked
		   );
 

 INSERT INTO dabarc.t_User_Password_History
           (Id_User
           ,User_Password
           ,Dat_Insert)
     VALUES
           (IDENT_CURRENT('dabarc.t_User')
           ,@User_Password
           ,GETDATE());
