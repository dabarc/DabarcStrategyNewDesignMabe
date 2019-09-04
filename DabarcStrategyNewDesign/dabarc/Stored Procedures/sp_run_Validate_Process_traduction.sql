 
CREATE PROCEDURE [dabarc].[sp_run_Validate_Process_traduction] @srtPar1 AS NVARCHAR(MAX) OUTPUT
 AS 

 

DECLARE @strLANGUAGE NCHAR(50)

SELECT @strLANGUAGE	= @@LANGUAGE
SET    @strLANGUAGE	= UPPER(RTRIM(@strLANGUAGE))


 --If (@strLANGUAGE='ESPAÑOL')
 
 If (@strLANGUAGE='US_ENGLISH')
 
 BEGIN
 
   SET @srtPar1 = REPLACE(@srtpar1,'ULTIMO PROCESO:','LAST PROCESS:')
   SET @srtPar1 = REPLACE(@srtpar1,'ELEMENTO QUE BLOQUEA:','BLOCKING ELEMENT:')
   SET @srtPar1 = REPLACE(@srtpar1,'PROCESO:','PROCESS:')
   SET @srtPar1 = REPLACE(@srtPar1,'FECHA:','DATE:')
   SET @srtPar1 = REPLACE(@srtpar1,'USUARIO:','USER:')
   SET @srtPar1 = REPLACE(@srtpar1,'ESTADO:','STATUS:')
   SET @srtPar1 = REPLACE(@srtpar1,'TABLA:','TABLE:')
   SET @srtPar1 = REPLACE(@srtpar1,'NOMBRE ELEMENTO:','ELEMENT NAME:')
   SET @srtPar1 = REPLACE(@srtpar1,'TIPO:','TYPE:')
   SET @srtPar1 = REPLACE(@srtpar1,'ESTADO ELEMENTO:','STATE ELEMENT:')
   SET @srtPar1 = REPLACE(@srtpar1,'INICIAL:','INITIAL:') 
 
   
   END
