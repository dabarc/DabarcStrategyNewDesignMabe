CREATE PROCEDURE  [dabarc].[sp_asp_Treeview_Base_Sel] @Node_Clave AS CHAR(5), 
													 @User_NameShort NVARCHAR(10),
													 @Language CHAR(5) AS

	DECLARE @SQL		 VARCHAR(400)
	DECLARE @LanguageExt VARCHAR(5)
	DECLARE @RESULTSQL	 NVARCHAR(MAX)
	
	------------------------------------------------------------------------------------
	-- Crear tabla para permisos
	------------------------------------------------------------------------------------		
	
	CREATE TABLE #IdPermissions(Id_Treview INT)

	------------------------------------------------------------------------------------
	-- Obtenemos una extension para el campo name del treeview para establecer el lenguaje
	------------------------------------------------------------------------------------		
	SET @LanguageExt = ''
	SELECT @LanguageExt = ISNULL(lenguaje_trew,'') FROM dabarc.asp_Language WHERE lng_id = @Language
	
	------------------------------------------------------------------------------------
	-- Consulta 1 - se colocan los primeros niveles por omisión
	------------------------------------------------------------------------------------		

	IF (SELECT COUNT(*) FROM dabarc.t_User WHERE User_NameShort = @User_NameShort AND Is_Admin = 1) > 0
	BEGIN	
		-- Si es administrador por default tiene todos los permisos
		INSERT INTO #IdPermissions
		SELECT	Id_TreeviewB 
		FROM	dabarc.asp_InfoTreeview_Base 
	END
	ELSE
	BEGIN
		--Buscamos los nodos principales
		INSERT INTO #IdPermissions
		SELECT	Id_TreeviewB 
		FROM	dabarc.asp_InfoTreeview_Base 
		WHERE	Node_Level <= 1
		
		--insertamos los permisos asignados al rol
		INSERT INTO #IdPermissions
		SELECT distinct rp.Id_TreeViewB	
		FROM dabarc.t_User u
			INNER JOIN dabarc.t_User_Permissions up		ON u.Id_User = up.Id_User 
			INNER JOIN dabarc.t_User_Roles r			ON up.Id_Rol = r.Id_Rol AND r.Active = 1
			INNER JOIN dabarc.t_User_RolPermissions rp	ON r.Id_Rol = rp.Id_Rol AND rp.Active = 1
		WHERE u.User_NameShort = @User_NameShort

	END

	------------------------------------------------------------------------------------
	-- Consulta 2
	------------------------------------------------------------------------------------
	
	
	SET @RESULTSQL = 'SELECT DISTINCT Node_Clave, [Node_Name] = Node_Name' + @LanguageExt
	SET @RESULTSQL = @RESULTSQL + ', Node_Level, Node_Parent, Node_Url, Node_Imagen , Node_Position'
	SET @RESULTSQL = @RESULTSQL + ' FROM dabarc.asp_InfoTreeview_Base b'
	SET @RESULTSQL = @RESULTSQL + ' INNER JOIN #IdPermissions		p ON b.Id_TreeviewB = p.Id_Treview'
    SET @RESULTSQL = @RESULTSQL + ' WHERE Node_Clave LIKE ''' + RTRIM(@Node_Clave) + '%''  OR Node_Clave = ''_DAB'''
    SET @RESULTSQL = @RESULTSQL + ' ORDER BY node_position,node_clave,Node_level'
	

	EXEC(@RESULTSQL)
			  
			  
	--SET @SQL = 'SELECT  Node_Clave
	--			  , Node_Name
	--			  , Node_Level
	--			  , Node_Parent
	--			  , Node_Url
	--			  , Node_Imagen
	--			  , Node_Position
	--		  FROM dabarc.asp_InfoTreeview_Base
	--		  WHERE Node_Clave LIKE  ''' + RTRIM(@Clave) + '%''  OR Node_Clave = ''_DAB''
	--		  ORDER BY node_position,node_clave,Node_level'
			  
	--EXECUTE(@SQL)
