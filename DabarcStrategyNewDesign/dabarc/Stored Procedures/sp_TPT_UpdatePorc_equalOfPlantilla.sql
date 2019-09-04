CREATE PROCEDURE [dabarc].[sp_TPT_UpdatePorc_equalOfPlantilla] 
@plantilla_id INT AS 
BEGIN
SET NOCOUNT ON;
	UPDATE e
	SET e.porc_equal = (CASE WHEN count_total = 0 THEN 0 ELSE (count_sum/count_total) END * 100)
	FROM dabarc.t_PlantillaH e 
		INNER JOIN (SELECT	plantilla_id,
							SUM(porc_equal) AS count_sum,
							CAST((COUNT(porc_equal) * 100) AS DECIMAL(8,2)) AS count_total
					FROM  dabarc.t_PlantillaD WHERE plantilla_id = @plantilla_id AND active = 1
					GROUP BY plantilla_id) i ON e.plantilla_id = i.plantilla_id
	WHERE e.plantilla_id = @plantilla_id
END
