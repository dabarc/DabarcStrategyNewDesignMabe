CREATE VIEW [dabarc].[vw_Run_Details] AS
SELECT path_unickey
      ,path_position
      ,'(' + path_type + ')' + path_name AS name     
      ,CASE WHEN path_status = 5 THEN 'Error' 
			ELSE d.path_message  END AS path_message
      ,CASE WHEN path_status = 1 and Path_hStatus < 4THEN 'Cancelar'
			WHEN path_status in (6,5) and Path_hStatus < 4
			THEN 'Continuar'	 END Option1
      ,CONVERT(VARCHAR(20),path_date,109) as date_programado
      ,CONVERT(VARCHAR(20),path_dateini,109) as date_inicio
      ,CONVERT(VARCHAR(20),path_datefin,109) as date_fin
      ,path_executeuser
	  ,CASE WHEN path_status = 5 THEN d.path_message 
			ELSE '' END AS show_error
      ,Path_hStatus      
FROM dabarc.t_Sql_process_executeD d
	INNER JOIN dabarc.t_Sql_process_executeH h ON d.path_unickey = h.Path_hKey
