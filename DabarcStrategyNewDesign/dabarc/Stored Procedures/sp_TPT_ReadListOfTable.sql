CREATE PROCEDURE  [dabarc].[sp_TPT_ReadListOfTable] 
@plantillaD_id INT 
AS
BEGIN
	 SET NOCOUNT ON;
	 SELECT plantillad_id,
			o.odbc_id,
			h.plan_name AS tbl_plantilla,
			o.odbc_database AS tbl_DB,
			d.table_name AS tbl_name,
			d.table_esquema AS tbl_esquema,
			d.table_nametdm
	 FROM	t_PlantillaD AS d
			INNER JOIN t_PlantillaH AS h ON d.plantilla_id = h.plantilla_id
			INNER JOIN t_ODBC AS o ON h.odbc_id = o.odbc_id
	 WHERE  plantillad_id = @plantillaD_id;
END
