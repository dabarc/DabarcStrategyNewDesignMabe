CREATE FUNCTION [dabarc].[fnt_get_screenName] (@STR_SCREEN NCHAR(100))
RETURNS NCHAR(100)
AS 
BEGIN

		declare @str varchar(100)
		declare @ix int
 
		set @str = @STR_SCREEN
		set @ix = 0

 
			WHILE (CHARINDEX('/',@str,@ix) <> 0)
			   BEGIN
			   SET @ix = CHARINDEX('/',@str,@ix)
			   SET @ix = @ix + 1
			END

		RETURN SUBSTRING(@str,@ix,CHARINDEX('.aspx',@str) - (@ix) + 5)

END
