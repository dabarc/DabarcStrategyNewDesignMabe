CREATE PROCEDURE  [dabarc].[sp_TPT_InsertRowOfTemplate]	
		@plan_name		nvarchar (60),
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
		@register_user  nvarchar (15),
		@instance_source nvarchar(50) = N''
AS
BEGIN
	SET NOCOUNT ON;
	IF (SELECT COUNT(*) FROM dabarc.t_PlantillaH WHERE UPPER(RTRIM(plan_name)) = UPPER(@plan_name)) > 0
	BEGIN
	 --  RAISERROR('No se insertó el registro por que ya existe uno con el mismo nombre.', 16, 1);
	  RAISERROR (50048,16,1,'','');
	  RETURN;
	END

	INSERT INTO  dabarc . t_PlantillaH 
           ( plan_name 
           , plan_type 
           , plan_califica
           , plan_description 
           , odbc_id 
           , sql_server 
           , sql_database 
           , sql_esquema 
           , sql_user 
           , sql_pasword 
           , create_date 
           , register_user 
           , last_error 
           , status
           , add_data
           , add_where
		   , instance_source)
     VALUES
           ( @plan_name
            ,@plan_type
            ,@plan_califica
            ,@plan_description
			,@odbc_id
			,@sql_server
			,@sql_database
			,@sql_esquema
			,@sql_user
			,@sql_pasword
			,GETDATE()
			,@register_user
            ,'Sin ejecutar'
            ,0
            ,@add_data
            ,@add_where
			,@instance_source);
END
