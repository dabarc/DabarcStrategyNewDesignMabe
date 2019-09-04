CREATE PROCEDURE [dabarc].[sp_TPT_UpdateRowOfTestTemplate]
						@object_id		int,
						@last_error		nvarchar(256),
						@status			INT,
						@modify_user	nvarchar(15)

  AS 
BEGIN 
SET NOCOUNT ON;
 -- status 0 --> sin Probar
 -- status 1 --> exito
 -- status 2 --> Error

	UPDATE dabarc.t_PlantillaH
	SET   last_error = @last_error
		 ,modify_date	= GETDATE()
		 ,status = @status
		 ,modify_user  = @modify_user
	WHERE plantilla_id = @object_id;
END
