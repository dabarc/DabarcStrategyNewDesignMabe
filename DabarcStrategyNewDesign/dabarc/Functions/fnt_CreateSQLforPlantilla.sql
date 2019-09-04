CREATE FUNCTION [dabarc].[fnt_CreateSQLforPlantilla](@Plantillad_Id INT)
RETURNS  NVARCHAR(max)
AS 
BEGIN 
   --------------------------------------------------------------------------------------------------------
   ---- Definición de Variable
   ---- Esta función regresa una consulta para lo paquetes SSIS
   ---- Si no sea limitado la columnas o se a colocado valores de remplazo se regresa una consulta sencilla
   ---- ODBC de RDM esqumea.tabla
   ---- ODBC de MDB tabla entre parentesis
   --------------------------------------------------------------------------------------------------------

  
  DECLARE	@strSelect		 AS NVARCHAR(4000),
			@strColumn		 AS NVARCHAR(50),
			@strReplaceValue AS NVARCHAR(65),
			@strKeysCorchete	 AS NVARCHAR(50),
			@strKeysSchema	 AS NVARCHAR(50)
		
  DECLARE	@strNameTable	 AS NVARCHAR(100),
			@strSchema		 AS NVARCHAR(50),
			@strWhere		 AS NVARCHAR(500),
			@bolWithCorchete AS BIT
						
        
        SET @strKeysCorchete = 'MSS,TXT,MDB,ACCDB,XLS,'
        SET @strKeysSchema	 = 'FBIRD,TXT,MDB,ACCDB,XLS,'
        SET @strSelect		 = ''
        SET @strWhere		 = ''
        SET @strReplaceValue = ''
        SET @bolWithCorchete = 0
  
   --------------------------------------------------------------------------------------------------------
   ----  Obtenemos los datos de la tabla
   --------------------------------------------------------------------------------------------------------
      
	SELECT	@strNameTable	= RTRIM(table_name), 
			@strWhere		= CASE WHEN h.add_data = 1 AND ISNULL(RTRIM(table_where),'') = '' THEN RTRIM(h.add_where)
								   WHEN h.add_data = 1 AND ISNULL(RTRIM(table_where),'') <> '' THEN RTRIM(h.add_where) + ' AND ' + RTRIM(table_where) ELSE RTRIM(table_where) END,			
			@strSchema		=   CASE WHEN CHARINDEX(RTRIM(r.driver_cva),@strKeysSchema) > 0    THEN '' ELSE table_esquema END ,
			@bolWithCorchete  = CASE WHEN CHARINDEX(RTRIM(r.driver_cva),@strKeysCorchete) > 0  THEN  1 ELSE 0 END
	FROM	dabarc.t_PlantillaD d
			INNER JOIN dabarc.t_PlantillaH	h ON d.plantilla_id = h.plantilla_id
			INNER JOIN dabarc.t_ODBC		o ON h.odbc_id	= o.odbc_id
			INNER JOIN dabarc.t_ODBC_driver r ON o.driver_id = r.driver_id
	WHERE	plantillad_id = @Plantillad_Id

   --------------------------------------------------------------------------------------------------------
   ----  Validamos la tabla de la plantilla tiene todas la columnas seleccoinada y 
   ----  no tiene valores de replazo reliza un select sencillo
   --------------------------------------------------------------------------------------------------------
   
  IF (SELECT COUNT(*) FROM ( 
							SELECT  COUNT(active) as Total, 
									SUM(CAST(active AS INT)) as Activos, 
									SUM(CASE WHEN RTRIM(pl_ReplaceValue) = '' OR pl_ReplaceValue IS NULL THEN 0 ELSE 1 END)  as No_repleace
							FROM	dabarc.t_PlantillaC 
							WHERE	plantillad_id = @Plantillad_Id) externo WHERE Total = Activos AND No_repleace = 0) = 1 
 BEGIN
 
 	IF (@strSchema <> '')
 	BEGIN
 	   IF (@bolWithCorchete = 1)
 	      SET @strNameTable = @strSchema + '.[' + @strNameTable + ']'
 	   ELSE
 		  SET @strNameTable = @strSchema + '.' + @strNameTable  		  	    
	END


 	SET @strSelect = 'SELECT * FROM ' + @strNameTable
	
    If (@strWhere <> '')
       SET @strSelect = @strSelect + ' WHERE ' + RTRIM(@strWhere)
  
  
	RETURN @strSelect	
  
 
 END
 
  

  
   --------------------------------------------------------------------------------------------------------
   ----  Obtenemos los campos en una cadena 
   --------------------------------------------------------------------------------------------------------
  
    
 	  DECLARE Cursor_Columns CURSOR FOR 
      
      SELECT    pl_NameCol,
			    pl_ReplaceValue
      FROM  dabarc.t_PlantillaC
      WHERE plantillad_id = @Plantillad_Id AND active = 1 
      ORDER BY plantillac_id ASC
        
	  OPEN Cursor_Columns
	  FETCH NEXT FROM Cursor_Columns INTO @strColumn,@strReplaceValue
	  WHILE @@FETCH_STATUS = 0
	  BEGIN
	  
		SET @strColumn		 = RTRIM(@strColumn)
		SET @strReplaceValue = RTRIM(@strReplaceValue) 
		
		IF (@bolWithCorchete = 1)
				SET @strColumn = '[' + @strColumn + ']'
				
		IF (@strReplaceValue IS NULL OR RTRIM(@strReplaceValue) = '')		
			SET @strSelect = @strSelect + @strColumn + ','
		ELSE
		    SET @strSelect = @strSelect + @strReplaceValue + ' AS ' + @strColumn + ','

	     FETCH NEXT FROM Cursor_Columns INTO @strColumn,@strReplaceValue
	  END 
	  CLOSE Cursor_Columns;
	  DEALLOCATE Cursor_Columns;
  
   --------------------------------------------------------------------------------------------------------
   ----  Terminamos la Consulta
   --------------------------------------------------------------------------------------------------------
  --	IF (@bolWithCorchete = 1)
		--SET @strNameTable = '[' + @strNameTable + ']'

	
	IF (@strSchema <> '')
	  BEGIN
	    IF (@bolWithCorchete = 1)
	      SET @strNameTable = @strSchema + '.[' + @strNameTable + ']'
	    ELSE
		  SET @strNameTable = @strSchema + '.' + @strNameTable 	  
	   END

	SET @strSelect = SUBSTRING(@strSelect,1,LEN(@strSelect) -1)
	SET @strSelect = 'SELECT ' + @strSelect + ' FROM ' + @strNameTable
	
    If (@strWhere <> '')
       SET @strSelect = @strSelect + ' WHERE ' + RTRIM(@strWhere)
  
  
	RETURN @strSelect	
  
      -- SELECT  pl_NameCol,
			   --pl_sType,
			   --pl_sSize,
			   --Pl_sPrecision,
			   --Pl_sScale,
			   --pl_sNull,
			   --pl_ReplaceValue,
			   --@strSelect as pl_Sql
      -- FROM  dabarc.t_PlantillaC
      -- WHERE plantillad_id = @Plantillad_Id
      -- and active = 1 
      -- ORDER BY plantillac_id ASC
END
