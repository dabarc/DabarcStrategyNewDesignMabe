CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateRowOfType_Column](
	@type_id INT,
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
	--   RAISERROR('Es necesario definir un criterio para insertar un registro de tipo de columna.', 16, 1);
	  RAISERROR (50017,
    16, -- Severity.
    1, -- State.
    '',
    '') -- Second substitution argument.
	  
	  
	   RETURN;
	END
	

	UPDATE	dabarc.t_ODBC_type
	SET		type_name = @type_name,
			type_operasize = @type_operasize,
			type_operascale =@type_operascale,
			type_operaprecision = @type_operaprecision, 
			type_valuesize = @type_valuesize,
			type_valuescale = @type_valuescale,
			type_valueprecision =@type_valueprecision ,
			MSS_type = @MSS_type,
			MSS_size = @MSS_size,
			MSS_scale = @MSS_scale,
			MSS_precision = @MSS_precision,
			type_copy_size = @type_copy_size
	WHERE	type_id =   @type_id
