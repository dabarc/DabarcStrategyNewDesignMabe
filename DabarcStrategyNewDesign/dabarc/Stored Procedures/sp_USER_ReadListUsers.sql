CREATE PROCEDURE [dabarc].[sp_USER_ReadListUsers] 			
AS
SET NOCOUNT ON;

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
      ,l.lenguaje
	  ,User_Blocked
	  ,User_Status
  FROM dabarc.t_User AS u 
  LEFT OUTER JOIN dabarc.asp_Language AS l ON u.lng_id = l.lng_id
  WHERE Dat_Delete IS NULL
  ORDER BY User_Active, Dat_Insert DESC;
