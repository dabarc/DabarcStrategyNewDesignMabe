CREATE PROCEDURE  [dabarc].[sp_INFO_ReadRowOfInfo] @typeOfInformation VARCHAR(5), @report_id INT AS

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

 IF (RTRIM(@typeOfInformation) = 'IFF')
 BEGIN 
	SELECT report_id AS ReportId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,create_date AS CreateDate
		  ,register_date AS RegisterDate
		  ,execute_date AS ExecuteDate
		  ,register_user AS RegisterUser
		  ,execute_user AS ExecuteUser
		  ,execute_time AS ExecuteTime
		  ,modify_date AS ModifyDate
		  ,modify_user AS ModifyUser
		  ,registered AS Registered
		  ,last_error AS LastError
		  ,status AS Status
		  ,table_id AS TableId
		  ,IsTypeError
		  ,report_type AS ReportType		
		  ,report_export AS ReportExport
		  ,report_separator AS ReportSeparator
		  ,affected_rows AS AffectedRows
		  ,report_typeseg AS ReportTypeSeg
		  ,report_segamount AS ReportSegAmount
		  ,report_segfield AS ReportSegField
		  ,report_adddate AS ReportAddDate
		  ,report_createzip AS ReportCreateZip
	FROM	t_IFF
	WHERE report_id = @report_id
 END
 
IF (RTRIM(@typeOfInformation) = 'IDM')	
 BEGIN
	SELECT report_id AS ReportId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,create_date AS CreateDate
		  ,register_date AS RegisterDate
		  ,execute_date AS ExecuteDate
		  ,register_user AS RegisterUser
		  ,execute_user AS ExecuteUser
		  ,execute_time AS ExecuteTime
		  ,modify_date AS ModifyDate
		  ,modify_user AS ModifyUser
		  ,registered AS Registered
		  ,last_error AS LastError
		  ,status AS Status
		  ,table_id AS TableId
		  ,IsTypeError
		  ,report_type AS ReportType		
		  ,report_export AS ReportExport
		  ,report_separator AS ReportSeparator
		  ,affected_rows AS AffectedRows
		  ,report_typeseg AS ReportTypeSeg
		  ,report_segamount AS ReportSegAmount
		  ,report_segfield AS ReportSegField
		  ,report_adddate AS ReportAddDate
		  ,report_createzip AS ReportCreateZip   
	FROM	dabarc.t_IDM
	WHERE report_id = @report_id
 END


IF (RTRIM(@typeOfInformation) = 'IFM')	
 BEGIN
	SELECT report_id AS ReportId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,create_date AS CreateDate
		  ,register_date AS RegisterDate
		  ,execute_date AS ExecuteDate
		  ,register_user AS RegisterUser
		  ,execute_user AS ExecuteUser
		  ,execute_time AS ExecuteTime
		  ,modify_date AS ModifyDate
		  ,modify_user AS ModifyUser
		  ,registered AS Registered
		  ,last_error AS LastError
		  ,status AS Status
		  ,table_id AS TableId
		  ,CAST(0 AS BIT) AS IsTypeError
		  ,report_type AS ReportType		
		  ,report_export AS ReportExport
		  ,report_separator AS ReportSeparator
		  ,affected_rows AS AffectedRows
		  ,report_typeseg AS ReportTypeSeg
		  ,report_segamount AS ReportSegAmount
		  ,report_segfield AS ReportSegField
		  ,report_adddate AS ReportAddDate
		  ,report_createzip AS ReportCreateZip  
	FROM	t_IFM
	WHERE report_id = @report_id	
 END
