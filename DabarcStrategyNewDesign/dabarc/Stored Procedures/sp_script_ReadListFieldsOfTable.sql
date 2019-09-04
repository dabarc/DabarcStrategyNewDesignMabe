
CREATE PROCEDURE [dabarc].[sp_script_ReadListFieldsOfTable] @name_key NVARCHAR(200) AS
 
 
 DECLARE @db_name  NVARCHAR(150)
 DECLARE @tfm_name NVARCHAR(150)
 DECLARE @strSQL   NVARCHAR(2000)
 DECLARE @intdot	   INT
 
 SET @intdot	= CHARINDEX('.',@name_key,1)
 SET @db_name	= SUBSTRING(@name_key,1,@intdot)
 SET @tfm_name	= SUBSTRING(@name_key,@intdot + 1, LEN(@name_key))
 

 SET @strSQL = ' SELECT c.column_id, c.name
 FROM ' + RTRIM(@db_name) +  'sys.all_columns c
	INNER JOIN ' + RTRIM(@db_name) + 'sys.all_objects o ON c.object_id = o.object_id
 WHERE RTRIM(o.name) =''' +  @tfm_name + ''' ORDER BY 1 ASC'
 

 EXECUTE(@strSQL)
