
--EXEC [dabarc].[sp_ODBC_InsertRowOfType_Column2] 3,'VARCHAR2',40,0,0,'STD','TT','NVARCHAR',0,0,0,'ADMIN',''

CREATE PROCEDURE [dabarc].[sp_ODBC_InsertRowOfType_Column2](
	@driver_id			INT,
	@type_name			NVARCHAR(50),	
	@type_valuesize		INT,
	@type_valuescale	INT,
	@type_valueprecision INT,
	@type_Action		 NVARCHAR(50),
	@type_Actionforsize	NVARCHAR(15),
	@MSS_type			NVARCHAR(50),
	@MSS_size			INT,
	@MSS_scale			INT,
	@MSS_precision		INT,
	@register_user		NVARCHAR(15),
	@MSS_ReplaceValue	NVARCHAR(65)
 ) AS 
 

	
	IF (SELECT COUNT(*) FROM [dabarc].[t_ODBC_ctypes] WHERE driver_id = @driver_id AND UPPER(type_name) = UPPER(@type_name)) > 0
	BEGIN
	--   RAISERROR('Ya existe una regla con este nombre para este tipo de origen, es necesario uno nuevo.', 16, 1);
	   RAISERROR (50068,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	   
	   
	   
	   
	   
	   RETURN;
	END

	
INSERT INTO [dabarc].t_ODBC_ctypes
           (driver_id
           ,type_name
           ,type_valuesize
           ,type_valuescale
           ,type_valueprecision
           ,type_Action
           ,type_ActionforSize
           ,MSS_type
           ,MSS_size
           ,MSS_scale
           ,MSS_precision
           ,create_date
           ,register_user
           ,MSS_ReplaceValue)
     VALUES
           (@driver_id
           ,@type_name
           ,@type_valuesize
           ,@type_valuescale
           ,@type_valueprecision
           ,@type_Action
           ,@type_Actionforsize
           ,@MSS_type
           ,@MSS_size
           ,@MSS_scale
           ,@MSS_precision
           ,GETDATE()
           ,@register_user
           ,@MSS_ReplaceValue)
