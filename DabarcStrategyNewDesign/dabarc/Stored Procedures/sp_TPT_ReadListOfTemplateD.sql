--EXEC [dabarc].[sp_TPT_ReadListOfTemplateD] 333
CREATE PROCEDURE  [dabarc].[sp_TPT_ReadListOfTemplateD] 
@plantilla_id INT AS
BEGIN
SET NOCOUNT ON;
 
	SELECT	plantillad_id,
			active,
			table_name,
			table_esquema,
			porc_equal,			
			table_nametdm,
			table_where,
			CASE WHEN ISNULL(add_data,0) = 0 THEN 'Agregar Datos'  ELSE 'Nueva Tabla' END  add_data,
			add_table,
			add_message
	FROM t_PlantillaD
	WHERE plantilla_id = @plantilla_id
	ORDER BY active DESC, table_name ASC
END;
