---execute [dabarc].[sp_RULE_ReadRowOfRule] 'RFF',34

 CREATE PROCEDURE  [dabarc].[sp_RULE_ReadRowOfRule] @typeOfRule VARCHAR(5), @rule_id INT AS

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------

 IF (RTRIM(@typeOfRule) = 'RFF')
 BEGIN 
		
	SELECT rule_id AS RuleId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,report_type AS ReportType
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
		  ,affected_rows AS AffectedRows
	FROM	dabarc.t_RFF
	WHERE rule_id = @rule_id
 END
 
IF (RTRIM(@typeOfRule) = 'RDM')	
 BEGIN
	SELECT rule_id AS RuleId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,report_type AS ReportType
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
		  ,affected_rows AS AffectedRows		  
	FROM	dabarc.t_RDM
	WHERE rule_id = @rule_id
 END


IF (RTRIM(@typeOfRule) = 'RFM')	
 BEGIN
	SELECT rule_id AS RuleId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,report_type AS ReportType
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
		  ,affected_rows AS AffectedRows
	FROM	dabarc.t_RFM
	WHERE rule_id = @rule_id	
 END

IF (RTRIM(@typeOfRule) = 'RRF')	
 BEGIN
	SELECT rule_id AS RuleId
		  ,name AS Name
		  ,description AS Description
		  ,short_description AS ShortDescription
		  ,active AS Active
		  ,priority AS Priority
		  ,report_type AS ReportType
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
		  ,affected_rows AS AffectedRows
	FROM  t_RRF
	WHERE rule_id = @rule_id	
 END
