CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_getIsDetailsActive] @path_unickey AS NVARCHAR(15), @path_position INT AS

 ---------------------------------------------------------------------------------------------
 --- Parametros : @Path_hkey = Llave conformada un registro 
 --- Proceso : Consulta el registro que se va ha ejecutar 
 --- Retorno : Una bandera que verifica si el detalle no esta en pausa o cancelado
 ---------------------------------------------------------------------------------------------
 
	SELECT  CASE WHEN path_status = 1 THEN 1 ELSE 0 END AS B_RETURN
	FROM dabarc.t_Sql_process_executeD WHERE RTRIM(path_unickey) = RTRIM(@path_unickey) AND path_position = @path_position
