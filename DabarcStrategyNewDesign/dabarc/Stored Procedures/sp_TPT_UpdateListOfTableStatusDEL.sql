CREATE PROCEDURE [dabarc].[sp_TPT_UpdateListOfTableStatusDEL] @PlantillaD_Id 
INT AS
BEGIN -- Aquellos campos que no se actualizaron se eliminan por que indican que no existen
 SET NOCOUNT ON;
	  DELETE 
	  FROM	t_PlantillaC 
	  WHERE UPPER(RTRIM(last_status)) = 'ELIMINAR' 
	  AND	plantillad_id = @PlantillaD_Id
END
