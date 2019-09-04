CREATE PROCEDURE  [dabarc].[sp_TPT_UpdateListOfTemplateD] 

	@plantillad_id	int,
	@active			bit,
	@table_nametdm	nvarchar(50),
	@table_where	nvarchar(300),
	@modify_user	nvarchar(15)

	
AS
BEGIN
SET NOCOUNT ON;

 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	DECLARE @modify_date datetime
	DECLARE @platilla_id int

	SET @modify_date = GETDATE()
	

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------
 
  UPDATE t_PlantillaD
  SET	active			 = @active,
		table_nametdm	 = @table_nametdm,
		table_where		 = @table_where,
		modify_date		 = @modify_date, 
		modify_user		 = @modify_user
  WHERE plantillad_id	 = @plantillad_id

 --Calculamos los porcentajes de la tablas
 SELECT  @platilla_id = plantilla_id FROM t_PlantillaD WHERE plantillad_id = @plantillad_id
 EXECUTE sp_TPT_UpdatePorc_equalOfPlantilla @platilla_id
 END
