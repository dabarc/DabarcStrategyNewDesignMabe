CREATE PROCEDURE  [dabarc].[sp_TBL_DeleteRowOfAll]
	
	(	
	@table_id		INT,	
	@type_table		CHAR(4),
	@delete_user	NVARCHAR(15)
	)
	
AS
	DECLARE @delete_date DATETIME,
			@name		 NVARCHAR(128)

	SET @delete_date = GETDATE()


	----------------------------------------------------------------------------------------
	--- Tabla temporal
	----------------------------------------------------------------------------------------
	
	CREATE TABLE #Return(id INT)

	----------------------------------------------------------------------------------------
	--- Validamos que no tenga elementos registrados
	----------------------------------------------------------------------------------------

	If (UPPER(RTRIM(@type_table)) = 'TFF')
	BEGIN	
	
		INSERT INTO #Return
		SELECT rule_id		FROM dabarc.t_RFF  WHERE table_id = @table_id
		UNION
		SELECT report_id	FROM dabarc.t_IFF  WHERE table_id = @table_id
		UNION		
		SELECT ssis_id		FROM dabarc.t_SSIS WHERE table_id = @table_id AND name like 'SSIS_TFF_%'
	
	
	    ----------------------------------------------------------------------------------------
		--- Consultamos y Eliminamos el registro
		--- Registramos Movimientos
		----------------------------------------------------------------------------------------

	   IF (SELECT COUNT(*) FROM #Return) > 0
	   BEGIN
	--	RAISERROR('La tabla tiene reglas, reportes y/o SSIS relacionados, que deben ser quitados para eliminarlo.', 16, 1);
		RAISERROR (50039,16,1, '','')
		RETURN;
	   END
	   
	   
	   SELECT	@name = name FROM dabarc.t_TFF WHERE table_id = @table_id;
	   DELETE	FROM dabarc.t_TFF   WHERE table_id = @table_id;
	   EXECUTE	dabarc.sp_log_InsertRegisterLogMov 'ELIMINAR','t_TFF',@table_id,@name,@delete_date,@delete_user;   
	 
	END
	
	
	If (UPPER(RTRIM(@type_table)) = 'TDM')
	BEGIN	
	
		INSERT INTO #Return
		SELECT rule_id		FROM dabarc.t_RDM  WHERE table_id = @table_id
		UNION
		SELECT report_id	FROM dabarc.t_IDM  WHERE table_id = @table_id
		UNION		
		SELECT ssis_id		FROM dabarc.t_SSIS WHERE table_id = @table_id AND name like 'SSIS_TDM_%'
	
	
	    ----------------------------------------------------------------------------------------
		--- Consultamos y Eliminamos el registro
		--- Registramos Movimientos
		----------------------------------------------------------------------------------------

	   IF (SELECT COUNT(*) FROM #Return) > 0
	   BEGIN
	--	RAISERROR('La tabla tiene reglas, reportes y/o SSIS relacionados, que deben ser quitados para eliminarlo.', 16, 1);
		RAISERROR (50039,16,1, '','')
		RETURN;
	   END
	   
	   
	   SELECT	@name = name FROM dabarc.t_TDM WHERE table_id = @table_id;
	   DELETE	FROM t_TDM   WHERE table_id = @table_id;
	   EXECUTE	sp_log_InsertRegisterLogMov 'ELIMINAR','t_TDM',@table_id,@name,@delete_date,@delete_user;   
	 
	END
	
	
	If (UPPER(RTRIM(@type_table)) = 'TFM')
	BEGIN	
	
		INSERT INTO #Return
		SELECT rule_id		FROM dabarc.t_RFM  WHERE table_id = @table_id
		UNION
		SELECT report_id	FROM dabarc.t_IFM  WHERE table_id = @table_id
		UNION		
		SELECT ssis_id		FROM dabarc.t_SSIS WHERE table_id = @table_id AND name like 'SSIS_TFM_%'
	
	
	    ----------------------------------------------------------------------------------------
		--- Consultamos y Eliminamos el registro
		--- Registramos Movimientos
		----------------------------------------------------------------------------------------

	   IF (SELECT COUNT(*) FROM #Return) > 0
	   BEGIN
	--	RAISERROR('La tabla tiene reglas, reportes y/o SSIS relacionados, que deben ser quitados para eliminarlo.', 16, 1);
		RAISERROR (50039,16,1, '','')
		RETURN;
	   END
	   
	   
	   SELECT	@name = name FROM dabarc.t_TFM WHERE table_id = @table_id;
	   DELETE	FROM t_TFM   WHERE table_id = @table_id;
	   EXECUTE	dabarc.sp_log_InsertRegisterLogMov 'ELIMINAR','t_TFM',@table_id,@name,@delete_date,@delete_user;   
	 
	END
