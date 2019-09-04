CREATE PROCEDURE [dabarc].[sp_RULE_ShowScript] @objectType NCHAR(4),@idObject INT AS

DECLARE @db_name NVARCHAR(100)
DECLARE @sp_name NVARCHAR(100)
DECLARE @var1 NVARCHAR(1000)

DECLARE @TYPE NCHAR = N'V';


CREATE TABLE #Result( script nvarchar(MAX));

IF (RTRIM(@objectType) = 'RFF')
 BEGIN 
    SET @TYPE = N'P';
	SELECT @db_name=bdf.name, @sp_name=rff.name
	FROM t_BDF bdf
	inner join t_TFF tff
	ON bdf.database_id = tff.database_id 
	inner join t_RFF rff
	ON tff.table_id = rff.table_id
	WHERE rff.rule_id = @idObject	
 END
IF (RTRIM(@objectType) = 'RDM')
 BEGIN
	SET @TYPE = N'P'; 
	SELECT @db_name = bdm.name, @sp_name= rdm.name
	FROM t_BDM bdm
	inner join t_TDM tdm
	ON bdm.database_id = tdm.database_id 
	inner join t_RDM rdm
	ON tdm.table_id = rdm.table_id
	WHERE rdm.rule_id = @idObject
 END
IF (RTRIM(@objectType) = 'RFM')
 BEGIN
    SET @TYPE = N'P';
	SELECT @db_name = bdm.name, @sp_name = rfm.name  
	FROM t_BDM bdm
	inner join t_TDM tdm
	ON bdm.database_id = tdm.database_id
	inner join t_TFM tfm 
	ON tdm.table_id = tfm.tdm_id
	inner join t_RFM rfm
	ON tfm.table_id = rfm.table_id
	WHERE rfm.rule_id = @idObject
 END
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
			ON modu.object_id = obj.object_id WHERE obj.type = '''+ @TYPE +''' AND obj.name = ''' + @sp_name + ''''
			
--PRINT @var1
INSERT INTO #Result
EXECUTE (@var1)	
SELECT * FROM #Result
