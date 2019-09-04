CREATE PROCEDURE [dabarc].[sp_USER_UpdateRowUsers] 
			@Id_User INT
		   ,@User_Name nvarchar(100)
           ,@User_Password nvarchar(300)
           ,@User_Email nvarchar(50)
           ,@User_Active bit
           ,@User_OwnerOnlyData bit
           ,@User_lng_id NCHAR(5)
		   ,@User_Blocked bit  =  0 
		   ,@Last_N_Password  INT = 5
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Cuenta int;
	WITH PasswordHistory_CTE(Id_User,User_Password,Dat_Insert)
	AS 
	(
	  SELECT TOP (@Last_N_Password) 
			 Id_User
			,User_Password
			,Dat_Insert
	  FROM dabarc.t_User_Password_History
	  WHERE Id_user = @Id_User
	  ORDER BY Dat_Insert DESC
	)
	SELECT @Cuenta = COUNT(*) FROM PasswordHistory_CTE WHERE User_Password = @User_Password;
	IF @Cuenta > 0 
	BEGIN
		RAISERROR('No pueden usar las ultimas contraseñas.' , 16, 1);
		RETURN;
	 END

	UPDATE dabarc.t_User
	SET		User_Name = @User_Name
           ,User_Password = @User_Password
           ,User_Email = @User_Email
           ,User_Active = @User_Active
           ,User_OwnerOnlyData = @User_OwnerOnlyData
           ,Dat_Update = GETDATE()
           ,lng_id = @User_lng_id
		   ,User_Blocked = @User_Blocked
	WHERE  Id_User = @Id_User AND UPPER(User_NameShort) != 'ADMIN'

	INSERT INTO dabarc.t_User_Password_History
           (Id_User
           ,User_Password
           ,Dat_Insert)
     VALUES
           (@Id_User
           ,@User_Password
           ,GETDATE());
END
