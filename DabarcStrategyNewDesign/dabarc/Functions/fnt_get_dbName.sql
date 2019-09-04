CREATE FUNCTION [dabarc].[fnt_get_dbName] (@DB_NAME NCHAR(100))
RETURNS NCHAR(100)
AS 
BEGIN

		declare @str varchar(100)
		declare @ix int
 
		set @str = @DB_NAME
		set @ix = 0

 
			WHILE (CHARINDEX('\',@str,@ix) <> 0)
			   BEGIN
			   SET @ix = CHARINDEX('\',@str,@ix)
			   SET @ix = @ix + 1
			END

		RETURN SUBSTRING(@str,@ix,CHARINDEX('.',@str) - (@ix) + 5)

END
