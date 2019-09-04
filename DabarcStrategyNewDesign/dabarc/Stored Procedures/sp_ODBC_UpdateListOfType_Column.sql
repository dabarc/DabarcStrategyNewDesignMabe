CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateListOfType_Column]
	(
		@type_id	INT,
		@MSS_Type	NVARCHAR(50),
		@MSS_Size	INT,
		@MSS_Scale	INT,
		@MSS_Precision	INT,
		@MSS_Copy BIT--,
		--@modify_user	NVARCHAR(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	If (@MSS_Copy = 1)
	BEGIN
		SET @MSS_Size = 0
		SET @MSS_Scale = 0
		SET @MSS_Precision = 0
	END 
	
	
	UPDATE dabarc.t_ODBC_type 
	SET MSS_type = @MSS_Type,
		MSS_size = @MSS_Size,
		MSS_scale = @MSS_Scale,
		MSS_precision = @MSS_Precision,
		type_copy_size = @MSS_Copy
	WHERE type_id  = 	@type_id
