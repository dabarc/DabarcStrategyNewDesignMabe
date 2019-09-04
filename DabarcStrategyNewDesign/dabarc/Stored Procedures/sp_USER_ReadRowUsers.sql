CREATE PROCEDURE dabarc.sp_USER_ReadRowUsers
@Id_User INT, 
@User_NameShort NVARCHAR(10)
AS
     SET NOCOUNT ON;
 
	 IF (@Id_User <> 0 )
	 BEGIN
		 SELECT Id_User
			  ,User_Name
			  ,User_NameShort
			  ,User_Password
			  ,User_MobilePIN
			  ,User_Email
			  ,User_PwdQuestion
			  ,User_PwdAnswer
			  ,User_Active
			  ,User_OwnerOnlyData
			  ,Dat_Insert
			  ,Dat_Update
			  ,Dat_Delete
			  ,lng_id
			  ,User_Blocked
			  ,User_Status
		  FROM dabarc.t_User
		  WHERE Id_User = @Id_User
		  AND Dat_Delete IS NULL
	 END
	 ELSE
	 BEGIN
	  SELECT Id_User
			  ,User_Name
			  ,User_NameShort
			  ,User_Password
			  ,User_MobilePIN
			  ,User_Email
			  ,User_PwdQuestion
			  ,User_PwdAnswer
			  ,User_Active
			  ,User_OwnerOnlyData
			  ,Dat_Insert
			  ,Dat_Update
			  ,Dat_Delete
			  ,lng_id
			  ,User_Blocked
			  ,User_Status
		  FROM dabarc.t_User
		  WHERE User_NameShort = @User_NameShort
		  AND Dat_Delete IS NULL
	 END
