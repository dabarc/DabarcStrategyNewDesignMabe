
CREATE PROCEDURE dabarc.sp_sys_getError_Show  @intNumberError INT,
											 @strPar1 NVARCHAR(100),
											 @strPar2 NVARCHAR(100) AS 
BEGIN
  
DECLARE @strGetError NVARCHAR(1000)

 SET @strGetError = 'SIN MENSAGE';

 SELECT @strGetError

END
