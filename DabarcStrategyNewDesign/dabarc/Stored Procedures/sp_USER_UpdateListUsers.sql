CREATE PROCEDURE dabarc.sp_USER_UpdateListUsers
			@Id_User INT
           ,@User_Email nvarchar(50)
           ,@User_Active bit
           ,@User_OwnerOnlyData bit
		   ,@User_Blocked bit
AS

	--Cambio de contraseña despues de bloqueo por inactividad
	DECLARE @DateUpdate		VARCHAR(255) = ''
	DECLARE @BlockStatus	INT = 0
	DECLARE @Blocked		INT = 0

	SELECT @BlockStatus = [User_Status] 
	,@Blocked = [User_Blocked]
	FROM dabarc.t_User
	WHERE  Id_User = @Id_User
	
	IF @Blocked = 1 AND @User_Blocked = 0 AND @BlockStatus = 2
	SET @DateUpdate = NULL
	ELSE
	SET @DateUpdate = GETDATE()
	----------------------------------------------------------
	UPDATE dabarc.t_User
	SET		User_Email = @User_Email
           ,User_Active = @User_Active
           ,User_OwnerOnlyData = @User_OwnerOnlyData
           ,Dat_Update = @DateUpdate
		   ,User_Blocked = @User_Blocked
	WHERE  Id_User = @Id_User AND UPPER(User_NameShort) != 'ADMIN';
