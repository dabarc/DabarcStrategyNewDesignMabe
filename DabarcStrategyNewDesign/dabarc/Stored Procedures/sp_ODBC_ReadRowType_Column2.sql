CREATE PROCEDURE [dabarc].[sp_ODBC_ReadRowType_Column2] @type_id INT AS

SELECT type_id
      ,driver_id
      ,type_name
      ,type_valuesize      
      ,type_valuescale
      ,type_valueprecision
      ,type_Action
      ,type_ActionforSize
      ,MSS_type
      ,MSS_size
      ,MSS_scale
      ,MSS_precision
      ,MSS_ReplaceValue  
      ,create_date
      ,register_user
  FROM dabarc.t_ODBC_ctypes
  WHERE type_id = @type_id
