CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_View_D] @KeyUnic VARCHAR(50), @IsRun BIT AS

DECLARE @varKeyUnic VARCHAR(700)




SET @varKeyUnic = 'SELECT distinct path_unickey
				  ,path_position
				  ,name
				  ,path_message
				  ,Option1
				  ,date_programado
				  ,date_inicio
				  ,date_fin
				  ,path_executeuser
				  ,show_error
				  ,Path_hStatus
			  FROM dabarc.vw_Run_Details 
			  WHERE LTRIM(RTRIM(path_unickey)) = ''' + @KeyUnic + ''''


  IF (@IsRun = 1)
	 SET @varKeyUnic = @varKeyUnic + ' AND Path_hStatus < 4'
  SET @varKeyUnic = @varKeyUnic + ' ORDER BY path_position ASC'
 EXECUTE(@varKeyUnic)
