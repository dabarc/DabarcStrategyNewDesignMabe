CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateRowOfType_Column2](
	@type_id			INT,
	@type_valuesize		INT,
	@type_valuescale	INT,
	@type_valueprecision INT,
	@type_Action		 NVARCHAR(50),	
	@MSS_type			 NVARCHAR(50),
	@type_ActionforSize			 NVARCHAR(15),
	@MSS_size			INT,
	@MSS_scale			INT,
	@MSS_precision		INT,
	@register_user		NVARCHAR(15),
	@MSS_ReplaceValue	NVARCHAR(65)
 ) AS 
 

	UPDATE	dabarc.t_ODBC_ctypes
	SET		type_valuesize	= @type_valuesize,
			type_valuescale = @type_valuescale,
			type_valueprecision = @type_valueprecision ,
			type_Action		= @type_Action,
			type_ActionforSize = @type_ActionforSize,
			MSS_type	= @MSS_type,
			MSS_size	= @MSS_size,
			MSS_scale	= @MSS_scale,
			MSS_precision = @MSS_precision,
			MSS_ReplaceValue = @MSS_ReplaceValue
	WHERE	type_id =   @type_id
