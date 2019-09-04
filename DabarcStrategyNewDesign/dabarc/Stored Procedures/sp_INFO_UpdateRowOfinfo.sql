--EXEC  [dabarc].[sp_INFO_UpdateRowOfinfo] 'IFF', 1, 1, 1, 'Prueba', 'Prueba', 'LIMPIEZA', 'XLSX', '|', '', 0, '', 0, 'admin', 0;
CREATE PROCEDURE  [dabarc].[sp_INFO_UpdateRowOfinfo]
	
	(
	@typeOfInformation	varchar(5),	
	@report_id			int,
	@active				bit,
	@priority			int,	
	@description		nvarchar(256),
	@short_description	nvarchar(50),
	--@IsTypeError		bit,
	@report_type		nvarchar(14),
	@report_export		nvarchar(10),
	@report_separator	nvarchar(10),
	@report_typeseg		nvarchar(10),
	@report_segamount   numeric(18,0),
	@report_segfield    nvarchar(50),	
	@report_createzip	int,
	@modify_user		nvarchar(15),
	@report_adddate		bit
	)
	
AS
	DECLARE @modify_date DATETIME
	DECLARE @str_sql	 VARCHAR(700)

	SET @modify_date = GETDATE()


	----------------------------------------------------------------------------------------------------------------------------------
	--- Temporales
	----------------------------------------------------------------------------------------------------------------------------------
	
	  CREATE TABLE #tmpResult(CountField INT)

	----------------------------------------------------------------------------------------------------------------------------------
	--- VALIDAR
	--- Validar prioridad
	----------------------------------------------------------------------------------------------------------------------------------

	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	 --  RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
	   RAISERROR (50051,16,1, '','')
	   RETURN;
	END
	
	
	IF (RTRIM(@report_typeseg) = 'XCAMP')
	BEGIN
		INSERT INTO #tmpResult execute dabarc.sp_INFO_ValidateFieldOfSql @typeOfInformation,@report_id,@report_segfield
		IF (SELECT COUNT(*) FROM #tmpResult WHERE CountField = 0) >= 1
		BEGIN
	--	   RAISERROR('El nombre no corresponde con ninguna columna de la vista', 16, 1);
		    RAISERROR (50009,16,1, '','')
		   RETURN;	
		END
	END

	
	IF (RTRIM(@typeOfInformation) = 'IFF')
	BEGIN 
	   UPDATE	t_IFF 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority, 
				report_type = @report_type,
				report_export = @report_export,
				report_separator = @report_separator,
				IsTypeError = CASE WHEN @report_type = 'ERRO' THEN 1 ELSE 0 END,
				modify_date = @modify_date, 
				modify_user = @modify_user,
				report_typeseg = @report_typeseg,
				report_segamount = @report_segamount,
				report_segfield = @report_segfield,
				report_adddate = @report_adddate,
				report_createzip = @report_createzip
		WHERE   (report_id = @report_id)

	END
 
	IF (RTRIM(@typeOfInformation) = 'IDM')	
	BEGIN
		 UPDATE	t_IDM 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority, 
				report_type = @report_type,
				report_export = @report_export,
				report_separator = @report_separator,
				IsTypeError = CASE WHEN @report_type = 'ERRO' THEN 1 ELSE 0 END,
				modify_date = @modify_date, 
				modify_user = @modify_user,
				report_typeseg = @report_typeseg,
				report_segamount = @report_segamount,
				report_segfield = @report_segfield,
				report_adddate = @report_adddate,
				report_createzip = @report_createzip				
		WHERE   (report_id = @report_id)
	END
	 
	IF (RTRIM(@typeOfInformation) = 'IFM')	
	BEGIN
		   UPDATE	t_IFM 
		SET		description = @description, 
				short_description = @short_description, 
				active = @active, 
				priority = @priority, 
				report_type = @report_type,
				report_export = @report_export,
				report_separator = @report_separator,				
				modify_date = @modify_date, 
				modify_user = @modify_user,
				report_typeseg = @report_typeseg,
				report_segamount = @report_segamount,
				report_segfield = @report_segfield,
				report_adddate = @report_adddate,
				report_createzip = @report_createzip				
		WHERE   (report_id = @report_id)
	END


  ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
	DECLARE @pTable NCHAR(10)
	SET @pTable = 't_' + @typeOfInformation
	EXECUTE dabarc.sp_log_InsertRegisterLogMov 'MODIFICAR',
												@pTable,
												@report_id,
												@short_description,
												@modify_date,
												@modify_user