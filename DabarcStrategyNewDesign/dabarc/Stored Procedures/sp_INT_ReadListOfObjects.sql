CREATE PROCEDURE [dabarc].[sp_INT_ReadListOfObjects]
(
	@interface_id int
)
AS


   SELECT     object_id
			,name
			,active
			,priority
			,execute_date
			,execute_time
			,execute_user
			,affected_rows
			,register_date
			,register_user
			,last_error
			,status
   FROM         t_InterfacesObjects
   WHERE interface_id = @interface_id
   ORDER BY active DESC, priority ASC
   
RETURN
