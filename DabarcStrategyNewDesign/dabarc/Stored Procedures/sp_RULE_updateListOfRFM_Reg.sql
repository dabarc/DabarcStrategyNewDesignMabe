CREATE PROCEDURE  [dabarc].[sp_RULE_updateListOfRFM_Reg] 	
	(	
	@table_id	int,
	@rule_id	int,
	@registered int,
	@NameViewOfSP  nvarchar(128),
	@register_user nvarchar(15)
	)
	
AS
 

	DECLARE @register_date datetime
	DECLARE @strError	   NVARCHAR(500)
	DECLARE	@dbId   	   INT
	DECLARE @NameTableAsig NVARCHAR(128)
	
	
  ----------------------------------------------------------------------------------
  -- Obtener id de la BD y nombre de la TABLA
  ----------------------------------------------------------------------------------

SELECT @dbId = database_id
FROM t_TDM 
WHERE table_id = (SELECT tdm_id
 FROM t_TFM WHERE table_id = @table_id)

SELECT @NameTableAsig = name 
FROM t_TFM 
WHERE table_id = @table_id

 ----------------------------------------------------------------------------------
  -- Validar acción  SP o VI
  ----------------------------------------------------------------------------------
  IF (@rule_id = 0) -- VISTA
  BEGIN
  
  
  ----------------------------------------------------------------------------------
  -- = VISTA entonces crea el SP
  ----------------------------------------------------------------------------------
  EXEC dabarc.sp_RULE_CreateProcedureOfView @dbId,@NameViewOfSP,@NameTableAsig, @strError OUTPUT 
  
  IF (LEN(RTRIM(@strError)) > 0)
   BEGIN          
     RAISERROR( @strError, 16, 1);
	 RETURN 0;
   END

   
    INSERT INTO t_RFM(name, create_date, table_id, status, report_type, registered) 
    VALUES(SUBSTRING(@NameViewOfSP,1,LEN(@NameViewOfSP)-2),getdate(),@table_id,0,'', 1)

  ----------------------------------------------------------------------------------
  -- = NUEVA REGLA entonces insertar en RFM con status 1
  ---------------------------------------------------------------------------------
 END
 ELSE
 BEGIN

	SET @register_date = GETDATE()

	UPDATE       dabarc.t_RFM  
	SET			 registered		= @registered,								
				 register_date	= @register_date,
				 register_user	= @register_user				
	WHERE        (table_id		= @table_id 
				 AND rule_id	= @rule_id)


   
END
 EXECUTE [dabarc].[sp_RULE_updateListOfNumber_Reg] 'TFM',@table_id, @register_user
   --IF (@registered = 1)
   --BEGIN
   --   DECLARE @name VARCHAR(50)
   --   SELECT @name = name FROM dabarc.t_RFM WHERE table_id = @table_id AND rule_id = @rule_id
   --   EXEC sp_INT_InsertAutoRegInterface @name, @rule_id
   --END
