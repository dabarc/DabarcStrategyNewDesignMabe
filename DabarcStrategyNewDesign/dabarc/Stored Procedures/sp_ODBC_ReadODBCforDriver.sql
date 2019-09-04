CREATE PROCEDURE [dabarc].[sp_ODBC_ReadODBCforDriver] 
	@odbc_id INT, 
	@strEsquema VARCHAR(30),
	@strFiltro VARCHAR(20)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Type_ODBC	  VARCHAR(6);
	DECLARE @db_Path	  NVARCHAR(250);
	DECLARE @strWhere	  NVARCHAR(100) = ' ';

	SELECT	@Type_ODBC	= r.driver_cva,
			@db_Path	= o.file_path
	FROM	t_ODBC AS o
			INNER JOIN t_ODBC_driver AS r ON o.driver_id = r.driver_id
	WHERE o.odbc_id = @odbc_id;

	IF (@Type_ODBC = 'ORA')
		BEGIN
				IF (@strFiltro <> '') 
					SET @strWhere = ' table_name like ''' + upper(@strFiltro) + '%'' AND '
	
				SELECT  'DRIVER=' + r.driver_text + ';SERVER=' + odbc_server + ';DBQ=' + odbc_database + ';UID=' + odbc_user + ';PWD=' + odbc_pasword +  '' AS  odbc_string, 
					'SELECT distinct table_name FROM SYS.ALL_TAB_COLUMNS WHERE' + @strWhere + 'OWNER = ''' + @strEsquema + '''' AS Query,
					odbc_type
				FROM t_ODBC o
				INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
				WHERE o.odbc_id = @odbc_id
		END
	
	IF (@Type_ODBC = 'DB2')
		BEGIN
					IF (@strFiltro <> '') 
						SET @strWhere = ' TBNAME like ''' + @strFiltro + '%'' AND '
				
					SELECT  'Driver=' + r.driver_text + ';Database=' + odbc_database + ';HostName=' + RTRIM(odbc_server) + ';Protocol=' + ltrim(RTRIM(odbc_protocol)) + ';Port=' + LTRIM(RTRIM(odbc_port)) + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + ';querytimeout=0;interrupt=0;' AS  odbc_string, 
					'SELECT DISTINCT TBNAME TABLE_NAME FROM SYSIBM.SYSCOLUMNS WHERE' + @strWhere + 'TBCREATOR = ''' + @strEsquema + ''' Order By 1 asc' AS Query,
					odbc_type
				FROM t_ODBC o
				INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
				WHERE o.odbc_id = @odbc_id
		END
	
	IF (@Type_ODBC = 'INFO')
		BEGIN
			IF (@strFiltro <> '') 
						SET @strWhere = ' TBNAME like ''' + @strFiltro + '%'' AND '
		
		
				SELECT  'Driver=' + r.driver_text + ';UID=' + odbc_user + '; PWD=' + odbc_pasword + ';DATABASE=' + odbc_database + ';HOST=' + odbc_server + ';SRVR=' + odbc_infoServidor + ';SERV=' + odbc_infoServicio + ';PRO=' + odbc_infoProtocolo + ';DLOC=en_US.819;CLOC=en_US.CP1252;' AS  odbc_string,
					'SELECT DISTINCT  0 as schema_id,  Owner FROM SYSTABLES ' AS Query,
					odbc_type
				FROM t_ODBC o 
				INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
				WHERE o.odbc_id = @odbc_id
		END
	
	IF (@Type_ODBC = 'MSS')
	BEGIN

 				IF (@strFiltro <> '') 
					SET @strWhere = ' table_name like ''%' + @strFiltro + '%'' AND '
					
			SELECT  'Driver=' + r.driver_text + ';server=' + odbc_server + ';Database=' + odbc_database + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + '' AS  odbc_string, 				
				'SELECT table_name AS [Table]
					FROM INFORMATION_SCHEMA.TABLES  WHERE' + @strWhere + ' TABLE_SCHEMA = N''' + @strEsquema + ''' Order By table_name asc' as Query,
				odbc_type
			FROM t_ODBC o
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id			
	END
		
	IF (@Type_ODBC = 'TXT')
	BEGIN
		DECLARE @I_Position INT
		DECLARE @Name_Path VARCHAR(100)
		DECLARE @Name_File VARCHAR(100)
		
			SELECT  @db_Path AS  odbc_string, 
				'SELECT * FROM ' + @db_Path AS sqlTable,		
				odbc_type,
				odbc_notcolname
			FROM t_ODBC o
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id

	END
	 
	IF (@Type_ODBC = 'XLS')
	BEGIN
				SELECT  'DRIVER=Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb);DBQ=' + @db_Path + '' AS  odbc_string, 
				@db_Path AS Query,
				odbc_type
			FROM t_ODBC o
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id
	END
	
	IF (@Type_ODBC = 'MDB' OR RTRIM(@Type_ODBC) = 'ACCDB')
	BEGIN
				SELECT  'DRIVER=' + r.driver_text + ';DBQ=' + @db_Path + ';UID=admin; UserCommitSync=Yes; Threads=3 ; SafeTransactions=0; PageTimeout=5' AS  odbc_string, 
				@db_Path AS Query,
				odbc_type
			FROM t_ODBC o
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id
	END
	
	IF (@Type_ODBC = 'FBIRD')
	BEGIN
		IF(@strFiltro <> '')
				 SET @strWhere = 'a.RDB$RELATION_NAME LIKE''' + upper(@strFiltro) + '%'' AND'
		SELECT  'DRIVER=' + r.driver_text + ';dbname=' + @db_Path + ';charset=NONE;Uid=' + odbc_user + ';pwd=' + odbc_pasword + ';client=' + file_dll AS odbc_string, 
				'SELECT a.RDB$RELATION_NAME FROM RDB$RELATIONS a WHERE ' + @strWhere +' RDB$SYSTEM_FLAG = 0 AND RDB$RELATION_TYPE = 0;' AS Query,
				odbc_type
			FROM t_ODBC o
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id
	END	
	
	IF (@Type_ODBC = 'HNN')
	BEGIN
		IF (@strFiltro <> '') 
					SET @strWhere = ' TABLES.TABLE_NAME like ''' + @strFiltro + '%'' AND '
				
		--DRIVER={HDBODBC};DataBasename=SSIS;ServerNode=10.1.80.52:39015;Uid=oghtipal;Pwd=Gamboa.2016

			SELECT  'Driver=' + r.driver_text + ';UID=' + odbc_user + '; PWD=' + odbc_pasword + ';DATABASENAME=' + odbc_database + ';SERVERNODE=' + RTRIM(odbc_server) + ':' + LTRIM(RTRIM(odbc_port)) AS  odbc_string,
				'SELECT DISTINCT TABLES.TABLE_NAME AS Table FROM SYS.TABLES WHERE' + @strWhere + ' TABLES.SCHEMA_NAME = N''' + @strEsquema + ''' Order By 1 asc' AS Query,
				odbc_type
			FROM t_ODBC o 
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id
	END
	
	IF (@Type_ODBC = 'FOXPRO')
		Begin
		  Declare @type varchar(3)
		  select @type=substring(@db_Path,charindex('.',@db_Path)+1,3)
		  SELECT  'DRIVER=' + r.driver_text + ';SourceType='+ @type +';SourceDB=' + @db_Path + ';Exclusive=No;NULL=NO;Collate=Machine;BACKGROUNDFETCH=NO;DELETED=NO;' AS  odbc_string, 
					'Select * FROM '+@db_Path,
					odbc_type
				FROM t_ODBC o
				INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
				WHERE o.odbc_id = @odbc_id
		End    
	
	IF (@Type_ODBC = 'MYSQL')
		BEGIN
		       IF (@strFiltro <> '') 
					SET @strWhere = ' table_name like ''%' + @strFiltro + '%'' AND '

				SELECT  'Driver=' + r.driver_text + ';server=' + odbc_server + ';Port='+ odbc_port +';Database=' + odbc_database + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + '' +';Option=3;'AS  odbc_string, 	
						'SELECT 
						      TABLE_NAME 
							  FROM INFORMATION_SCHEMA.TABLES 
							  WHERE' + @strWhere + ' TABLE_SCHEMA = N''' + @strEsquema + ''' Order By TABLE_NAME ASC' as Query,	  
						 odbc_type
				FROM t_ODBC o
				INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
				WHERE o.odbc_id = @odbc_id			
		END
END;
