CREATE PROCEDURE  [dabarc].[sp_TPT_UpdateListOfTablesCol]	

	@plantillac_id	INT,
	@active			BIT,
	@pl_sType		NVARCHAR(60),
	@pl_sSize		INT,
	@pl_sPrecision	INT,
	@pl_sScale		INT,
	@pl_sNull		BIT,
	@modify_user	NVARCHAR(15)
	AS
BEGIN
SET NOCOUNT ON;
	DECLARE @plantillad_id	INT
	DECLARE @platilla_id	INT

	UPDATE	dabarc.t_PlantillaC
	SET		active = @active,
			pl_sType = @pl_sType,
			pl_sSize = @pl_sSize,
			Pl_sPrecision = @pl_sPrecision,
			pl_sScale = @pl_sScale,
			pl_sNull = @pl_sNull,
			modify_date = GETDATE(),
			modify_user = @modify_user
	WHERE	plantillac_id = @plantillac_id
	
	
	
	 --Actualizamos el porcentaje de columnas modificadas
	 SELECT @plantillad_id = c.plantillad_id ,
			@platilla_id = d.plantilla_id 
	 FROM	dabarc.t_PlantillaC c
			INNER JOIN dabarc.t_PlantillaD d ON c.plantillad_id = d.plantillad_id
	 WHERE	c.plantillac_id = @plantillac_id
	 
	 EXECUTE dabarc.sp_TPT_UpdatePorc_equalOfTable @plantillad_id	 
	 EXECUTE dabarc.sp_TPT_UpdatePorc_equalOfPlantilla @platilla_id
	 END
