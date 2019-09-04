CREATE PROCEDURE [dabarc].[sp_ODBC_ReadRowTypeODBC] 
	(
	  @driver_id INT
	)
	
AS

SELECT driver_id
      ,driver_dbms
      ,driver_text
      ,create_date
      ,driver_cva
  FROM dabarc.t_ODBC_driver
 WHERE driver_id = @driver_id
