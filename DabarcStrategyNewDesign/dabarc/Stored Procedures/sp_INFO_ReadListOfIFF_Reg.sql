CREATE PROCEDURE  [dabarc].[sp_INFO_ReadListOfIFF_Reg]  
@IsRegister VARCHAR(5), 
@table_id INT AS
BEGIN
  SET NOCOUNT ON;
  IF (@IsRegister = 0)
	BEGIN 
	  SELECT report_id AS Id
		  ,name
	  FROM dabarc.t_IFF
	  WHERE	registered = 0	and table_id = @table_id
	END
  ELSE	
	BEGIN
	  SELECT report_id AS Id
		  ,name
	  FROM dabarc.t_IFF
	  WHERE	registered = 1 and table_id = 	@table_id
	END
END;
