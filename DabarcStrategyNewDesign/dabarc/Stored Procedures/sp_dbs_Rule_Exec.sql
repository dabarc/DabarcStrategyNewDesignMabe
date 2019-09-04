CREATE PROCEDURE [dabarc].[sp_dbs_Rule_Exec]
	(
	@database_id	int,
	@rule_name		nvarchar(128),
	@table_type	NCHAR(3)	
	)
	
AS
	
	DECLARE @db_name nvarchar(128),
			@sp_name nvarchar(256)


	IF (UPPER(RTRIM(@table_type)) ='RFF')
	   SELECT @db_name = RTRIM(f.name) FROM t_BDF f WHERE f.database_id = @database_id
	ELSE
	   SELECT @db_name = RTRIM(m.name) FROM t_BDM m WHERE m.database_id = @database_id
				
	--SET @db_name = DB_NAME(@database_id)
	
	SET @sp_name = @db_name + '.dbo.' +  @rule_name
		
	EXECUTE @sp_name;
	
	--RETURN
