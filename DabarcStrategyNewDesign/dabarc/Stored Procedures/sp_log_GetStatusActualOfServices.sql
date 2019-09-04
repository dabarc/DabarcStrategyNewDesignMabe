CREATE PROCEDURE [dabarc].[sp_log_GetStatusActualOfServices] AS  
   
  
 -------------------------------------------------------------------------------------------------------------------  
 ---- Verificamos la diferencia entre las ejecuciónes si este es mayor a 2 minutos de la hora actual del sevidor  
 -------------------------------------------------------------------------------------------------------------------  
    DECLARE @ERROR_LICENCIA INT  
    DECLARE @ERROR_MESSAGUE NCHAR(2)  
  
 IF (SELECT COUNT(*) FROM ( SELECT TOP 1 TodayIs   
       FROM dabarc.t_LogServices   
       ORDER BY TodayIs  DESC) as x WHERE DATEDIFF(second,TodayIs,getdate()) > 40) > 0  
 BEGIN  
 RAISERROR('El servicio no se está ejecutando.' , 16, 1);  
        --RAISERROR (50011, 16,1)   
          
  RETURN;  
 END  
  
  
 SET @ERROR_LICENCIA = 0  
 SELECT @ERROR_LICENCIA = ISNULL(NumberDaySerial,0)  FROM dabarc.AspParameters  

  
 IF (@ERROR_LICENCIA > 0 and @ERROR_LICENCIA < 90)  
  BEGIN  
    
  SET @ERROR_MESSAGUE = CAST(@ERROR_LICENCIA AS NCHAR(2)) --'Servicio activo / La Licencia vence en %s días'  

  RAISERROR('Servicio activo / La Licencia vence en %s días.', 16, 1,@ERROR_MESSAGUE,'');  

  RETURN;  
 END  
  
 IF (@ERROR_LICENCIA = 0)  
  BEGIN  
  --  RAISERROR('La Licencia ha caducado', 16, 1);  
  RAISERROR (50032,16,1,'','') -- Second substitution argument.   
  RETURN;  
 END
