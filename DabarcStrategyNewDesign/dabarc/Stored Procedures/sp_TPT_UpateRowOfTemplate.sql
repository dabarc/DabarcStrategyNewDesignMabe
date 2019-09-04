CREATE PROCEDURE  [dabarc].[sp_TPT_UpateRowOfTemplate]
		@plantilla_id	int,
		@plan_type		nchar(5),
		@plan_califica	bit,
		@plan_description  nvarchar (250),
		@odbc_id		int,
		@sql_server		nvarchar (60),
		@sql_database	nvarchar (30),
		@sql_esquema	nvarchar (30),
		@sql_user		nvarchar (30),
		@sql_pasword	nvarchar(30),
		@add_data		bit,
		@add_where		nvarchar(1000),		
		@modify_user	nvarchar (15),
		@instance_source nvarchar(50) = N''
AS
BEGIN 
	SET NOCOUNT ON ;
	DECLARE @ant_add_data	BIT
	DECLARE @nplantillaD_id INT

	SELECT @ant_add_data = add_data FROM t_PlantillaD WHERE plantilla_id = @plantilla_id

	IF (SELECT COUNT(*) FROM t_PlantillaH h
				INNER JOIN  t_PlantillaD d on h.plantilla_id= d.plantilla_id
				WHERE h.plantilla_id = @plantilla_id AND odbc_id <> @odbc_id) > 0
	BEGIN
		-- RAISERROR('Existen datos relacionados con la conexión origen, no pueden modificarse.', 16, 1);
		RAISERROR (50025,16, 1, '','')
		RETURN;
	END

	UPDATE  dabarc.t_PlantillaH 
		SET	    plan_description = @plan_description
			   , plan_type = @plan_type
			   , plan_califica = @plan_califica
			   , odbc_id = @odbc_id
			   , sql_server = @sql_server
			   , sql_database = @sql_database
			   , sql_esquema = @sql_esquema
			   , sql_user = @sql_user
			   , sql_pasword = @sql_pasword
			   , last_error = '¡Sin validar!'
			   , status = 0
			   , modify_date = GETDATE()
			   , add_data = @add_data
			   , add_where = CASE WHEN @add_data = 0 THEN NULL ELSE @add_where END
			   , modify_user = @modify_user
			   , instance_source = @instance_source
		WHERE plantilla_id = @plantilla_id
    -- Este proceso se ejecuta en el caso de cambio de la bandera de append  
	IF (@ant_add_data = 0 AND @add_data = 1)
	   BEGIN
			DECLARE int_plantillaD CURSOR FOR   
				SELECT	plantillad_id 
				FROM	dabarc.t_PlantillaD d
				INNER JOIN dabarc.t_PlantillaH h 
				ON d.plantilla_id = d.plantilla_id
				WHERE h.plantilla_id = @plantilla_id
	    
			OPEN int_plantillaD  
			FETCH NEXT FROM int_plantillaD INTO @nplantillaD_id  	
			WHILE @@FETCH_STATUS = 0  
				BEGIN  
					EXECUTE sp_TPT_UpdateAppendDataOfTable @nplantillaD_id, 1
					FETCH NEXT FROM int_plantillaD INTO @nplantillaD_id  
				END  
  
			CLOSE int_plantillaD  
			DEALLOCATE int_plantillaD
	   END
      
	IF (@ant_add_data = 1 AND @add_data = 0)
		BEGIN
			UPDATE d
			SET   
			d.add_data = 0, 
			d.add_table = null, 
			d.add_message = null
			FROM dabarc.t_PlantillaD d
			INNER JOIN dabarc.t_PlantillaH h 
			ON d.plantilla_id = d.plantilla_id
			WHERE h.plantilla_id = @plantilla_id
		END
 END;