CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateListOfTables]
	
	(
	@TypeOfTBL varchar(5),
	@Table_id int,
	@active bit,
	@priority int,	
	@description nvarchar(256),
	@short_description nvarchar(50),
	@execute_rules bit,
	@execute_reports bit,
	@execute_ssis bit,
	@modify_user nvarchar(15)
	)
	
AS
	DECLARE @modify_date datetime

	SET @modify_date = GETDATE()

	IF (@active = 1 AND (@priority = 0 OR RTRIM(@short_description) = ''))
	BEGIN
	 --  RAISERROR('No se puede activar un registro con prioridad "0" y sin descripción corta', 16, 1);
	  RAISERROR (50051,16,1, '','')
	   RETURN;
	END
	
	 IF (RTRIM(@TypeOfTBL) = 'TFF')
	 BEGIN 	
		UPDATE       t_TFF
		SET					description = @description, 
							short_description = @short_description, 
							active = @active, 
							priority = @priority, 
							modify_date = @modify_date, 
							modify_user = @modify_user, 
							execute_rules = @execute_rules, 
							execute_reports = @execute_reports, 
							execute_ssis = @execute_ssis
		WHERE        (table_id = @Table_id)
	END
	
	 IF (RTRIM(@TypeOfTBL) = 'TDM')
	 BEGIN
	 UPDATE       t_TDM
		SET                description = @description,
						   short_description = @short_description, 
						   active = @active, 
						   priority = @priority, 
						   modify_date = @modify_date, 
						   modify_user = @modify_user, 
						   execute_rules = @execute_rules, 
						   execute_reports = @execute_reports, 
						   execute_ssis = @execute_ssis
		WHERE        (table_id = @Table_id)		
	 END
	 
	 IF (RTRIM(@TypeOfTBL) = 'TFM')
	 BEGIN
	 UPDATE       t_TFM 
		SET                description = @description,
						   short_description = @short_description, 
						   active = @active, 
						   priority = @priority, 
						   modify_date = @modify_date, 
						   modify_user = @modify_user, 
						   execute_rules = @execute_rules, 
						   execute_reports = @execute_reports, 
						   execute_ssis = @execute_ssis
		WHERE        (table_id = @Table_id)		
	 END
	 
	 
	 select * from t_SSIS
