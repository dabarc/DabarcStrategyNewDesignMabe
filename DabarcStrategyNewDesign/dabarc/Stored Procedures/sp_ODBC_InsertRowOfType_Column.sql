CREATE PROCEDURE [dabarc].[sp_ODBC_InsertRowOfType_Column](
	@driver_id		INT,
	@rule_name		NVARCHAR(50),
	@type_name		NVARCHAR(50),
	@type_operasize	NCHAR(5),
	@type_valuesize	INT,
	@type_operascale NCHAR(5),
	@type_valuescale INT,
	@type_operaprecision NCHAR(5),
	@type_valueprecision INT,
	@MSS_type		NVARCHAR(50),
	@MSS_size		INT,
	@MSS_scale		INT,
	@MSS_precision	INT,
	@type_copy_size BIT,
	@register_user	NVARCHAR(15)
 ) AS 
 
 	IF (@type_operasize = 'none' AND @type_operascale = 'none' AND @type_operaprecision = 'none')
	BEGIN
	 --  RAISERROR('Es necesario definir un criterio para insertar un registro de tipo de columna.', 16, 1);
	  
	  RAISERROR (50017,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	  
	  
	  
	   RETURN;
	END
	
	IF (SELECT COUNT(*) FROM dabarc.t_ODBC_type WHERE driver_id = @driver_id AND UPPER(rule_name) = UPPER(@rule_name)) > 0
	BEGIN
	 --  RAISERROR('Ya existe una regla con este nombre para este tipo de origen, es necesario uno nuevo.', 16, 1);
	   
	   RAISERROR (50068,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	   
	   
	   RETURN;
	END

	
INSERT INTO dabarc.t_ODBC_type
           (driver_id
           ,rule_name
           ,type_name
           ,type_operasize
           ,type_valuesize
           ,type_operascale
           ,type_valuescale
           ,type_operaprecision
           ,type_valueprecision
           ,MSS_type
           ,MSS_size
           ,MSS_scale
           ,MSS_precision
           ,type_copy_size
           ,create_date
           ,register_user)
     VALUES
           (@driver_id
           ,@rule_name
           ,@type_name
           ,@type_operasize
           ,@type_valuesize
           ,@type_operascale
           ,@type_valuescale
           ,@type_operaprecision
           ,@type_valueprecision
           ,@MSS_type
           ,@MSS_size
           ,@MSS_scale
           ,@MSS_precision
           ,@type_copy_size
           ,GETDATE()
           ,@register_user)
