 CREATE PROCEDURE [dabarc].[sp_RULE_CreateProcedureOfView]
@idDB     INT,
@NameViewOfSP nvarchar(128),
@NameTableAsig nvarchar(128),
@outputError nvarchar(500) OUTPUT
AS
BEGIN
SET NOCOUNT ON;
 DECLARE @intLEN		 INT
 DECLARE @strCol		 NVARCHAR(100)
 DECLARE @strCols		 NVARCHAR(max)
 DECLARE @typeAction	 CHAR(3)
 DECLARE @DbAndView		 NVARCHAR(100)
 DECLARE @strListCol	 NVARCHAR(500)
 DECLARE @strDbName		 NVARCHAR(100)
 DECLARE @strSql		 NVARCHAR(max)
 DECLARE @strSqlExec	 NVARCHAR(max)
 DECLARE @strError		 NVARCHAR(500)
 DECLARE @exec           NVARCHAR(200)
 SET @strCols = ''
 ---------------------------------------------------------------------------------------------------------
 -- Temporal Table
 ---------------------------------------------------------------------------------------------------------
   CREATE TABLE #tmpCols(NameCol NVARCHAR(100), NameValue NVARCHAR(200))
 ---------------------------------------------------------------------------------------------------------
 -- Identificar tipo de Acción
 ---------------------------------------------------------------------------------------------------------
   SET @intLEN = LEN(@NameViewOfSP)
   SET @typeAction = UPPER(SUBSTRING(@NameViewOfSP,@intLEN-4,3))
   IF (SUBSTRING(@NameViewOfSP,1,3) = 'RFF')
   BEGIN
     SELECT @DbAndView = 'dbo.' + SUBSTRING(@NameViewOfSP,1, @intLEN - 2),
			@strDbName = RTRIM(name)
     FROM	t_BDF
     WHERE  database_id = @idDB
   END
   ELSE
   BEGIN
     SELECT @DbAndView = 'dbo.' + SUBSTRING(@NameViewOfSP,1, @intLEN - 2),
			@strDbName = RTRIM(name)
     FROM	t_BDM
     WHERE  database_id = @idDB
   END
   SET @strSql ='CREATE PROCEDURE ' + @DbAndView + ' AS '
   BEGIN TRY
 ---------------------------------------------------------------------------------------------------------
 -- Identificar tipo de Regla
 ---------------------------------------------------------------------------------------------------------
  IF (RTRIM(@typeAction) = 'ELI')
  BEGIN
    SET @strSql =CAST(@strSql AS NVARCHAR(max)) + CAST(' DELETE FROM ' + @NameViewOfSP AS NVARCHAR(max))
  END
  ELSE
  BEGIN
 ---------------------------------------------------------------------------------------------------------
 -- Obtenemos los nombres de la columnas
 ---------------------------------------------------------------------------------------------------------
  SET @strListCol = '  SELECT RTRIM(a.name) as colname, null
			FROM ' + RTRIM(@strDbName) + '.dbo.syscolumns a, '  + RTRIM(@strDbName) +  '.dbo.systypes b
				WHERE a.id = object_id(N''' + RTRIM(@strDbName) + '.dbo.' + RTRIM(@NameViewOfSP) + ''')
				AND a.xtype=b.xtype
				AND b.name <> ''sysname'''
--PRINT @strListCol
--EXECUTE(@strListCol)
  INSERT INTO #tmpCols EXECUTE(@strListCol)
 ---------------------------------------------------------------------------------------------------------
 -- Buscamos las columnas
 ---------------------------------------------------------------------------------------------------------
   IF (RTRIM(@typeAction) = 'INS')
   BEGIN
     UPDATE #tmpCols SET NameCol = '[' + NameCol + ']'
     UPDATE #tmpCols SET NameValue = NameCol
   END
   ELSE
   BEGIN
     UPDATE #tmpCols SET NameValue = '[' + (SUBSTRING(NameCol,1,LEN(NameCol) -6) + ']=[' + NameCol) + ']' WHERE UPPER(NameCol) like '%[_]NUEVO'
     UPDATE #tmpCols SET NameValue = '[' + (SUBSTRING(NameCol,1,LEN(NameCol) -5) + ']=[' + NameCol) + ']' WHERE UPPER(NameCol) like '%NUEVO' AND NameValue IS NULL
     UPDATE #tmpCols SET NameValue = '[' + (SUBSTRING(NameCol,1,LEN(NameCol) -4) + ']=[' + NameCol) + ']' WHERE UPPER(NameCol) like '%[_]NEW'
     UPDATE #tmpCols SET NameValue = '[' + (SUBSTRING(NameCol,1,LEN(NameCol) -3) + ']=[' + NameCol) + ']' WHERE UPPER(NameCol) like '%NEW' AND NameValue IS NULL
   END
   --SELECT * FROM #tmpCols
   --RETURN
 ---------------------------------------------------------------------------------------------------------
 -- Buscamos los valores
 ---------------------------------------------------------------------------------------------------------
		DECLARE Field_Cursor CURSOR FOR
			SELECT	NameValue
			FROM	#tmpCols
			WHERE	NameValue IS NOT NULL
		OPEN Field_Cursor
		FETCH NEXT FROM Field_Cursor
		INTO @strCol
		WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @strCols = CAST(@strCols AS NVARCHAR(max)) + @strCol + ','
			FETCH NEXT FROM Field_Cursor INTO @strCol
			END
		CLOSE Field_Cursor
		DEALLOCATE Field_Cursor
   SET @strCols = SUBSTRING(RTRIM(@strCols),1,LEN(RTRIM(@strCols))-1)
   IF (RTRIM(@typeAction) = 'INS')
   BEGIN
	 SET @strSql  = CAST(@strSql AS NVARCHAR(max)) + CAST('INSERT INTO ' + @NameTableAsig + ' (' + @strCols + ') SELECT ' + @strCols + ' FROM ' + @NameViewOfSP AS NVARCHAR(max))
	-- SET @strSql2 = ' SELECT ' + @strCols + ' FROM ' + @NameViewOfSP
   END
   ELSE
   BEGIN
     SET @strSql  = @strSql + 'UPDATE  ' + @NameViewOfSP + ' SET  ' + @strCols
    -- SET @strSql2 = ''
   END
  END
	--SELECT @strSql
    DECLARE @VAR AS NVARCHAR(max) --- Linea necesaria
    SET @VAR = CAST(@strSql AS NVARCHAR(max))  -- Linea necesaria
	SELECT @exec = QUOTENAME(@strDbName) + '.sys.sp_executesql'
	EXEC   @exec @VAR
 END TRY
BEGIN CATCH
       SELECT  @outputError = ERROR_MESSAGE() ;
       SET     @outputError = 'Error al crear SP de la Vista <' + RTRIM(@NameViewOfSP) + '>' + ' ' + @outputError
END CATCH
END
