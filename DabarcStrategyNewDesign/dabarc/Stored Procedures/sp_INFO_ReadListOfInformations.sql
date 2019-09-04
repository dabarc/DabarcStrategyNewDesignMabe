CREATE PROCEDURE  [dabarc].[sp_INFO_ReadListOfInformations] @typeOfInformation VARCHAR(5), @table_id INT AS
 
 
 -----------------------------------------------------------------------
 -- Valores de paso 
 -- @@TypeOfRule = TFF / TDM / TFM
 -----------------------------------------------------------------------

 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	CREATE TABLE #t_Objeto(	ObjectId		int NULL,
							Name		nvarchar(128) NULL,
							Description nvarchar(256) NULL,
							ShortDescription nvarchar(50) NULL,
							Active		bit NULL,
							Priority	int NULL,
							ReportType nvarchar(14) NULL,
							ReportExport		nvarchar(10) NULL,
							ExecuteRules	bit NULL,
							ExecuteReports bit NULL,
							ExecuteSsis	bit NULL,
							ExecuteUser	nvarchar(15) NULL,
							ExecuteDate	smalldatetime NULL,
							ExecuteTime	nvarchar(25) NULL,
							AffectedRows	int NULL,
							Status		nvarchar(15) NULL,
							LastError		nvarchar(256) NULL,
							Type            nvarchar(10) NULL);
 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

	IF (@typeOfInformation = 'IFF')
	BEGIN 
	INSERT INTO #t_Objeto		
	  SELECT report_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,report_export
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows
		  ,status
		  ,last_error
		  ,'INFO' as type
	  FROM t_IFF
	  WHERE	registered = 1	and table_id = @table_id
	END
	
	IF (@typeOfInformation = 'IDM')
	BEGIN
	INSERT INTO #t_Objeto	
	SELECT report_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,report_export
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows
		  ,status
		  ,last_error
		  ,'INFO' as type		  
	  FROM t_IDM
	  WHERE	registered = 1	and table_id = @table_id
	END
 
	IF (@typeOfInformation = 'IFM')
	BEGIN
	INSERT INTO #t_Objeto	
	SELECT report_id
		  ,name
		  ,description
		  ,short_description
		  ,active
		  ,priority
		  ,report_type
		  ,report_export
		  ,0
		  ,0
		  ,0
		  ,execute_user
		  ,execute_date
		  ,execute_time
		  ,affected_rows
		  ,status
		  ,last_error
		  ,'INFO' as type 	  
	  FROM t_IFM
	  WHERE	registered = 1	and table_id = @table_id
	END
 
  UPDATE #t_Objeto
  SET    Status = dabarc.fnt_get_TextStatus(Status)
    
 -----------------------------------------------------------------------
 -- Retorno de Valores
 -----------------------------------------------------------------------
 
	 SELECT	   ObjectId
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
			  ,type			  		  
	 FROM #t_Objeto
	 ORDER BY active DESC, priority ASC