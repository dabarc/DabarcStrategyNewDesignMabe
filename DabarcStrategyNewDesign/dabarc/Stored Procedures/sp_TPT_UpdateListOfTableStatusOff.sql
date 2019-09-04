CREATE PROCEDURE [dabarc].[sp_TPT_UpdateListOfTableStatusOff] 
@PlantillaD_Id INT AS
 BEGIN 
      SET NOCOUNT ON;
	  UPDATE dabarc.t_PlantillaC
	  SET	 last_status = 'Eliminar'
	  WHERE  plantillad_id = @PlantillaD_Id;
END
