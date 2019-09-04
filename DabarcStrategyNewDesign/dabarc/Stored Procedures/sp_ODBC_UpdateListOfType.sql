CREATE PROCEDURE [dabarc].[sp_ODBC_UpdateListOfType]
	
	(
  @driver_id INT,
  @driver_text NVARCHAR(50),     
  @driver_cva NCHAR(10)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	
	
	UPDATE	dabarc.t_ODBC_driver
	SET		driver_text = @driver_text,
			driver_cva = @driver_cva
	WHERE 	driver_id	= @driver_id				
				 
	RETURN
