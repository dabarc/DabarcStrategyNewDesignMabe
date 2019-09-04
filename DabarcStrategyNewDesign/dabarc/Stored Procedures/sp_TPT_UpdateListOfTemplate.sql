CREATE PROCEDURE  [dabarc].[sp_TPT_UpdateListOfTemplate] 

	@plantilla_id int,
	@Plan_description nvarchar(256),
	@modify_user nvarchar(15)	
AS
BEGIN
SET NOCOUNT ON;
 -----------------------------------------------------------------------
 -- Tabla Interfaz de Trabajo
 -----------------------------------------------------------------------

	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()
	

 -----------------------------------------------------------------------
 -- Carga de tabla Interfaz
 -----------------------------------------------------------------------
 
  UPDATE dabarc.t_PlantillaH
  SET	plan_description = @Plan_description,
		modify_date		 = @modify_date, 
		modify_user		 = @modify_user
  WHERE plantilla_id	 = @plantilla_id
END
