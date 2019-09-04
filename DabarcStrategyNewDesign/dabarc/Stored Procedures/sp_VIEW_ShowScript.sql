CREATE PROCEDURE [dabarc].[sp_VIEW_ShowScript] @objectType NCHAR(4),@idObject INT AS

DECLARE @db_name NVARCHAR(100)
DECLARE @sp_name NVARCHAR(100)
DECLARE @var1 NVARCHAR(1000)

CREATE TABLE #Result( 
				script nvarchar(MAX))

IF (RTRIM(@objectType) = 'IFF')
BEGIN 
 SELECT @db_name=bdf.name, 
        @sp_name=iff.name
 FROM t_BDF bdf
 inner join t_TFF tff
 ON bdf.database_id = tff.database_id 
 inner join t_IFF iff
 ON tff.table_id = iff.table_id
 WHERE iff.report_id = @idObject
END
 
IF (RTRIM(@objectType) = 'IDM')
BEGIN 
 SELECT @db_name = bdm.name, @sp_name= idm.name
 FROM t_BDM bdm
 inner join t_TDM tdm
 ON bdm.database_id = tdm.database_id 
 inner join t_IDM idm
 ON tdm.table_id = idm.table_id
 WHERE idm.report_id = @idObject
END
 
IF (RTRIM(@objectType) = 'IFM')
BEGIN 
 SELECT @db_name = bdm.name,
        @sp_name = ifm.name  
 FROM t_BDM bdm
	inner join t_TDM tdm
	ON bdm.database_id = tdm.database_id
	inner join t_TFM tfm 
	ON tdm.table_id = tfm.tdm_id
	inner join t_IFM ifm
	ON tfm.table_id = ifm.table_id
 WHERE ifm.report_id = @idObject
END

SET @var1 = 'SELECT definition FROM ' + @db_name + '.sys.sql_modules modu
			inner join ' + @db_name + '.sys.objects obj 
			ON modu.object_id = obj.object_id WHERE obj.type = ''V'' AND obj.name = ''' + @sp_name + ''''
			
PRINT @var1

INSERT INTO #Result EXECUTE (@var1)	

SELECT * FROM #Result
