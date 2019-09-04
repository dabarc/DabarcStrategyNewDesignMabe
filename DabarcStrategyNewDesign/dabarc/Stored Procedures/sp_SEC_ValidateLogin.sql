--EXEC [dabarc].[sp_SEC_ValidateLogin] @validation = 'read',@usr_id=18,@date_event='2018-01-23 16:55:15',@status= 1;
CREATE PROCEDURE  [dabarc].[sp_SEC_ValidateLogin](
@validation			VARCHAR(255)= 'read',
@usr_id				INT			= 0,
@date_event			DATETIME	= NULL,
@status				INT			= 0,
@newPsw				INT			= 90,	
@LoginAtt			INT			= 5,
@LoginAttTimeout	INT			= 30,
@inactivity			INT			= 45
)

AS

DECLARE @attempts		INT = 0;
DECLARE @error			INT = 1;
DECLARE @current_status	INT = 0;
DECLARE @user_blocked	INT = 0;
---------------------|
--Login Error Codes--|
--0 Error            |
--1 OK               |
-----Error Codes-----|
--0 First Login      |
--1 OK               |
--2 Inactivity       |
--3 Login Blocked    |
---------------------|

IF @date_event IS NULL 
SET @date_event = GETDATE();

SELECT @current_status = [User_Status]
,@user_blocked = [User_Blocked]
FROM [dabarc].[t_User]
WHERE [Id_User] = @usr_id

IF LOWER(@validation) = 'insert'
BEGIN
INSERT INTO [dabarc].[t_User_Logins] (Id_User,Dat_Login,Estatus_Login)
VALUES( @usr_id, @date_event, @status)

END

IF LOWER(@validation) = 'read'
BEGIN

SELECT @attempts = COUNT(U.[Id_User])
FROM [dabarc].[t_User] U
INNER JOIN [dabarc].[t_User_Logins] UL ON UL.Id_User = U.Id_User
WHERE U.Id_User = @usr_id

IF @attempts > 0
BEGIN

SELECT @attempts = COUNT(U.[Id_User])
FROM [dabarc].[t_User] U
INNER JOIN (
	SELECT TOP (5) [Id_User]
    ,[Dat_Login]
    ,[Estatus_Login]
	FROM [dabarc].[t_User_Logins]
	WHERE Id_User = @usr_id
	ORDER BY Dat_Login DESC
  ) UL ON UL.Id_User = U.Id_User
WHERE U.Id_User = @usr_id
AND UL.Estatus_Login = 0
AND DATEDIFF(MINUTE, UL.Dat_Login , @date_event) <= @LoginAttTimeout

IF @attempts < 5 AND @user_blocked = 1 AND @current_status = 3
UPDATE  [dabarc].[t_User] SET [User_Blocked] = 0
,[User_Status] = 0
WHERE [Id_User] = @usr_id

IF @attempts >= @LoginAtt
BEGIN
SET @error = 3
UPDATE  [dabarc].[t_User] SET [User_Blocked] = 1
,[User_Status] = @error
WHERE [Id_User] = @usr_id 
END
ELSE

SELECT @attempts = COUNT(U.[Id_User])
FROM [dabarc].[t_User] U
INNER JOIN [dabarc].[t_User_Logins] UL ON UL.Id_User = U.Id_User
WHERE U.Id_User = @usr_id
AND UL.Estatus_Login = 1
AND DATEDIFF(DAY, UL.Dat_Login , @date_event) <= @inactivity 

IF @attempts = 0
BEGIN
SET @error = 2
UPDATE  [dabarc].[t_User] SET [User_Blocked] = 1
,[User_Status] = @error
WHERE [Id_User] = @usr_id 
END

END

END

SELECT @error AS StatusCode
