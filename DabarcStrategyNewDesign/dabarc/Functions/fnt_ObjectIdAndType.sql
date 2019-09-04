CREATE FUNCTION dabarc.[fnt_ObjectIdAndType] (@id_Object INT, @type_Object nvarchar(6))
RETURNS  NVARCHAR(10)
AS
BEGIN

DECLARE @strId NVARCHAR(10)

SET @strId = RTRIM(CAST(@id_Object AS CHAR(4))) + '_' + RTRIM(@type_Object)

RETURN @strId

END
