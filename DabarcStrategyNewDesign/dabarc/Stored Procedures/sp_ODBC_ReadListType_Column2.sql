CREATE PROCEDURE [dabarc].[sp_ODBC_ReadListType_Column2] @driver_id INT
	
AS

SELECT type_id
      ,driver_id      
      ,type_name
      ,type_valuesize
      ,type_valuescale
      ,type_valueprecision
      ,va.cDescription as [type_action]
      ,vf.cDescription as type_ActionforSize
      ,MSS_type
      ,MSS_size
      ,MSS_scale
      ,MSS_precision    
      ,MSS_ReplaceValue  
  FROM dabarc.t_ODBC_ctypes c
		INNER JOIN dabarc.vw_Cat_typeActive va ON c.type_Action = va.cKey
		INNER JOIN dabarc.vw_Cat_typeActiveForSize vf ON c.type_ActionforSize = vf.cKey
 WHERE driver_id = @driver_id
