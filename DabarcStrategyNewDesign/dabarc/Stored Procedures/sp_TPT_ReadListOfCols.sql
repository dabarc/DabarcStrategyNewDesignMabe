CREATE PROCEDURE   [dabarc].[sp_TPT_ReadListOfCols] @plantillad_id INT AS
BEGIN 
 SET NOCOUNT ON ;
 SELECT plantillac_id
      ,plantillad_id
      ,pl_NameCol
      ,pl_typeOdbc
      ,pl_size
      ,pl_precision
      ,create_date
      ,register_user
      ,active
      ,last_status
      ,pl_isnull
      ,pl_sType
      ,pl_sSize
      ,Pl_sPrecision
      ,pl_sNull
      ,modify_date
      ,modify_user
      ,pl_scale
      ,pl_sScale
      ,pl_sRType
      ,pl_ReplaceValue
  FROM  dabarc. t_PlantillaC
  WHERE plantillad_id = @plantillad_id
  ORDER BY plantillac_id ASC;
END
