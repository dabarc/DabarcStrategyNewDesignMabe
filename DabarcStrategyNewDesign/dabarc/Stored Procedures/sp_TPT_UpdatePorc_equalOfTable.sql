CREATE PROCEDURE [dabarc].[sp_TPT_UpdatePorc_equalOfTable] 
@plantillad_id INT 
AS 
BEGIN
	 SET NOCOUNT ON;
	 WITH i (plantillad_id,count_mod, count_total) AS
	( SELECT  plantillad_id,
							SUM(CASE WHEN RTRIM(pl_sType) <> '' AND NOT pl_sType IS NULL 
									 THEN 1 ELSE 0 END) as count_mod,
							CAST(COUNT(*) AS DECIMAL(6,2)) as count_total
					FROM	dabarc.t_PlantillaC 
					WHERE	 plantillad_id = @plantillad_id and active = 1
					GROUP BY plantillad_id
	 )

	 UPDATE d
	 SET d.porc_equal = ( CASE WHEN count_total = 0 THEN 0 ELSE (count_mod/count_total) END * 100 )
	 FROM dabarc.t_PlantillaD AS d
     INNER JOIN i
	 ON  d.plantillad_id = i.plantillad_id
	 WHERE	d.plantillad_id = @plantillad_id; 		
END;
