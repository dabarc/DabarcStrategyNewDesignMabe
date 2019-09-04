CREATE PROCEDURE [dabarc].[sp_ODBC_ReadListODBC] 
	
AS


	SELECT	odbc_id as object_id
			,r.driver_dbms
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' OR odbc_type = 'FBIRD' THEN file_path ELSE 'Driver=' + r.driver_text + ';server=' + odbc_server + ';dbq=' + odbc_server + ';Database=' + odbc_database + ';Uid=' + odbc_user + ';pwd=' + odbc_pasword + '' END as odbc_string
			,odbc_name			
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_server END AS odbc_server
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_database END AS odbc_database
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_esquema END AS odbc_esquema
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_user END AS odbc_user
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_pasword END AS odbc_password
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_port END AS odbc_port
			,CASE WHEN odbc_type = 'TXT' OR odbc_type = 'XLS' OR odbc_type = 'MDB' OR odbc_type = 'ACCDB' THEN 'N/A' ELSE odbc_protocol END AS odbc_protocol
		    ,last_error
		    ,file_path
			,file_separation
			,odbc_type
			,r.driver_id
			,odbc_alias  	
  FROM      dabarc.t_ODBC o
			INNER JOIN dabarc.t_ODBC_driver r ON o.driver_id = r.driver_id
  ORDER BY o.create_date desc