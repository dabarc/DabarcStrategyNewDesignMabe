
CREATE PROCEDURE dabarc.sp_syn_getColumns @database nvarchar(100), @table nvarchar(100) 
AS
BEGIN
   DECLARE @sql NVARCHAR(max)
   SET @sql='use'
   SELECT @sql = @sql + ' '+@database +' SELECT ORDINAL_POSITION, COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ''' + @table + ''' ORDER BY ORDINAL_POSITION'
   EXEC dbo.sp_executesql @sql
END
