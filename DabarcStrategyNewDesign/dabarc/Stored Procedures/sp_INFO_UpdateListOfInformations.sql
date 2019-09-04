CREATE PROCEDURE  [dabarc].[sp_INFO_UpdateListOfInformations] 
(
	    @typeOfInformation	varchar(5), 		
	    @Object_id			int,
		@active				bit,
		@priority			int,	
		@description		nvarchar(256),
		@short_description	nvarchar(50),	
		@report_export	    nvarchar(10),
		@report_type        nvarchar(14),
		@modify_user		nvarchar(15)
	)
	
AS
 

	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()
	
	----------------------------------------------------------------------------------------------------------------------------------
	--- Validar
	----------------------------------------------------------------------------------------------------------------------------------

	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	 --  RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
	  RAISERROR (50051,16,1, '','')
	   RETURN;
	END
	
	
 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

	IF (@typeOfInformation = 'IFF')
	BEGIN 	
		  UPDATE t_IFF
		  SET	description		= @description, 
				short_description = @short_description,
				report_type = @report_type, 
				report_export	= @report_export,
				active			= @active, 
				priority		= @priority, 
				modify_date		= @modify_date, 
				modify_user		= @modify_user
		  WHERE report_id       = @Object_id
	END
	
	IF (@typeOfInformation = 'IDM')
	BEGIN
		  UPDATE t_IDM 
		  SET	description		= @description, 
				short_description = @short_description, 
				report_type = @report_type,
				report_export	= @report_export,
				active			= @active, 
				priority		= @priority, 
				modify_date		= @modify_date, 
				modify_user		= @modify_user
		  WHERE report_id       = @Object_id
	END
 
 
 	
	IF (@typeOfInformation = 'IFM')
	BEGIN
		  UPDATE t_IFM 
		  SET	description		= @description, 
				short_description = @short_description, 
				report_type = @report_type,
				report_export	= @report_export,
				active			= @active, 
				priority		= @priority, 
				modify_date		= @modify_date, 
				modify_user		= @modify_user
		  WHERE report_id       = @Object_id
	END

  ----------------------------------------------------------------------------
  -- Log de Movimientos
  ----------------------------------------------------------------------------
	DECLARE @pTable NCHAR(10)
	SET @pTable = 't_' + @typeOfInformation
	EXECUTE dabarc.sp_log_InsertRegisterLogMov 'MODIFICAR',
												@pTable,
												@Object_id,
												@short_description,
												@modify_date,
												@modify_user