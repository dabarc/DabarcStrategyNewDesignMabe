-- =============================================
-- Author:		Mario Rosas
-- Create date: 20/04/2017
-- Description:	Valida si el informe se ejecuto correctamente, si no fue asi, 
-- se ejecuta por fuera del servicio
-- =============================================
CREATE PROCEDURE [dbo].[sp_Valida_Informes]
  @OP int,	
  @report_name varchar(max)
AS
BEGIN
  IF @OP=1
  BEGIN
	INSERT INTO dbo.tbl_valida_Informe (NB_Error, FechaError) VALUES(@report_name, GETDATE())
    SELECT 'ok' AS respuesta;	  
  END
END
