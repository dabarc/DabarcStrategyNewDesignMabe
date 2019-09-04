 
 CREATE PROCEDURE [dabarc].[sp_RULE_DeleteSP]  @idRule     INT, 
											  @NameViewOfSP nvarchar(128),
											  @modify_user NVARCHAR(10) AS
									  

DECLARE @strError	     NVARCHAR(500)
DECLARE @strDbName		 NVARCHAR(100)
DECLARE @strSql		     VARCHAR(max)
DECLARE @intLEN		     INT
DECLARE @exec            NVARCHAR(200)
DECLARE	@dbId   	     INT
DECLARE	@tableId   	     INT
DECLARE @ruleType        NVARCHAR(3)
DECLARE @NameTableAsig   NVARCHAR(128)
DECLARE @nameTable       NVARCHAR(5)

 BEGIN TRANSACTION  Tadd                

SET @ruleType = SUBSTRING(@NameViewOfSP,1,3)

----------------------------------------------------------------------------------
  -- Obtener id de tabla y de la BD 
  ----------------------------------------------------------------------------------
     
  --   SELECT @tableId = table_id
  --   FROM vw_Active_RULE
	 --WHERE rule_id = @idRule and Type_Table = @ruleType
	 
	     IF @ruleType = 'RFF'
  BEGIN 
	  SELECT @tableId = table_id
	  FROM t_RFF
	  WHERE rule_id = @idRule
	
      SELECT @dbId = database_id
      FROM t_TFF 
      WHERE table_id = @tableId
      
      SELECT @NameTableAsig = name 
      FROM t_TFF
      WHERE table_id = @tableId
      SET @nameTable = 't_RFF'
   END
   
   IF @ruleType = 'RDM'
  BEGIN 
      SELECT @tableId = table_id
	  FROM t_RDM
	  WHERE rule_id = @idRule
	  
      SELECT @dbId = database_id
      FROM t_TDM 
      WHERE table_id = @tableId
      
      SELECT @NameTableAsig = name 
      FROM t_TDM
      WHERE table_id = @tableId
      
      SET @nameTable = 't_RDF'
      
   END
	    IF @ruleType = 'RFM'
  BEGIN 
	  DECLARE @tdmId INT

	  SELECT @tableId = table_id
	  FROM t_RFM
	  WHERE rule_id = @idRule
	  
	  SELECT @NameTableAsig = name 
      FROM t_TFM
      WHERE table_id = @tableId
	  
      SELECT @tdmId = tdm_id
      FROM t_TFM 
      WHERE table_id = @tableId
    
      SELECT @dbId = database_id
      FROM t_TDM 
      WHERE table_id = @tdmId
      
      SET @nameTable = 't_RFM'
   END
   
	SELECT @strDbName = name
	FROM vw_Active_DB 
	WHERE database_id = @dbId
	
    SET @strSql ='DROP PROCEDURE ' + 'dbo.' + @NameViewOfSP 

    DECLARE @VAR AS NVARCHAR(max) 
    
    SET @VAR = CAST(@strSql AS NVARCHAR(max))  

	SELECT @exec = QUOTENAME(@strDbName) + '.sys.sp_executesql'

	EXEC   @exec @VAR 
	
	SET @NameViewOfSP = @NameViewOfSP + 'Vi'
 	EXEC dabarc.sp_RULE_CreateProcedureOfView @dbId,@NameViewOfSP,@NameTableAsig, @strError OUTPUT 
 	 
	IF (LEN(RTRIM(@strError)) > 0)
   BEGIN          
     RAISERROR( @strError, 16, 1);
     ROLLBACK TRANSACTION Tadd
	 RETURN 0;
   END
   IF @ruleType = 'RFF'
 	 UPDATE t_RFF
 	 SET modify_user = @modify_user,
 		 modify_date = GETDATE()
 		 WHERE rule_id = @idRule
 	 IF @ruleType = 'RDM'
 	 UPDATE t_RDM
 	 SET modify_user = @modify_user,
 		 modify_date = GETDATE()
 		 WHERE rule_id = @idRule
 		 IF @ruleType = 'RFM'
 	 UPDATE t_RFM
 	 SET modify_user = @modify_user,
 		 modify_date = GETDATE()
 		 WHERE rule_id = @idRule
 	COMMIT TRANSACTION Tadd
