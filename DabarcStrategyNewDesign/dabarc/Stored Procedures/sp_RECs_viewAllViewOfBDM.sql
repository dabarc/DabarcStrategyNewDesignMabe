CREATE PROCEDURE [dabarc].[sp_RECs_viewAllViewOfBDM]
@intDB_Id INT
AS
BEGIN
SET NOCOUNT ON;
  DECLARE @strSQL    NVARCHAR(200),
		  @strDBName  NVARCHAR(30)
 ------------------------------------------------------------------------------------------------
 -- Creamos tabla de retorno
 ------------------------------------------------------------------------------------------------
	CREATE TABLE #TempRetun(NameView NVARCHAR(200))
 ------------------------------------------------------------------------------------------------
 -- Generamos al consulta
 ------------------------------------------------------------------------------------------------
  SELECT @strDBName = RTRIM(m.name) FROM t_BDM m WHERE m.database_id = @intDB_Id
  --SET @strSQL = 'SELECT NAME FROM ' + RTRIM(@strDBName) + '.sys.all_views WHERE UPPER(NAME) LIKE ''REDM_' + RTRIM(SUBSTRING(@strDBName,5,LEN(@strDBName)-4))  + '%_vi'''
  SET @strSQL = 'SELECT NAME FROM ' + RTRIM(@strDBName) + '.sys.all_views WHERE UPPER(NAME) LIKE ''REDM_%_vi'''
  --SELECT @strSQL
  INSERT INTO #TempRetun EXEC(@strSQL)
 ------------------------------------------------------------------------------------------------
 -- Regresamos los datos
 ------------------------------------------------------------------------------------------------
  SELECT NameView
  FROM   #TempRetun;
END
