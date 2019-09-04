

CREATE PROCEDURE [dabarc].[sp_INT_InsertListOfObjects_RegN]
	
	(
	@object_id nvarchar(10),
	@interface_id int,
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE();
	

	IF (SELECT COUNT(*) FROM dabarc.vw_Active_Objects ao 
		INNER JOIN t_InterfacesObjectsN ioN ON ao.objectid = ioN.int_IdObj AND ao.object_type = ioN.object_type
	WHERE ao.object_id = @object_id AND ioN.interface_id = @interface_id) > 0
	BEGIN
	--	RAISERROR ('Objeto ya registrado en la interfaz',16,1);
 RAISERROR (50002,16,1, '','')
		RETURN;
	END
	
	INSERT INTO  t_InterfacesObjectsN (
									  interface_id,
								      object_type,
									  table_name,
									  active,
									  last_error,
									  status, 
									  modify_date, 
									  modify_user,
									  int_IdObj)
	
			
	SELECT  
	        @interface_id,
	        ao.object_type,
		    ao.table_name,
		    'False',
		    '',
		    0,
            @modify_date,
		    @modify_user,
		    ao.objectid
	FROM    dabarc.vw_Active_Objects ao
	where ao.object_id = @object_id
	
	EXEC sp_INT_UpdateRowOfInterface_ObjectsNumberN @interface_id, @modify_user, @modify_date
	
	RETURN;
