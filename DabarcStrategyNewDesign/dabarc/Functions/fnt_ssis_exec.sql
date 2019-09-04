
CREATE FUNCTION [dabarc].[fnt_ssis_exec] (@exec AS INT,@bien AS INT,@error AS INT )
RETURNS NCHAR(100)
AS 
   BEGIN

     DECLARE @ssis_total AS VARCHAR(20)
     DECLARE @ssis_bien AS VARCHAR(20)
     DECLARE @ssis_mal AS VARCHAR(20)

     SELECT @ssis_total = REPLACE('SSIS EJECUTADOS <0> ',dbo.EXTRACT_NUM('SSIS EJECUTADOS <0> ') ,@exec);
     SELECT @ssis_bien = REPLACE(' CORRECTOS <0> ',dbo.EXTRACT_NUM(' CORRECTOS <0> ') ,@bien);
     SELECT @ssis_mal = REPLACE(' CON ERROR <0> ',dbo.EXTRACT_NUM(' CON ERROR <0> ') ,@error);
     RETURN (@ssis_total + @ssis_bien + @ssis_mal) 

END
