CREATE PROCEDURE [dabarc].[sp_ODBC_ReadRowType_Column] @type_id INT AS

SELECT type_id
      ,driver_id
      ,rule_name
      ,type_name
      ,type_operasize
      ,type_valuesize
      ,type_operascale
      ,type_valuescale
      ,type_operaprecision
      ,type_valueprecision
      ,MSS_type
      ,MSS_size
      ,MSS_scale
      ,MSS_precision
      ,type_copy_size
      ,create_date
      ,register_user
  FROM dabarc.t_ODBC_type
  WHERE type_id = @type_id
