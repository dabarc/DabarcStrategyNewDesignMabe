
CREATE PROCEDURE [dabarc].[sp_INT_UpdateListOfObjects_NoRegN]
	(
	@object_id int,
	@interface_id int,
	@modify_user nvarchar(15)
	)
AS
	DECLARE @modify_date datetime
	DECLARE @value int
	
	SET @modify_date = GETDATE()
	
   BEGIN TRY		
		DELETE FROM t_InterfacesObjectsN
		WHERE        (object_id = @object_id)
		
		SET @value = -@@ROWCOUNT
		
		EXEC dabarc.sp_INT_UpdateRowOfInterface_ObjectsNumberN @interface_id, @modify_user, @modify_date, @value
   END TRY
   BEGIN CATCH
		UPDATE t_InterfacesObjectsN SET status = 2, last_error =  'No se puede eliminar el objeto.'
		WHERE (object_id = @object_id)
   END CATCH
RETURN
