CREATE PROCEDURE  [dabarc].[sp_RULE_ReadListOfRules] 
@typeOfRule VARCHAR(5), 
@table_id INT,
@info_id INT AS
 
 -----------------------------------------------------------------------
 -- Valores de paso 
 -- @@TypeOfRule = TFF / TDM / TFM
 -----------------------------------------------------------------------
 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(	ObjectId		INT NULL,
							Name			nvarchar(128) NULL,
							Description		nvarchar(256) NULL,
							ShortDescription nvarchar(50) NULL,
							Active			bit NULL,
							Priority		int NULL,
							ReportType       char(14) NULL,
							ReportExport	char(10) NULL,
							ExecuteRules	bit NULL,
							ExecuteReports bit NULL,
							ExecuteSsis	bit NULL,
						    ExecuteUser	nvarchar(15) NULL,
							ExecuteDate	datetime NULL,
							ExecuteTime	nvarchar(25) NULL,
							AffectedRows	int NULL,
							Status		nvarchar(15) NULL,
							LastError		nvarchar(256)NULL);
 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------
 IF (RTRIM(@typeOfRule) = 'RFF')
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT rule_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,NULL
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows
		  ,status
		  ,last_error
	  FROM t_RFF
	  WHERE	registered = 1	and table_id = @table_id
	END
 IF (RTRIM(@typeOfRule) = 'RDM')
	BEGIN
	INSERT INTO #t_Objeto	
	SELECT rule_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,NULL
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows	
		  ,status
		  ,last_error	  
	  FROM t_RDM
	  WHERE	registered = 1	and table_id = @table_id
	END
 IF (RTRIM(@typeOfRule) = 'RFM')
	BEGIN
	INSERT INTO #t_Objeto	
	SELECT rule_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,NULL
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows
		  ,status
		  ,last_error		  
	  FROM t_RFM
	  WHERE	registered = 1	and table_id = @table_id
	END
 IF (RTRIM(@typeOfRule) = 'RRF')
	BEGIN
	INSERT INTO #t_Objeto	
	SELECT rule_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,NULL
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows
		  ,status
		  ,last_error	  
	  FROM t_RRF
	  WHERE	registered = 1	and info_id = @info_id
	END
 
  UPDATE #t_Objeto
  SET    Status = dabarc.fnt_get_TextStatus(Status);
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
	 SELECT	  ObjectId
			  ,Name
			  ,Description
			  ,ShortDescription
			  ,Active
			  ,Priority
			  ,ReportType
			  ,ReportExport
			  ,ExecuteRules
			  ,ExecuteReports
			  ,ExecuteSsis
			  ,ExecuteUser
			  ,ExecuteDate
			  ,ExecuteTime
			  ,AffectedRows
			  ,Status
			  ,LastError
	 FROM #t_Objeto
	 ORDER BY Active DESC, [Priority] ASC
