CREATE PROCEDURE  [dabarc].[sp_TPT_UpdateRowOfTablesSSIS]	
	@plantillad_id		INT,	
	@nameSSISCreated	NVARCHAR(250),
	@nameTableCreated	NVARCHAR(250),
	@modify_user		NVARCHAR(15)
AS
BEGIN
	SET NOCOUNT ON;	
	UPDATE	t_PlantillaD
	SET		table_createssis = @nameSSISCreated,
			table_createtable = @nameTableCreated,
			modify_date = GETDATE(),
			modify_user = @modify_user
	WHERE	plantillad_id = @plantillad_id;
END
