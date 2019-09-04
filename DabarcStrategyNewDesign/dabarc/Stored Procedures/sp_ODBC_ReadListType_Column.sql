CREATE PROCEDURE [dabarc].[sp_ODBC_ReadListType_Column] @driver_id INT
	
AS

SELECT type_id
      ,driver_id
      ,rule_name
      ,type_name
      ,CASE WHEN type_operasize <> 'none' THEN RTRIM(type_operasize) + ' ' + CAST(type_valuesize AS CHAR(10)) ELSE NULL END oSize
      ,CASE WHEN type_operascale <> 'none' THEN RTRIM(type_operascale) + ' ' + CAST(type_valuescale AS CHAR(10)) ELSE NULL END oScale
      ,CASE WHEN type_operaprecision <> 'none' THEN RTRIM(type_operaprecision) + ' ' + CAST(type_valueprecision AS CHAR(10)) ELSE NULL END oPrecision
      ,MSS_type
      ,MSS_size
      ,MSS_scale
      ,MSS_precision
      ,type_copy_size as MSS_Copy
  FROM dabarc.t_ODBC_type
 WHERE driver_id = @driver_id
