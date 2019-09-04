CREATE PROCEDURE [dabarc].[sp_dbs_Views_Sel]
 (
 @database_id int,
 @report_name nvarchar(128),
 @table_type  nchar(3),
 @SEGME_type  nchar(5),
 @SEGME_Value nvarchar(200) -- fieldOrder
 )
 
AS
 
 DECLARE @db_name nvarchar(128),
   @sqlstr  nvarchar(300),
   @sqlstrv nvarchar(300),
   @SEGME_IntValue INT,
   @SQLVALIDA varchar(500)
   
  
 ----------------------------------------------------------------------------------------------------------------
 --- Tabla de Resultado 
 ----------------------------------------------------------------------------------------------------------------
 
 CREATE TABLE #tmpResult(Result INT)
 declare @val int
 declare @t_val table (val INT)
 
 ----------------------------------------------------------------------------------------------------------------  
   
   
 
 -- Buscamos el nombre de la base de datos 
 IF (UPPER(RTRIM(@table_type)) ='IFF')
    SELECT @db_name = RTRIM(f.name) FROM t_BDF f WHERE f.database_id = @database_id
 ELSE
    SELECT @db_name = RTRIM(m.name) FROM t_BDM m WHERE m.database_id = @database_id
 
 -- Comenzamos la consulta  
 SET @sqlstr = 'SELECT * FROM ' + RTRIM(@db_name) + '.dbo.' +  RTRIM(@report_name)

 --IF not exists(select * from dbo.tbl_valida_Informe 
 --               where id_database=@database_id and NB_Reporte=@report_name)
 --  Begin
 --    set @SQLVALIDA='SELECT count(*) FROM ' + RTRIM(@db_name) + '.dbo.' +  RTRIM(@report_name)
 --    insert into @t_val exec(@SQLVALIDA)
 --    Select @val=val from @t_val
 --    insert into dbo.tbl_valida_Informe(id_database,NB_Reporte, Num_Campos_SP) 
 --    values(@database_id,@report_name, @val)
 --  END
 
 BEGIN TRY
 
  IF (UPPER(RTRIM(@SEGME_type)) = 'XCANT')
  BEGIN
  
   SET @SEGME_IntValue = CAST(@SEGME_Value AS INT)
  
   SET @sqlstrv = 'SELECT COUNT(*) / ' + CAST(@SEGME_IntValue AS CHAR(10))  + ' FROM ' + RTRIM(@db_name) + '.dbo.' +  RTRIM(@report_name)
   
   INSERT INTO #tmpResult EXECUTE(@sqlstrv)
    
   IF (SELECT COUNT(*) FROM #tmpResult WHERE Result > 20) > 0
   BEGIN
    SET @sqlstrv = 'La separación por ' + @SEGME_Value + ' registros genera más de 20 archivos, es necesario cambiar el criterio.'
  --  RAISERROR(@sqlstrv, 16, 1);
   RAISERROR (50074,16,1, @SEGME_Value,'')
  
    RETURN
   END
   
  END

  IF (UPPER(RTRIM(@SEGME_type)) = 'XCAMP')
  BEGIN
      SET @sqlstrv = 'SELECT COUNT(*) FROM (SELECT ' + RTRIM(@SEGME_Value) + ' FROM ' + RTRIM(@db_name) + '.dbo.' +  RTRIM(@report_name) + ' GROUP BY ' + RTRIM(@SEGME_Value) + ') AS TABLE1'

   INSERT INTO #tmpResult EXECUTE(@sqlstrv)
  
   IF (SELECT COUNT(*) FROM #tmpResult WHERE Result > 40) > 0
   BEGIN
    SET @sqlstrv = 'El campo ' + @SEGME_Value + ' tiene más de 40 elementos, no se pueden generar más de 40 archivos.'
   -- RAISERROR(@sqlstrv, 16, 1);
     RAISERROR (50073,16,1, @SEGME_Value,'')
    RETURN
   END
   
   --Evaluamos si tiene algun ordenamiento por necesario para la segmenetación
   SET @sqlstr = @sqlstr + ' ORDER BY ' + RTRIM(@SEGME_Value) + ' ASC'
   
  END
 

 
  EXEC(@sqlstr);
  drop table #tmpResult
 END TRY 
 BEGIN CATCH
  SELECT @sqlstrv = ERROR_MESSAGE();
  
  
  
  
  RAISERROR(@sqlstrv, 16, 1);
 
 
 
 
 
 END CATCH;
 RETURN
