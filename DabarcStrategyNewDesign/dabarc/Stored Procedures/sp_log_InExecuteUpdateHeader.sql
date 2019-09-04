CREATE PROCEDURE [dabarc].[sp_log_InExecuteUpdateHeader]
	(
		@Path_hkey		NVARCHAR(30),
		@int_status		INT,
		@execute_time	NVARCHAR(25),
		@error_message	NVARCHAR(4000)
	)
	
AS

DECLARE @vstr_sql		NVARCHAR(500)
DECLARE @vPath_hName	NVARCHAR(300)
DECLARE @vPath_hType	NVARCHAR(20)
DECLARE @vPath_TypeClass NVARCHAR(20)

DECLARE @vvarTime		NCHAR(20)


	-- Correcto     (Tiempo, Afectados, estado = 3)
	-- Error        (Tiempo, estado = 3, texto de error)

---------------------------------------------------------------------------------------------------------
---  Esto solo se aplica a Base de Datos y Tablas 
---  Buscamos el header y obtenemos la tabla, la columna y el registro 
---------------------------------------------------------------------------------------------------------

 SELECT	@vPath_hName = RTRIM(Path_hName), 
		@vPath_hType = RTRIM(Path_hType), 
		@vPath_TypeClass = 'T_' + RTRIM(path_TypeClass),
		@vvarTime = Path_hTime
 FROM	t_Sql_process_executeH 
 WHERE	Path_hKey = @Path_hkey AND (RTRIM(UPPER(Path_hType)) = 'TABLE'  OR RTRIM(UPPER(Path_hType)) = 'BASE DE DATOS')


 SELECT *
 FROM	dabarc.t_Sql_process_executeD
 WHERE	path_unickey = @Path_hkey

---------------------------------------------------------------------------------------------------------
--- Registramo sel estado y el error en caso de se la ocación
---------------------------------------------------------------------------------------------------------

	SET @vstr_sql = 'UPDATE  ' + @vPath_TypeClass + ''
	
	
	if (@int_status = 3)
	BEGIN
			SET @vstr_sql = @vstr_sql + ' SET  execute_time = ''' + @vvarTime + ''', 
							last_error = ''Ejecución satisfactoria'',
							status = 3'
	END
	
	if (@int_status = 4)
	BEGIN
			SET @vstr_sql = @vstr_sql + ' SET  execute_time = ''' + @vvarTime + ''', 
							last_error = ''' + RTRIM(@error_message) + ''',
							status = 4'
	END
	
	    SET @vstr_sql = @vstr_sql + ' WHERE LTRIM(RTRIM(name)) = ' + LTRIM(RTRIM(@vPath_hName))
