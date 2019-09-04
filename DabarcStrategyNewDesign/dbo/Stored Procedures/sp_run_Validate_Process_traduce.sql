

CREATE PROCEDURE [dbo].[sp_run_Validate_Process_traduce]
AS
BEGIN



DECLARE @STRSQL_RETURN NVARCHAR (500)
SET    @STRSQL_RETURN	= UPPER(RTRIM(@STRSQL_RETURN))

 SET @STRSQL_RETURN =  ' ELEMENTO QUE BLOQUEA:'
 
						+ ' Proceso:' 
						+ ' Fecha: '
						+ ' Usuario:' 
						+ ' Estado: '
						+ ' Tabla: ' 
						+ ' Nombre elemento:' 
						+ ' Tipo: ' 
						+ ' Estado elemento: ' 
						+ ' Ultimo Proceso:'
						+ ' Inicial:'
						
						






  EXECUTE dabarc.sp_run_Validate_Process_traduction  @strSql_return OUTPUT 
		 
		 SELECT @STRSQL_RETURN
		 
		 END
