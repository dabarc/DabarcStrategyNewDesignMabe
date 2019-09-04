
 CREATE PROCEDURE [dabarc].[sp_RECf_ReadListOfFields] @strScreen_Id NVARCHAR(300) As 

 DECLARE @strSql NVARCHAR(800)
 
	IF (RTRIM(@strScreen_Id) = '') SET @strScreen_Id = '0'
 
	SET @strSql = 'SELECT field_id'
	SET @strSql = @strSql + ' ,s.screen_sapno'
	SET @strSql = @strSql + ' ,[screen_title] = c.Short_Description'
    SET @strSql = @strSql + ' ,field_SAPname'
	SET @strSql = @strSql + ' ,l.Description As Field'
    SET @strSql = @strSql + ' ,field_description'
    SET @strSql = @strSql + ' ,[field_typeentry] = CASE WHEN RTRIM(field_typeentry) = ''CONS'' THEN ''CONSTANTE'' ELSE ''ELEMENTO DATO'' END'
    SET @strSql = @strSql + ' ,field_fieldview'
    SET @strSql = @strSql + ' ,field_fieldspace'
	SET @strSql = @strSql + ' ,f.usuario_modifica'
	SET @strSql = @strSql + ' ,f.fecha_modifica'
	SET @strSql = @strSql + ' ,f.screen_id'
	SET @strSql = @strSql + ' FROM dabarc.t_recording_fields f'
    SET @strSql = @strSql + ' INNER JOIN dabarc.t_recording_screen s ON f.screen_id = s.screen_id'
    SET @strSql = @strSql + ' LEFT OUTER JOIN dabarc.t_SapCatScreen c ON RTRIM(UPPER(s.screen_sapno)) = RTRIM(UPPER(c.Code_Screen))'
    SET @strSql = @strSql + ' LEFT OUTER JOIN dabarc.vw_SapColumns  l ON RTRIM(UPPER(f.field_SAPname)) = RTRIM(UPPER(l.NameKey))'
    SET @strSql = @strSql + ' WHERE f.screen_id IN (' +  @strScreen_Id + ')'
    SET @strSql = @strSql + ' ORDER BY s.screen_position, f.field_id ASC'

    EXEC(@strSql)