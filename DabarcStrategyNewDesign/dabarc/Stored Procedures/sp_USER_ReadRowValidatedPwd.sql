CREATE PROCEDURE dabarc.sp_USER_ReadRowValidatedPwd
	@User_NameShort Char(10) 
 AS
 SET NOCOUNT ON ;
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
  WHERE (RTRIM(User_NameShort) = RTRIM(@User_NameShort)) 
  AND Dat_Delete IS NULL;
