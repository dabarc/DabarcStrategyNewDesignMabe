CREATE PROCEDURE [dabarc].[sp_ODBC_ReadListTypeODBC] 
	
AS

SELECT driver_id
      ,driver_dbms
      ,driver_text
      ,create_date
      ,driver_cva
  FROM dabarc.t_ODBC_driver
