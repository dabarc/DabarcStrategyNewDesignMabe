CREATE PROCEDURE [dabarc].[sp_run_ReadListOfObjects] @strType CHAR(4) AS	

DECLARE @strSQL NVARCHAR(250)

 SET @strSQL = 'SELECT [object_id] ,[name], [object_type] ,[table_name]
  FROM [dabarc].[vw_Active_Objects]'
  
  If (@strType IS NOT NULL AND @strType <> 'ALL')
   SET @strSQL = @strSQL + ' WHERE RTRIM(object_type) = ''' + RTRIM(@strType) +  ''' ORDER BY name ASC'
   
  EXECUTE(@strSQL)
