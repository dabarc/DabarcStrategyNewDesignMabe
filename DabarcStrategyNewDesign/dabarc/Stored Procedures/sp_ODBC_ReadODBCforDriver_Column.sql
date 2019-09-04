CREATE PROCEDURE [dabarc].[sp_ODBC_ReadODBCforDriver_Column] 
@odbc_id INT,
@Plantillad_id INT 
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Sql_Str      VARCHAR(MAX)
	DECLARE @Type_ODBC	  CHAR(10)
	DECLARE @db_DataBase  VARCHAR(100)
	DECLARE @db_Table	  VARCHAR(100)
	DECLARE @db_Owner	  VARCHAR(50)
	DECLARE @db_Path	  NVARCHAR(50)
	DECLARE @db_Separador	  CHAR(4)	
		------------------------------------------------------------------------------------------
		-- Obtenemos el tipo de Driver que se esta utlizando
		------------------------------------------------------------------------------------------	
		SELECT	@Type_ODBC	 = RTRIM(r.driver_cva), 
				@db_DataBase = o.odbc_database,
				--@db_Owner	 = o.odbc_esquema,
				@db_Path	 = o.file_path,
				@db_Separador = o.file_separation
		FROM	t_ODBC AS o
			INNER JOIN t_ODBC_driver AS r ON o.driver_id = r.driver_id
		WHERE o.odbc_id = @odbc_id;

		SELECT	@db_Table =  table_name,
				@db_Owner = table_esquema
		FROM	t_PlantillaD 
		WHERE	plantillad_id = @Plantillad_id;
		------------------------------------------------------------------------------------------
		-- Regresamos la consulta de cuardo al driver que se a modificar
		------------------------------------------------------------------------------------------
		IF (@Type_ODBC = 'MSS')
		BEGIN
				SET            @Sql_Str = ' SELECT dbo.syscolumns.name AS COLUMNNAME, dbo.systypes.name AS DATATYPE, '
				SET @Sql_Str = @Sql_Str + ' dbo.syscolumns.length AS COLUMNSIZE, dbo.syscolumns.xprec AS NUMERICPRECISION, dbo.syscolumns.xscale AS NUMERICSCALE,' 
				SET @Sql_Str = @Sql_Str + ' CASE WHEN dbo.syscolumns.isnullable = 1 THEN ''true'' ELSE ''false'' END AS ALLOWDBNULL, dbo.sysobjects.uid '
				SET @Sql_Str = @Sql_Str + ' FROM  dbo.sysobjects '
				SET @Sql_Str = @Sql_Str + ' INNER JOIN dbo.syscolumns ON dbo.sysobjects.id = dbo.syscolumns.id '
				SET @Sql_Str = @Sql_Str + ' INNER JOIN dbo.systypes ON dbo.syscolumns.xtype = dbo.systypes.xtype '
	--			SET @Sql_Str = @Sql_Str + ' INNER JOIN dbo.sysusers ON dbo.sysobjects.uid = dbo.sysusers.uid'
				SET @Sql_Str = @Sql_Str + ' WHERE (dbo.systypes.name <> ''sysname'')'
				SET @Sql_Str = @Sql_Str + ' AND dbo.systypes.xtype =dbo.systypes.xusertype'
				SET @Sql_Str = @Sql_Str + ' AND (UPPER(dbo.sysobjects.name) = ''' + UPPER(RTRIM(@db_Table)) + ''')'
	--			SET @Sql_Str = @Sql_Str + ' AND (dbo.sysusers.name = N''' + RTRIM(@db_Owner) + ''')'
				SET @Sql_Str = @Sql_Str + ' ORDER BY dbo.syscolumns.colid'
		END
	
		IF (@Type_ODBC = 'ORA')
		BEGIN
	
			SET @Sql_Str = ' SELECT	COLUMN_NAME COLUMNNAME, DATA_TYPE DATATYPE, DATA_LENGTH COLUMNSIZE, NVL(DATA_PRECISION,0) NUMERICPRECISION, '
			SET @Sql_Str = @Sql_Str + ' NVL(DATA_SCALE,0) NUMERICSCALE,CASE WHEN NULLABLE = ''Y'' THEN ''TRUE'' ELSE ''FALSE'' END ALLOWDBNULL'
			SET @Sql_Str = @Sql_Str + ' FROM SYS.ALL_TAB_COLUMNS '
			SET @Sql_Str = @Sql_Str + ' WHERE UPPER(TABLE_NAME) = ''' + UPPER(@db_Table) + ''' AND UPPER(OWNER) = ''' + UPPER(@db_Owner) + ''''
			SET @Sql_Str = @Sql_Str + ' ORDER BY COLUMN_ID'
 
		END
	
		IF (@Type_ODBC = 'DB2')
		BEGIN
				 SET @Sql_Str = ' SELECT RTRIM(NAME) AS COLUMNNAME, RTRIM(COLTYPE) AS DATATYPE,'
				 SET @Sql_Str = @Sql_Str + ' CASE COLTYPE WHEN ''DECIMAL'' THEN CASE WHEN Length >= 1 and length <= 9 THEN 5 WHEN length >=10 and length <=19 THEN 9 WHEN length >=20 and length <=28 THEN 13 ELSE 17 END ELSE LENGTH END AS COLUMNSIZE,' 
				 SET @Sql_Str = @Sql_Str + ' CASE COLTYPE WHEN ''DECIMAL'' THEN LENGTH ELSE 0 END as NUMERICPRECISION,'
				 SET @Sql_Str = @Sql_Str + ' SCALE AS NUMERICSCALE, CASE NULLS WHEN ''N'' Then ''FALSE'' ELSE  ''TRUE'' END as ALLOWDBNULL'
				 SET @Sql_Str = @Sql_Str + ' FROM SYSIBM.SYSCOLUMNS WHERE RTRIM(TBCREATOR) = ''' + UPPER(@db_Owner) + ''' AND TBNAME = UPPER(''' + UPPER(@db_Table) + ''') ORDER BY COLNO asc, 1 ASC, 2 ASC, 3 ASC;'
		END
	
		IF (@Type_ODBC = 'HNN')
		  BEGIN    
		  --TABLE_COLUMNS.SCHEMA_NAME, TABLE_COLUMNS.TABLE_NAME, TABLE_COLUMNS.TABLE_OID,TABLE_COLUMNS.POSITION, TABLE_COLUMNS.DATA_TYPE_ID,         
			SET @Sql_Str = ' SELECT TABLE_COLUMNS.COLUMN_NAME AS COLUMNNAME,'
			SET @Sql_Str = @Sql_Str + ' TABLE_COLUMNS.DATA_TYPE_NAME AS DATATYPE,'
			--SET @Sql_Str = @Sql_Str + ' TABLE_COLUMNS.OFFSET AS COLUMNSIZE,'
			--SET @Sql_Str = @Sql_Str + ' TABLE_COLUMNS.LENGTH AS NUMERICPRECISION,'
			SET @Sql_Str = @Sql_Str + ' CASE WHEN TABLE_COLUMNS.DATA_TYPE_NAME = ''DECIMAL'' THEN CASE WHEN TABLE_COLUMNS.LENGTH >= 1 and TABLE_COLUMNS.LENGTH <= 9 THEN 5 WHEN TABLE_COLUMNS.LENGTH >=10 and TABLE_COLUMNS.LENGTH <=19 THEN 9 WHEN TABLE_COLUMNS.LENGTH >=20 and TABLE_COLUMNS.LENGTH <=28 THEN 13 ELSE 17 END ELSE TABLE_COLUMNS.LENGTH END AS COLUMNSIZE,' 
			SET @Sql_Str = @Sql_Str + ' CASE WHEN TABLE_COLUMNS.DATA_TYPE_NAME =''DECIMAL'' THEN TABLE_COLUMNS.LENGTH ELSE 0 END as NUMERICPRECISION,'          
			SET @Sql_Str = @Sql_Str + ' CASE WHEN TABLE_COLUMNS.SCALE IS NULL THEN 0 ELSE TABLE_COLUMNS.SCALE END AS NUMERICSCALE,'
			SET @Sql_Str = @Sql_Str + ' TABLE_COLUMNS.IS_NULLABLE as ALLOWDBNULL'
			SET @Sql_Str = @Sql_Str + ' FROM SYS.TABLE_COLUMNS'
			SET @Sql_Str = @Sql_Str + ' WHERE (TABLE_COLUMNS.TABLE_NAME=UPPER(''' + UPPER(@db_Table) + ''')) AND  TABLE_COLUMNS.SCHEMA_NAME = ''' + UPPER(@db_Owner) + ''' ORDER BY POSITION ASC'
		  END
	
		IF (@Type_ODBC = 'TXT')
		BEGIN	
			--DECLARE @I_Position INT
			--DECLARE @Name_File VARCHAR(100)
		
			--SELECT @I_Position = CHARINDEX('\', REVERSE(@db_Path)) -1
			--SELECT @Name_File  = SUBSTRING(@db_Path,LEN(@db_Path)-(@I_Position -1),@I_Position) 
			--SET @Sql_Str = ' SELECT	* FROM ' + @Name_File@db_Separador
			SET @Sql_Str = @db_Separador
		END
	
		IF (@Type_ODBC ='XLS')
		BEGIN	
			SET @Sql_Str = @db_Table
		END
	
		IF (@Type_ODBC = 'MDB' OR @Type_ODBC = 'ACCDB')
		BEGIN	
			SET @Sql_Str = @db_Table
		END
	
		IF (@Type_ODBC = 'FBIRD')
		BEGIN	
			SET @Sql_Str = 'SELECT RF.RDB$FIELD_NAME AS COLUMNNAME,'
			SET @Sql_Str = @Sql_Str + ' CASE WHEN F.RDB$FIELD_TYPE = 7 THEN ''SMALLINT'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 8 THEN ''INTEGER'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 10 THEN ''FLOAT'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 12 THEN ''DATE'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 13 THEN ''TIME'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 14 THEN ''CHAR'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 16 AND F.RDB$FIELD_SUB_TYPE = 1 THEN ''NUMERIC'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 16 AND F.RDB$FIELD_SUB_TYPE = 2 THEN ''DECIMAL'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 16 THEN ''BIGINT'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 27 THEN ''DOUBLE PRECISION'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 35 THEN ''TIMESTAMP'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 37 THEN ''VARCHAR'''
			SET @Sql_Str = @Sql_Str + ' WHEN F.RDB$FIELD_TYPE = 261 THEN ''BLOB'' '
			SET @Sql_Str = @Sql_Str + ' ELSE ''OTRO'' END AS DATATYPE,'
			SET @Sql_Str = @Sql_Str + ' COALESCE(F.RDB$CHARACTER_LENGTH,0) AS COLUMNSIZE,'
			SET @Sql_Str = @Sql_Str + ' COALESCE(F.RDB$FIELD_PRECISION,0) AS NUMERICPRECISION,'
			SET @Sql_Str = @Sql_Str + ' CASE WHEN F.RDB$FIELD_SCALE < 0 THEN ABS(F.RDB$FIELD_SCALE)'
			SET @Sql_Str = @Sql_Str + ' ELSE 0 END AS NUMERICSCALE,'
			SET @Sql_Str = @Sql_Str + ' CASE WHEN RF.RDB$NULL_FLAG IS NULL THEN ''TRUE'''
			SET @Sql_Str = @Sql_Str + ' ELSE ''FALSE'' END AS ALLOWDBNULL FROM RDB$RELATION_FIELDS AS RF'
			SET @Sql_Str = @Sql_Str + ' LEFT JOIN RDB$FIELDS AS F ON'
			SET @Sql_Str = @Sql_Str + ' RF.RDB$FIELD_SOURCE = F.RDB$FIELD_NAME'
			SET @Sql_Str = @Sql_Str + ' WHERE RDB$RELATION_NAME =''' + @db_Table + ''' '
			SET @Sql_Str = @Sql_Str + ' ORDER BY RDB$FIELD_POSITION ASC ; '
		END

		IF (@Type_ODBC = 'MYSQL')
		BEGIN	
			SET @Sql_Str = 'SELECT COLUMN_NAME as COLUMNNAME, DATA_TYPE as DATATYPE, ifnull(CHARACTER_MAXIMUM_LENGTH,0) as COLUMNSIZE, ifnull(NUMERIC_PRECISION,0) as NUMERICPRECISION, ifnull(NUMERIC_SCALE,0) as NUMERICSCALE, IS_NULLABLE as ALLOWDBNULL FROM INFORMATION_SCHEMA.COLUMNS  WHERE table_name = '''+ @db_Table +
							'''AND table_schema = '''+ @db_Owner +''';'
		END
		
		IF (@Type_ODBC = 'FOXPRO')
		BEGIN	
			SET @Sql_Str = 'Select * FROM '+ @db_Path
		END
	
		SELECT @Sql_Str AS Consulta;	
END;
