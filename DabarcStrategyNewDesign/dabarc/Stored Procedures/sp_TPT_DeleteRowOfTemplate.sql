CREATE PROCEDURE [dabarc].[sp_TPT_DeleteRowOfTemplate]
	@plantilla_id int
AS
BEGIN
	SET NOCOUNT ON ;
	--Se borran las dependencia de detalle
	DELETE FROM dabarc.t_PlantillaD WHERE plantilla_id = @plantilla_id;	
	DELETE FROM dabarc.t_PlantillaH WHERE plantilla_id = @plantilla_id;
END;
