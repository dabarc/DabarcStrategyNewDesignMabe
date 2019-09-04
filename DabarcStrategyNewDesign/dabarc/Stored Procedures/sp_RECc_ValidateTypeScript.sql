
CREATE PROCEDURE [dabarc].[sp_RECc_ValidateTypeScript] @script_id INT AS
 
 DECLARE @TYPE               NCHAR(3)
DECLARE @iDetMenorCab  INT
DECLARE @iDetMayorPie  INT
DECLARE @iNoCab        INT
DECLARE @iNoPie        INT
DECLARE @strmessage    NVARCHAR(1500)
 
 
 SELECT @TYPE = s.script_structure
 FROM t_recording_script s
 WHERE      script_id = @script_id
 
 
SET @iDetMenorCab = 0
SET @iDetMayorPie = 0
SET @iNoCab = 0
SET @iNoPie = 0
SET @strmessage = ''


       IF (RTRIM(@TYPE) = 'DET')
      BEGIN  
         IF (SELECT COUNT(*) FROM t_recording_screen WHERE script_id = @script_id AND RTRIM(screen_typestruc) <> 'DET') > 0         
            -- RAISERROR('Todas las pantallas deben estar definidas como tipo detalle, lo cual no se cumple.', 16, 1);
             RAISERROR (50060,16,1, '','')
            RETURN;
      END
 
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------------------------------------------------------------
   SELECT @iDetMenorCab = COUNT(*)
   FROM   t_recording_screen ex
            INNER JOIN ( SELECT screen_position
                              FROM   t_recording_screen
                              WHERE script_id = @script_id
                              AND RTRIM(screen_typestruc) = 'CAB') it ON ex.screen_position <= it.screen_position
   WHERE script_id = @script_id
   AND RTRIM(screen_typestruc) = 'DET'
 
  
   SELECT @iDetMayorPie = COUNT(*)
   FROM   t_recording_screen ex
            INNER JOIN ( SELECT screen_position
                              FROM   t_recording_screen
                              WHERE script_id = @script_id
                              AND RTRIM(screen_typestruc) = 'PIE') it ON ex.screen_position >= it.screen_position
   WHERE script_id = @script_id
   AND RTRIM(screen_typestruc) = 'DET'
  
   SELECT @iNoCab = COUNT(screen_position) FROM   t_recording_screen WHERE script_id = @script_id AND RTRIM(screen_typestruc) = 'CAB'
   SELECT @iNoPie = COUNT(screen_position) FROM   t_recording_screen WHERE script_id = @script_id AND RTRIM(screen_typestruc) = 'PIE'
                            
-------------------------------------------------------------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------------------------------------------------------------
 
 
  IF (RTRIM(@TYPE) = 'MDE')
  BEGIN
   IF (@iNoPie) > 0
         SET @strmessage = @strmessage + ' \n  Existe un elemento definido como PIE, es necesario cambiarlo.';
 
   IF (@iNoCab) = 0
         SET @strmessage = @strmessage + ' \n  No existe definición de una pantalla como CABECERO.';
 
   IF (@iDetMenorCab > 0)      
         SET @strmessage = @strmessage + ' \n Hay DETALLES en una posición anterior a los CABECEROS.';
  END
  ELSE
  BEGIN
 
    IF (@iNoCab) = 0
         SET @strmessage = @strmessage + ' \n  No existe definición de una pantalla como CABECERO.';
 
      IF (@iNoPie) = 0
         SET @strmessage = @strmessage + ' \n  No existe definición de una pantalla como PIE.';
 
      IF (@iDetMenorCab > 0)    
         SET @strmessage = @strmessage + ' \n Hay una pantalla DETALLE en una posición anterior a los CABECEROS.';
 
   IF (@iDetMayorPie > 0)      
         SET @strmessage = @strmessage + ' \n Hay una pantalla DETALLE en una posición superior a un PIE.';
 
  END
  
   IF (RTRIM(@strmessage) <> '')
   BEGIN
    SET @strmessage = SUBSTRING(@strmessage,4,LEN(@strmessage))
    --  RAISERROR(@strmessage, 16, 1);
      RAISERROR (50083,16,1, '','')
      RETURN;
   END
  
   RETURN;
