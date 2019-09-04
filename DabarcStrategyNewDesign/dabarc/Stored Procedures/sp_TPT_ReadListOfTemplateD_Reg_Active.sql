CREATE PROCEDURE  [dabarc].[sp_TPT_ReadListOfTemplateD_Reg_Active]  
@plantilla_id INT  
AS
BEGIN
    SET NOCOUNT ON;

	SELECT	plantillad_id as ObjectId, 
			table_name as TableName,
			table_esquema as TableScheme,
			table_name  as Description
	FROM	t_PlantillaD 
	WHERE plantilla_id = @plantilla_id AND active = 1
    ORDER BY table_name;
END
