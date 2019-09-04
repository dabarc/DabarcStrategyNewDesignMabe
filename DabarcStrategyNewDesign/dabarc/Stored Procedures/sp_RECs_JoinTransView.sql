 
 
CREATE PROCEDURE [dabarc].[sp_RECs_JoinTransView] @intScript_id INT AS

DECLARE  @strSQL NVARCHAR(400),
			@strDBName NVARCHAR(30),
			@name_view NVARCHAR(200)

------------------------------------------------------------------------------------------
-- Validamos la transacción tenga asignada la vista y los campos
------------------------------------------------------------------------------------------
SELECT  @strDBName = RTRIM(LTRIM(b.name)),
@name_view = RTRIM(LTRIM(s.script_sourceviewh))
FROM t_recording_script s
INNER JOIN t_recording_team m ON s.team_id = m.team_id
INNER JOIN t_BDM b ON m.team_dbid = b.database_id
WHERE script_id = @intScript_id

IF (RTRIM(LTRIM(@name_view)) = '')
BEGIN
RAISERROR (50045,16,1, '','')
RETURN;
END

------------------------------------------------------------------------------------------
-- Tabla temporal para contener los cmpos de la vista
------------------------------------------------------------------------------------------

CREATE TABLE #tmpFields(NameCOL NVARCHAR(100))

SET @strSQL = 'SELECT c.name FROM ' + RTRIM(LTRIM(@strDBName)) + '.sys.all_columns c
INNER JOIN ' + RTRIM(LTRIM(@strDBName)) + '.sys.all_views v ON c.object_id = v.object_id
WHERE UPPER(RTRIM(LTRIM(v.name))) = UPPER(''' + RTRIM(LTRIM(@name_view)) + ''')'

INSERT INTO #tmpFields EXEC(@strSQL)
------------------------------------------------------------------------------------------
-- Asignamos en automatico lo elementos similares
------------------------------------------------------------------------------------------
	UPDATE s
	SET s.field_fieldview = t.NameCOL, fecha_modifica=GETDATE()
	FROM t_recording_fields s
	INNER JOIN t_recording_screen c ON s.screen_id = c.screen_id
	INNER JOIN #tmpFields t ON RTRIM(LTRIM(s.field_SAPname)) = t.NameCOL
	WHERE RTRIM(s.field_typeentry) <> 'CONS'
	AND c.script_id = @intScript_id
 
  
 --   SELECT *
      --FROM      t_recording_fields s
      --    INNER JOIN t_recording_screen c ON s.screen_id = c.screen_id
      --    INNER JOIN #tmpFields t            ON RTRIM(SUBSTRING(s.field_SAPname,CHARINDEX('-',s.field_SAPname,0) + 1,LEN(s.field_SAPname))) = t.NameCOL
      --WHERE     RTRIM(s.field_typeentry) <> 'CONS'
      --          AND c.script_id = @intScript_id
 
 --   SELECT * FROM #tmpFields   
 
   
 --   SELECT *
      --FROM      t_recording_fields