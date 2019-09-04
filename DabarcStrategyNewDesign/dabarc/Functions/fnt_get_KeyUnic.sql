CREATE FUNCTION [dabarc].[fnt_get_KeyUnic]
()
RETURNS 
@TBL_INTER TABLE  (VALOR_INTER VARCHAR(20))
AS 
BEGIN
  DECLARE @var_Return	VARCHAR(15)
  DECLARE @date			DATETIME = GETDATE()

	-- Tomamos los datos asta los segundo
  SET @var_Return = CONVERT(VARCHAR(8),@date,14)
  SET @var_Return = REPLACE(@var_Return,':','')  
  SET @var_Return = CONVERT(VARCHAR(12),GETDATE(),112) + @var_Return
   
  WHILE (SELECT COUNT(*) FROM dabarc.t_Sql_process_executeH WHERE RTRIM(Path_hKey) = RTRIM(@var_Return)) > 0
  BEGIN
		SET @date = DATEADD(second,10,@date)
		SET @var_Return = CONVERT(VARCHAR(8),@date,14)
		SET @var_Return = REPLACE(@var_Return,':','')  
		SET @var_Return = CONVERT(VARCHAR(12),GETDATE(),112) + @var_Return
		
  END
  
  INSERT INTO @TBL_INTER 
  VALUES(@var_Return)  
  
  RETURN
END
