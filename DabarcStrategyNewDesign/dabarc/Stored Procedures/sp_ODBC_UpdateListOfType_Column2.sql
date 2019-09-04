CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateListOfType_Column2]
	(
		@type_id		INT,
		@MSS_Type		NVARCHAR(50),
		@MSS_Size		INT,
		@MSS_Scale		INT,
		@MSS_Precision	INT
		--@MSS_ReplaceValue	NVARCHAR(50)
		--@modify_user	NVARCHAR(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	--If (@MSS_Copy = 1)
	--BEGIN
	--	SET @MSS_size = 0
	--	SET @MSS_scale = 0
	--	SET @MSS_precision = 0
	--END 
	
	
	UPDATE dabarc.t_ODBC_ctypes
	SET MSS_type = @MSS_Type,
		MSS_size = @MSS_Size,
		MSS_scale = @MSS_Scale,
		MSS_precision = @MSS_Precision
		--MSS_ReplaceValue = @MSS_ReplaceValue
	WHERE type_id  = 	@type_id
