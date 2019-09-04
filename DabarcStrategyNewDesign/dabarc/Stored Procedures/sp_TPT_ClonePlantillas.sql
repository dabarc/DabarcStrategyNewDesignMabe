 
CREATE PROCEDURE [dabarc].[sp_TPT_ClonePlantillas] 
	@Plantilla_Id INT,
	@Plt_name     VARCHAR(60),
	@odbc_Id      INT,
	@Server       VARCHAR(60),
	@DBName       VARCHAR(60),
	@User         VARCHAR(60),
	@PWD          VARCHAR(60),
	@WhereRep     VARCHAR(60),
	@WhereNue     VARCHAR(60),
	@modify_user  NVARCHAR(15)
AS
BEGIN
SET NOCOUNT ON;
	DECLARE @nPlantilla_Id  INT
	DECLARE @Plantillad_Id INT
	DECLARE @nPlantillad_Id INT                                                      
                                                            
	------------------------------------------------------------------------------------------------------------------------------
	--- El SP replica la estructura de una plantilla sin aplicar la validación de origenes y destinos
	--- Permite remplazar la conexión Origen
	--- Permite remplazar la conexión Destino
	--- Permite remplazar el where en caso se tenga
	------------------------------------------------------------------------------------------------------------------------------
 
  ------------------------------------------------------------------------------------------------------------------------------
  --- Validamos que los elementos no existan
  ------------------------------------------------------------------------------------------------------------------------------
  IF (SELECT COUNT(*) FROM dabarc.t_PlantillaH WHERE plantilla_id = @Plantilla_Id) = 0
  BEGIN
      SELECT 'No se encontró la plantilla.' as ErrorMessage;
      RETURN;
 END
  
 IF (SELECT COUNT(*) FROM dabarc.t_PlantillaH WHERE RTRIM(UPPER(plan_name)) = RTRIM(UPPER(@Plt_name)) ) > 0
  BEGIN
      SELECT 'Ya existe una plantilla con este nombre.' as ErrorMessage;
      RETURN;
  END

 BEGIN TRANSACTION;
 BEGIN TRY
 INSERT INTO t_PlantillaH
           (plan_name
           ,plan_description
           ,odbc_id
           ,sql_server
           ,sql_database
           ,sql_esquema
           ,sql_user
           ,sql_pasword
           ,create_date
           ,register_user
           ,modify_date
           ,modify_user
           ,last_error
           ,status
           ,porc_equal
           ,execute_user
           ,execute_date
           ,execute_time
           ,affected_row
           ,plan_type
           ,plan_califica)
SELECT @Plt_name
      ,plan_description
      ,@odbc_Id
      ,@Server
      ,@DBName
      ,sql_esquema
      ,@User
      ,@PWD
      ,create_date
      ,register_user
      ,GETDATE()
      ,@modify_user
      ,''
      ,status
      ,porc_equal
      ,null
      ,execute_date
      ,null
      ,0
      ,plan_type
      ,plan_califica
  FROM t_PlantillaH
  WHERE plantilla_id =  @Plantilla_Id
 
  SET @nPlantilla_Id = @@IDENTITY
 
  ------------------------------------------------------------------------------------------------------------------------
  --- ciclar para crear detalles y columnas
  ------------------------------------------------------------------------------------------------------------------------
 
     
      DECLARE detl_cursor CURSOR FOR
  
      SELECT plantillad_id
      FROM   dabarc.t_PlantillaD
      WHERE  plantilla_id = @plantilla_id
     
     
      OPEN detl_cursor
      FETCH NEXT FROM detl_cursor
      INTO @Plantillad_Id
      WHILE @@FETCH_STATUS = 0
      BEGIN
 
            --- Insertarmos la tabla de detalles
            INSERT INTO dabarc.t_PlantillaD
           (plantilla_id
           ,table_name
           ,create_date
           ,register_user
           ,active
           ,porc_equal
           ,modify_date
           ,modify_user
           ,table_esquema
           ,table_createssis
           ,table_createtable
           ,table_nametdm
           ,table_where)
            SELECT @nPlantilla_Id
              ,table_name
              ,GETDATE()
              ,@modify_user
              ,active
              ,porc_equal
              ,GETDATE()
              ,@modify_user
              ,table_esquema
              ,table_createssis
              ,table_createtable
              ,table_nametdm
              ,CASE WHEN RTRIM(@WhereRep) <> '' THEN REPLACE(table_where,@WhereRep,@WhereNue) ELSE table_where END
        FROM dabarc.t_PlantillaD
        WHERE plantillad_id = @Plantillad_Id
 
        SET @nPlantillad_Id = @@IDENTITY
 
       
        INSERT INTO dabarc.t_PlantillaC
           (plantillad_id
           ,pl_NameCol
           ,pl_typeOdbc
           ,pl_size
           ,pl_precision
           ,create_date
           ,register_user
           ,active
           ,last_status
           ,pl_isnull
           ,pl_sType
           ,pl_sSize
           ,Pl_sPrecision
           ,pl_sNull
           ,modify_date
           ,modify_user
           ,pl_scale
           ,pl_sScale
           ,pl_sRType
           ,pl_ReplaceValue)
          
           SELECT  @nplantillad_id
                          ,pl_NameCol
                          ,pl_typeOdbc
                          ,pl_size
                          ,pl_precision
                          ,GETDATE()
                          ,@modify_user
                          ,active
                          ,last_status
                          ,pl_isnull
                          ,pl_sType
                          ,pl_sSize
                          ,Pl_sPrecision
                          ,pl_sNull
                          ,GETDATE()                        
                          ,@modify_user
                          ,pl_scale
                          ,pl_sScale
                          ,pl_sRType
                          ,pl_ReplaceValue
                  FROM dabarc.t_PlantillaC
                  WHERE plantillad_id = @Plantillad_Id
 
 
       
        
            --- Insertamos los datos de la columnas
          
            FETCH NEXT FROM detl_cursor
            INTO @Plantillad_Id
         
      END
      CLOSE detl_cursor;
      DEALLOCATE detl_cursor;
   
   END TRY
   BEGIN CATCH
  
       --SELECT
       --  ERROR_NUMBER() AS ErrorNumber
       -- ,ERROR_SEVERITY() AS ErrorSeverity
       -- ,ERROR_STATE() AS ErrorState
       -- ,ERROR_PROCEDURE() AS ErrorProcedure
       -- ,ERROR_LINE() AS ErrorLine
       -- ,ERROR_MESSAGE() AS ErrorMessage;
 
       SELECT ERROR_MESSAGE() as ErrorMessage;
 
       
     IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
       
     
    CLOSE detl_cursor;
      DEALLOCATE detl_cursor;
   END CATCH;
 
    IF @@TRANCOUNT > 0
      COMMIT TRANSACTION;
     
    SELECT CAST(@nPlantilla_Id AS CHAR(10))
END;
