 CREATE PROCEDURE [dabarc].[sp_ODBC_ReadODBCforDriver_Esquema] @odbc_id INT AS  
  
 DECLARE @Type_ODBC   VARCHAR(6)  
 DECLARE @db_Path   NVARCHAR(50)  
  
  
  
 SELECT @Type_ODBC = r.driver_cva,  
          @db_Path = o.file_path  
 FROM t_ODBC o  
 INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id  
 WHERE o.odbc_id = @odbc_id  
  
  
 IF (@Type_ODBC = 'ORA')  
 BEGIN  
   SELECT  'DRIVER=' + r.driver_text + ';SERVER=' + odbc_server + ';DBQ=' + odbc_database + ';UID=' + odbc_user + ';PWD=' + odbc_pasword + '' AS  odbc_string,   
    'SELECT 0 object_id, USERNAME FROM SYS.ALL_USERS ORDER BY 2' AS Query,  
    odbc_type  
   FROM t_ODBC o  
   INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id  
   WHERE o.odbc_id = @odbc_id  
 END  
   
   
 IF (@Type_ODBC = 'MSS')  
 BEGIN  
   SELECT  'Driver=' + r.driver_text + ';server=' + odbc_server + ';Database=' + odbc_database + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + ';Connect Timeout=30' + '' AS  odbc_string,       
    'SELECT DISTINCT 0 as schema_id,TABLE_SCHEMA  FROM INFORMATION_SCHEMA.TABLES' AS Query,  
    odbc_type  
   FROM t_ODBC o   
   INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id  
   WHERE o.odbc_id = @odbc_id  
 END  
  
 IF (@Type_ODBC = 'INFO')  
 BEGIN  
   SELECT  'Driver=' + r.driver_text + ';UID=' + odbc_user + ';PWD=' + odbc_pasword + ';DATABASE=' + odbc_database + ';HOST=' + odbc_server + ';SRVR=' + odbc_infoServidor + ';SERV=' + odbc_infoServicio + ';PRO=' + odbc_infoProtocolo + ';DLOC=en_US.819;CLO
C=en_US.CP1252;' AS  odbc_string,  
    'SELECT DISTINCT  0 as schema_id,  Owner FROM SYSTABLES ' AS Query,  
    odbc_type  
   FROM t_ODBC o   
   INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id  
   WHERE o.odbc_id = @odbc_id  
 END  
   
 IF (@Type_ODBC = 'DB2')  
 BEGIN  
   SELECT  'Driver=' + r.driver_text + ';Database=' + odbc_database + ';HostName=' + odbc_server + ';Protocol=' + odbc_protocol + ';Port=' + odbc_port + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + '' AS  odbc_string,        
    'SELECT DISTINCT  0 SCHEMA_ID, TBCREATOR NAME FROM SYSIBM.SYSCOLUMNS Order By 1 asc, 2 asc' AS Query,  
    odbc_type  
   FROM t_ODBC o   
   INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id  
   WHERE o.odbc_id = @odbc_id  
 END  
  
 IF (@Type_ODBC = 'HNN')  
 BEGIN  
   SELECT  'Driver=' + r.driver_text + ';UID=' + odbc_user + '; PWD=' + odbc_pasword + ';DATABASENAME=' + odbc_database + ';SERVERNODE=' + RTRIM(odbc_server) + ':' + LTRIM(RTRIM(odbc_port)) AS  odbc_string,  
    'SELECT DISTINCT 0 as schema_id, TABLES.SCHEMA_NAME FROM SYS.TABLES' AS Query,  
    odbc_type  
   FROM t_ODBC o   
   INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id  
   WHERE o.odbc_id = @odbc_id  
 END  
 IF (@Type_ODBC = 'FBIR')    
 BEGIN    
   SELECT  'Driver=' + r.driver_text + ';UID=' + odbc_user + '; PWD=' + odbc_pasword + ';DATABASENAME=' + odbc_database + ';SERVERNODE=' + RTRIM(odbc_server) + ':' + LTRIM(RTRIM(odbc_port)) AS  odbc_string,    
    'SELECT DISTINCT 0 as schema_id, TABLES.SCHEMA_NAME FROM SYS.TABLES' AS Query,    
    odbc_type    
   FROM t_ODBC o     
   INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id    
   WHERE o.odbc_id = @odbc_id    
 END 
 IF (@Type_ODBC = 'MYSQL')
	BEGIN
			SELECT  'Driver=' + r.driver_text + ';server=' + odbc_server + ';Port='+ odbc_port +';Database=' + odbc_database + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + '' +';Option=3;'AS  odbc_string, 	
	                'SELECT DISTINCT 0 as schema_id,TABLE_SCHEMA  FROM INFORMATION_SCHEMA.TABLES' AS Query,
		            odbc_type
            FROM    dabarc.t_ODBC o 
		            INNER JOIN dabarc.t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id
	END
	
	IF (@Type_ODBC = 'FOXPRO')
    Begin
      Declare @type varchar(3)
      select @type=substring(@db_Path,charindex('.',@db_Path)+1,3)
      SELECT  'DRIVER=' + r.driver_text + ';SourceType='+ @type +';SourceDB=' + @db_Path + ';Exclusive=No;NULL=NO;Collate=Machine;BACKGROUNDFETCH=NO;DELETED=NO;' AS  odbc_string, 
				'Select * FROM ' + @db_Path AS Query,
				odbc_type
			FROM t_ODBC o
			INNER JOIN t_ODBC_driver r ON o.driver_id = r.driver_id
			WHERE o.odbc_id = @odbc_id
    End
