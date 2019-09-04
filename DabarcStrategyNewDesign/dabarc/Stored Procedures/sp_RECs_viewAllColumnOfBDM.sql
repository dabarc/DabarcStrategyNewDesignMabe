CREATE PROCEDURE [dabarc].[sp_RECs_viewAllColumnOfBDM]
@intDB_Id INT,
@strName_View NVARCHAR(200)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @strSQL    NVARCHAR(400),
		 @strDBName NVARCHAR(30)
 ------------------------------------------------------------------------------------------------
 -- Creamos tabla de retorno
 ------------------------------------------------------------------------------------------------
	CREATE TABLE #TempRetun(NameCOL NVARCHAR(100))
 ------------------------------------------------------------------------------------------------
 -- Generamos al consulta
 ------------------------------------------------------------------------------------------------

   IF (RTRIM(@strName_View) <> '')
   BEGIN
	  SELECT @strDBName = RTRIM(m.name) FROM t_BDM m WHERE m.database_id = @intDB_Id

	  SET @strSQL = 'SELECT c.name FROM ' + RTRIM(@strDBName) + '.sys.all_columns c
		INNER JOIN ' + RTRIM(@strDBName) + '.sys.all_views v ON c.object_id = v.object_id
	  WHERE UPPER(RTRIM(v.name)) = UPPER(RTRIM(''' + RTRIM(@strName_View) + '''))'

	  PRINT @strSQL

	  INSERT INTO #TempRetun EXEC(@strSQL)
  END
  ------------------------------------------------------------------------------------------------
 -- Regresamos los datos
 ------------------------------------------------------------------------------------------------
	SELECT NameCOL
	FROM   #TempRetun
	ORDER BY NameCOL ASC;
END;
