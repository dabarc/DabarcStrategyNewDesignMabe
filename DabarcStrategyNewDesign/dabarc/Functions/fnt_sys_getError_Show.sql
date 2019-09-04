
CREATE FUNCTION dabarc.fnt_sys_getError_Show ( @intNumberError INT,
											 @strPar1 NVARCHAR(100),
											 @strPar2 NVARCHAR(100))  
RETURNS VARCHAR(1000) AS 
BEGIN
 
 DECLARE @strGetError NVARCHAR(1000)

 SET @strGetError = 'SIN MENSAGE';

 RETURN @strGetError  
  
END
