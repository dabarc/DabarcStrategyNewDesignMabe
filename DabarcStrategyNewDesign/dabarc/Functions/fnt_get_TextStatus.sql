
 CREATE FUNCTION [dabarc].[fnt_get_TextStatus]( @int_status CHAR(1) )
 RETURNS VARCHAR(15) AS
 BEGIN
 
  DECLARE  @RETURN_STRING VARCHAR(15)
 
   SELECT   @RETURN_STRING  = CASE 
				WHEN RTRIM(@int_status) = 4 THEN 'Con error'
				WHEN RTRIM(@int_status) = 3 THEN 'Correcto'
				WHEN RTRIM(@int_status) = 2 THEN 'Ejecución'
				WHEN RTRIM(@int_status) = 1 THEN 'Programado' ELSE 'En espera'
			END
  RETURN @RETURN_STRING			
			
 END
