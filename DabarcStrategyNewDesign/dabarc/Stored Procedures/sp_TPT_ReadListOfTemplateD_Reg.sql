CREATE PROCEDURE  dabarc.sp_TPT_ReadListOfTemplateD_Reg
@plantilla_id INT  
AS
BEGIN
	SET NOCOUNT ON;
	SELECT	plantillad_id AS ObjectId, 
			table_name AS TableName,
			table_esquema AS TableScheme,
			table_name  AS 'Description'
	FROM	dabarc.t_PlantillaD 
	WHERE plantilla_id = @plantilla_id
	ORDER BY table_name ASC;
END
