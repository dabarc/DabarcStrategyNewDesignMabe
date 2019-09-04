CREATE PROCEDURE [dabarc].[sp_INT_DeleteRowOfInterfaceN]
	@interface_id int
AS
   BEGIN TRY		
		DELETE FROM dabarc.t_InterfacesN
		WHERE interface_id = @interface_id
   END TRY
   BEGIN CATCH
		UPDATE dabarc.t_InterfacesN 
		SET status = 2, 
		last_error =  'No se puede eliminar la interfaz porque tiene objetos registrados.'
		WHERE interface_id = @interface_id
		--  RAISERROR('No se puede eliminar la interfaz porque tiene objetos registrados.', 16, 1); 
        RAISERROR (50055,16,1, '','')
   END CATCH
RETURN
