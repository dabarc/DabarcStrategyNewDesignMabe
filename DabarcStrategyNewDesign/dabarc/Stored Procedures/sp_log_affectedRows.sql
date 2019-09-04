
CREATE PROCEDURE [dabarc].[sp_log_affectedRows] @path_unickey AS NVARCHAR(15), @intId INT AS

 
	DECLARE @path_table varchar(15),
			@path_id INT,
			@affected_rows INT
	
	SELECT @path_table = path_table, @path_id = path_id 
	FROM t_Sql_process_executeD 
	WHERE path_unickey = @path_unickey AND path_position = @intId
	
	IF @path_table = 't_SSIS'
	
	SELECT @affected_rows = affected_rows
	FROM t_SSIS 
	WHERE ssis_id = @path_id
	
	IF @path_table = 't_IDM' 
	
	SELECT @affected_rows = affected_rows
	FROM t_IDM 
	WHERE report_id = @path_id
	
	IF @path_table = 't_IFF'
	
	SELECT @affected_rows = affected_rows
	FROM t_IFF 
	WHERE report_id = @path_id
	
	IF @path_table = 't_IFM'
	
	SELECT @affected_rows = affected_rows
	FROM t_IFM 
	WHERE report_id = @path_id 
	
	IF @path_table = 't_RDM'
	
	SELECT @affected_rows = affected_rows
	FROM t_RDM 
	WHERE rule_id = @path_id 
	
	IF @path_table = 't_RFF'
	
	SELECT @affected_rows = affected_rows
	FROM t_RFF
	WHERE rule_id = @path_id 
	
	IF @path_table = 't_RFM'
	
	SELECT @affected_rows = affected_rows
	FROM t_RFM
	WHERE rule_id = @path_id 
	
	IF @path_table = 't_RRF'
	
	SELECT @affected_rows = affected_rows
	FROM t_RFM
	WHERE rule_id = @path_id 
	
	
	
	----- Actualizamos los registros
	
	UPDATE t_Sql_process_executeD
	SET affected_rows = @affected_rows
	WHERE path_unickey = @path_unickey AND path_id = @path_id
