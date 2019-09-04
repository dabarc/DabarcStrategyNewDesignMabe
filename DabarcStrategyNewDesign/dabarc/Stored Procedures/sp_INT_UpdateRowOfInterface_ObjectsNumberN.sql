
CREATE PROCEDURE [dabarc].[sp_INT_UpdateRowOfInterface_ObjectsNumberN]
		
	@interface_id int,
	@modify_user nvarchar(15),
	@modify_date datetime,
	@value int = 1
		
AS
		
	UPDATE t_InterfacesN
	SET objects_number = objects_number + @value, modify_date = @modify_date, modify_user = @modify_user 
	WHERE (interface_id = @interface_id)

	
	RETURN
