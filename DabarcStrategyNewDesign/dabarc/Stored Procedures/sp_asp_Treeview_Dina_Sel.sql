
CREATE PROCEDURE  dabarc.sp_asp_Treeview_Dina_Sel
	@Node_Clave VARCHAR(20),  
	@User_NameShort NVARCHAR(10) 
	AS

	--------------------------------------------------------------------------
	-- Idioma nodo
	--------------------------------------------------------------------------

	DECLARE @strSSIS  NVARCHAR(50)
	DECLARE @strRegla NVARCHAR(50)
	DECLARE @strInfor NVARCHAR(50)
	DECLARE @strTable NVARCHAR(50)
	DECLARE @strOrigen NVARCHAR(50)
	DECLARE @strEqui NVARCHAR(50)
	DECLARE @strEjecuta NVARCHAR(50)


	SET @strSSIS   = 'Paquetes SSIS'
	SET @strRegla  = 'Reglas'
	SET @strInfor  = 'Informes'
	SET @strTable  = 'Tablas TFM'
	SET @strOrigen = 'Origen'
	SET @strEqui   = 'Equivalencia'
	SET @strEjecuta = 'Ejecutar'

	--------------------------------------------------------------------------
	-- Clave
	--------------------------------------------------------------------------
	DECLARE @intNode_Id		AS INT
	DECLARE @intNode_Clave	AS VARCHAR(20)
	DECLARE @Position		AS INT
	DECLARE	@IsAdmin		AS BIT

	  SET @Position = charindex(':',@Node_Clave);
	  SET @intNode_Clave = @Node_Clave;
	  

	  IF (@Position > 0)
	  BEGIN
		SET @intNode_Id		= substring(@Node_Clave,1,@Position - 1);
		SET @intNode_Clave	= substring(@Node_Clave,@Position + 1, LEN(@Node_Clave));
	  END

	--------------------------------------------------------------------------
	-- Tablas temporale
	-- 1 Seguridad
	-- 2 Permisos a Objetos
	--------------------------------------------------------------------------


	 CREATE TABLE #Return(Node_Clave	VARCHAR(20),
						  Node_Name		VARCHAR(90),
						  Node_NexClave VARCHAR(20),
						  Node_Url		VARCHAR(40) NULL,
						  Node_Imagen	VARCHAR(40) NULL,
						  Node_Orden	INT DEFAULT(0))
						  
						  
	CREATE TABLE #IdPermissions(Id_Clave	INT, 
								Type_Object NVARCHAR(20))		
								
	CREATE TABLE #ListaDestino (Id_Clave	INT IDENTITY(1,1) NOT NULL, 
								Name		NVARCHAR(200))		
															
	--------------------------------------------------------------------------
	-- Seguridad si es el administrador no se aplica la seguridad
	--------------------------------------------------------------------------
	SET		@IsAdmin = 0
	SELECT	@IsAdmin = Is_Admin FROM t_User WHERE RTRIM(User_NameShort) = LTRIM(RTRIM(@User_NameShort))

	IF (@IsAdmin = 0)
	BEGIN
		INSERT INTO #IdPermissions 		
		SELECT DISTINCT rp.Per_Id, rp.Per_Table
		FROM t_User u
			INNER JOIN t_User_Permissions up	ON u.Id_User = up.Id_User 
			INNER JOIN t_User_Roles r			ON up.Id_Rol = r.Id_Rol AND r.Active = 1
			INNER JOIN t_User_RolPermissions rp	ON r.Id_Rol = rp.Id_Rol AND rp.Active = 1 AND Per_Id > 0
		WHERE u.User_NameShort = @User_NameShort 
	
	END
	
	PRINT @IsAdmin
	--------------------------------------------------------------------------
	-- Tablas temporale
	--------------------------------------------------------------------------

	-- SEGURIDAD
	 IF (@intNode_Clave = 'SEGU')
	 BEGIN
		INSERT INTO #Return
		SELECT	Id_User, User_Name,null,'~/_dUsers/wUsers.aspx?','~/Imagen/_User.png',0
	    FROM	t_User WHERE Dat_Delete is null
	 END
	 
	 IF (@intNode_Clave = 'SEGR')
	 BEGIN
		INSERT INTO #Return
		SELECT	Id_Rol, Rol_Name,null,'~/_dUsers/wRoles.aspx?','~/Imagen/_Roles.ico',0
	    FROM	t_User_Roles WHERE Dat_Delete is null
	 END
	 
	  IF (@intNode_Clave = 'SEGT')
	 BEGIN
		INSERT INTO #Return
		SELECT	team_id, team_name,'SEGE','~/_dRecording/wTeam.aspx?','~/Imagen/base.png',0
	    FROM	t_recording_team 
	 END
	  IF (@intNode_Clave = 'SEGE')
	  BEGIN
	 	INSERT INTO #Return 
		SELECT  @intNode_Id, 'Scripts(' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','SEGQ','~/_dRecording/wTeam.aspx?','~/Imagen/txt16.png',4
		FROM   t_recording_script WHERE  (script_activo = 1) AND (team_id = @intNode_Id)
	  END
	   IF (@intNode_Clave = 'SEGQ')
	  BEGIN
		INSERT INTO #Return			
	 	SELECT script_id, script_name, NULL,'~/_dRecording/wScript.aspx?KIDS=0','~/Imagen/script_rec.png',0 FROM t_recording_script WHERE team_id =  @intNode_Id
	 	AND script_activo = 1
	  END

	 
		 -- IF (@intNode_Clave = 'SEGM')
	 --BEGIN
		--INSERT INTO #Return
		--SELECT	mail_id, mail_tablename,null,'~/_dUsers/wConfigMail.aspx?','~/Imagen/_Mail-alt.png',0
	 --   FROM	t_MAIL WHERE mail_active = 'true'
	 --END
	--------------------------------------------------------------------------
	-- Data GARAGE
	--------------------------------------------------------------------------

	 IF (@intNode_Clave = 'GDTG')
	 BEGIN	 
	   INSERT INTO #Return VALUES(0,'_Consulta de Tablas',null,'~/_dGData/DGS.aspx?','~/Imagen/_odbc.ico',1)
	  
	  	INSERT INTO #Return
		SELECT id_modulo, sap_modulo + '-' + sap_descripcion , 'GDTI','~/_dGData/DGE.aspx?','~/Imagen/_TreeTable.png',2
		FROM dabarc.t_sap_modulo 		
	 END

	 IF (@intNode_Clave = 'GDTI')
	 BEGIN	 
	  	INSERT INTO #Return
		SELECT a.id_tabla,'[' + RTRIM(sap_sub_modulo) + '] [' + sap_table + '] ' + a.sap_descripcion, null,'~/_dGData/DGE.aspx?','~/Imagen/_TreeTable.png',2
		FROM dabarc.t_sap_submodulo s
			INNER JOIN dabarc.t_sap_submodulo_tabla st ON s.id_submodulo = st.id_submodulo AND s.id_modulo = @intNode_Id
			INNER JOIN dabarc.t_sap_tabla a ON st.id_tabla = a.tabla_id
	 END

	 
	--------------------------------------------------------------------------
	-- Tablas para la creación de SSIS
	--------------------------------------------------------------------------

	 --IF (@intNode_Clave = 'MISF')
	 --BEGIN
		--INSERT INTO #Return
		--	SELECT	0, 'Lista tipo Conexión', 'MISF01','~/_dConfig/wTypeODBCList.aspx','',0
	 --END 	
	 IF (@intNode_Clave = 'MISF')
	 BEGIN
		INSERT INTO #Return			
			SELECT driver_id, driver_dbms, 'MISD','~/_dODBC/wODBCListColType.aspx?','~/Imagen/_TreeDBFuente.png',0 FROM t_ODBC_driver
			--SELECT driver_id, driver_dbms, 'MISD','~/_dODBC/wODBCListRuleType.aspx?','~/Imagen/_TreeTable.ICO',0 FROM dabarc.t_ODBC_driver
	 END
	 
	 IF (@intNode_Clave = 'MISD')
	 BEGIN
	   
	   EXECUTE dabarc.sp_asp_Treeview_Idioma_Equi @strEqui OUTPUT

	 	INSERT INTO #Return			
	 		SELECT type_id, @strEqui + ' ' + type_name, NULL,'~/_dODBC/wODBCColType.aspx?','~/Imagen/_TreeEquivalence.ico',0 FROM t_ODBC_ctypes WHERE driver_id =  @intNode_Id
			--SELECT type_id, 'Equivalencia ' + rule_name, NULL,'~/_dODBC/wODBCRuleType.aspx?','~/Imagen/_TreeTable.ICO',0 FROM dabarc.t_ODBC_type WHERE driver_id =  @intNode_Id
	 END
	 
 	-- IF (@intNode_Clave = 'MISC') -Temporal
		--INSERT INTO #Return SELECT odbc_id,odbc_name,null,'~/_dODBC/wODBC.aspx?','~/Imagen/_odbc.ico',0 FROM t_ODBC
	
	 IF (@intNode_Clave = 'MISC') 
	 BEGIN
	 	 EXECUTE dabarc.sp_asp_Treeview_Idioma_Origen @strOrigen OUTPUT

		INSERT INTO #Return  SELECT distinct d.driver_id,@strOrigen + ' - ' + driver_dbms,'MISI','~/_dODBC/wODBCList.aspx?','~/Imagen/_TreeDBFuente.png',0 FROM t_ODBC_driver d 
			INNER JOIN t_ODBC o ON d.driver_id = o.driver_id
	 END
	 
	IF (@intNode_Clave = 'MISI') 	
	 INSERT INTO #Return SELECT odbc_id,odbc_name,null,'~/_dODBC/wODBC.aspx?','~/Imagen/_odbc.ico',0 FROM t_ODBC WHERE driver_id  =  @intNode_Id 
	 		
	 --IF (@intNode_Clave = 'MISP')
	 --	INSERT INTO #Return SELECT plantilla_id,plan_name,'MIST','~/_dSsis/wTemplate.aspx?','~/Imagen/_Template.ICO',0 FROM t_PlantillaH

    IF (@intNode_Clave = 'MISP')
    BEGIN
		INSERT INTO #ListaDestino(Name)
		SELECT DISTINCT RTRIM(sql_server) + ' - ' + RTRIM(sql_database) AS NameDest FROM t_PlantillaH ORDER BY NameDest
	
		INSERT INTO #Return SELECT distinct Id_Clave,Name,'MIPP','~/_dSsis/wTemplateList.aspx?','~/Imagen/_TreeDBManip.png',0 FROM #ListaDestino
	
	END

	
			
	 IF (@intNode_Clave = 'MIPP')
	 BEGIN
	 	INSERT INTO #ListaDestino(Name)
		SELECT DISTINCT sql_server + ' - ' + sql_database AS NameDest FROM dabarc.t_PlantillaH ORDER BY NameDest
	
	 	INSERT INTO #Return SELECT plantilla_id,plan_name,'MIST','~/_dSsis/wTemplate.aspx?','~/Imagen/_Template.ICO',0 FROM t_PlantillaH h
	 		INNER JOIN  #ListaDestino d ON RTRIM(h.sql_server) + ' - ' + RTRIM(h.sql_database) = d.Name AND d.Id_Clave = @intNode_Id
	 
	 END
	 	
	 IF (@intNode_Clave = 'MIST')
	 	INSERT INTO #Return SELECT plantillad_id,table_name,NULL,'~/_dSsis/wTemplateCol.aspx?','~/Imagen/_TreeTable.png',0 FROM t_PlantillaD WHERE plantilla_id = @intNode_Id
	 
	 	
	 IF (@intNode_Clave = 'MISS') -- Nodo de Ejecuciones - Lista de Driver 
	 BEGIN
	 EXECUTE dabarc.sp_asp_Treeview_Idioma_Origen @strOrigen OUTPUT

	  INSERT INTO #Return  SELECT distinct d.driver_id,@strOrigen + ' - ' + driver_dbms,'MILC','~/_dReport/wExecutePackgeList.aspx?','~/Imagen/_TreeDBFuente.png',0 FROM t_ODBC_driver d 
			INNER JOIN t_ODBC o ON d.driver_id = o.driver_id 
	 END


	 IF (@intNode_Clave = 'MILC')-- Nodo de Ejecuciones - Lista de conexiones
	 BEGIN
	   execute dabarc.sp_asp_Treeview_Idioma_Ejecutar @strEjecuta OUTPUT
	 
	 
	 	INSERT INTO #Return 	 	
	 	SELECT plantilla_id, @strEjecuta + ' ' + plan_name,null,'~/_dSsis/wExecutePackge.aspx?','~/Imagen/_TreePackage.ICO',0 FROM t_PlantillaH H
	 	 INNER JOIN t_ODBC o ON H.odbc_id = o.odbc_id
	 	 INNER JOIN t_ODBC_driver d ON o.driver_id = d.driver_id 
	 	 WHERE d.driver_id = @intNode_Id
	END 		 
	 	
	 	
	 ------------------------------------------------------------------------
	 

	-- INTEGRATION SERVICES
	 IF (@intNode_Clave = 'METE')
	 BEGIN
	   INSERT INTO #Return 
	   SELECT  ssis_id, name,null,'~/_dSsis/wSsis.aspx?','~/Imagen/_TreePackage.ico',0  --- xx
	   FROM    dabarc.t_SSIS WHERE (registered = 1) AND name LIKE 'SSIS[_]TFF[_]%'  ORDER BY active DESC, priority ASC
	 END
	 --- DATOS FUENTES -- CON SEGURIDAD
	 IF (@intNode_Clave = 'METF')
	 BEGIN	  
	 
	  IF (@IsAdmin = 1)
	  BEGIN 	  
	   INSERT INTO #Return 
	   SELECT  database_id, name, 'TBLF','~/_dDatabase/wDB.aspx?TBL=FF','~/Imagen/_TreeDB.png',0
	   FROM    t_BDF WHERE (registered = 1) ORDER BY active DESC, priority ASC
	  END
	  ELSE
	  BEGIN	  
	   INSERT INTO #Return 
	   SELECT  database_id, name, 'TBLF','~/_dDatabase/wDB.aspx?TBL=FF','~/Imagen/_TreeDB.png',0
	   FROM    t_BDF t 
			INNER JOIN #IdPermissions p ON database_id = p.Id_Clave AND UPPER(p.Type_Object) = 'T_BDF' 
	   WHERE (registered = 1) ORDER BY active DESC, priority ASC	  
	  END	  	   
	 END
	 
	 
	 IF (@intNode_Clave = 'TBLF')
	 BEGIN
	    INSERT INTO #Return -- Nodo para lo ssis por base de datos
	    SELECT  @intNode_Id, 'DB SSIS', 'FSSIS','~/_dSsis/wSsisList.aspx?DB=FF','~/Imagen/_TreePackage.ico',0
	   		   	
	    INSERT INTO #Return 
		SELECT table_id, name,'OBJF','~/_dTable/wTable.aspx?TBL=FF','~/Imagen/_TreeTable.png',1
		FROM   t_TFF  WHERE  (registered = 1) AND (database_id = @intNode_Id) ORDER BY active DESC, priority ASC
	 END
	 
	 -- Ssis por base de datos
	 IF (@intNode_Clave = 'FSSIS')
	 BEGIN	   		   	
	    INSERT INTO #Return 
		SELECT  ssis_id, name,null,'~/_dSsis/wSsis.aspx?','~/Imagen/_TreePackage.ico',0
		FROM    t_SSIS  WHERE  (registered = 1) AND (database_id = @intNode_Id) ORDER BY active DESC, priority ASC
	 END
	 
	 
	 IF (@intNode_Clave = 'OBJF')
	 BEGIN
		 execute dabarc.sp_asp_Treeview_Idioma_RuleInfoTable @strSSIS OUTPUT, @strRegla OUTPUT, @strInfor OUTPUT, @strTable OUTPUT

	    INSERT INTO #Return 
	    SELECT  @intNode_Id,@strSSIS + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','FF_SSIS',NULL,'~/Imagen/_Ssis.ICO',1
		FROM    t_SSIS  WHERE   (registered = 1) AND (table_id = @intNode_Id) AND name like 'SSIS_TFF%'
		UNION
		SELECT  @intNode_Id,@strRegla + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','FF_RULE',NULL,'~/Imagen/_TreeRule.ICO',2
		FROM    t_RFF   WHERE   (registered = 1) AND (table_id = @intNode_Id) 		
		UNION
		SELECT  @intNode_Id,@strInfor + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','FF_INFO',NULL,'~/Imagen/_TreeInfo.png',3
		FROM    t_IFF   WHERE   (registered = 1) AND (table_id = @intNode_Id)
		
	 END

	 IF (@intNode_Clave = 'FF_SSIS')
	 BEGIN
	 	INSERT INTO #Return 
		SELECT  ssis_id, name, NULL,'~/_dSsis/wSsis.aspx?','~/Imagen/_TreePackage.ico',0
		FROM    t_SSIS  WHERE   (registered = 1) AND (table_id = @intNode_Id) AND name like 'SSIS_TFF%'
	 END

	 IF (@intNode_Clave = 'FF_RULE')
	 BEGIN
	 	INSERT INTO #Return 
		SELECT  rule_id ,name, NULL,'~/_dRules/wRules.aspx?TBL=FF','~/Imagen/_TreeRule.ICO',1
		FROM    t_RFF   WHERE   (registered = 1) AND (table_id = @intNode_Id) 		
	 END
	 
	 IF (@intNode_Clave = 'FF_INFO')
	 BEGIN
	 	INSERT INTO #Return 
		SELECT  report_id,name, NULL,'~/_dReport/wReport.aspx?TBL=FF','~/Imagen/_TreeInfo.png',2
		FROM    t_IFF   WHERE   (registered = 1) AND (table_id = @intNode_Id)		
	 END
	 
	 
	 
	 
 	 --- DATOS DESTINO
	 IF (@intNode_Clave = 'METD')
	 BEGIN	 
	 	IF (@IsAdmin = 1)
		  BEGIN 	  
		   INSERT INTO #Return 
		   SELECT  database_id, name, 'TBLD','~/_dDatabase/wDB.aspx?TBL=DM','~/Imagen/_TreeDB.png',0
		   FROM    t_BDM WHERE (registered = 1) ORDER BY active DESC, priority ASC	   
		  END
		ELSE
		  BEGIN	  
		   INSERT INTO #Return 
		   SELECT  database_id, name, 'TBLD','~/_dDatabase/wDB.aspx?TBL=DM','~/Imagen/_TreeDB.png',0
		   FROM    t_BDM t 
				INNER JOIN #IdPermissions p ON database_id = p.Id_Clave AND UPPER(p.Type_Object) = 'T_BDM' 
			WHERE (registered = 1) ORDER BY active DESC, priority ASC	   
		  END
	 END
	 
 
 	 IF (@intNode_Clave = 'TBLD')
	 BEGIN
		INSERT INTO #Return -- Nodo para lo ssis por base de datos
	    SELECT  @intNode_Id, 'DB SSIS', 'MSSIS','~/_dSsis/wSsisList.aspx?DB=DM','~/Imagen/_TreePackage.ico',0
	    
	    INSERT INTO #Return 
		SELECT table_id, name, 'OBJD','~/_dTable/wTable.aspx?TBL=DM','~/Imagen/_TreeTable.png',1
		FROM   t_TDM  WHERE  (registered = 1) AND (database_id = @intNode_Id) ORDER BY active DESC, priority ASC
	 END
 
 	 
	 IF (@intNode_Clave = 'MSSIS')-- Ssis por base de datos de manipulacion
	 BEGIN	   		   	
	    INSERT INTO #Return 
		SELECT  ssis_id, name,null,'~/_dSsis/wSsis.aspx?','~/Imagen/_TreePackage.ico',0
		FROM    t_SSIS  WHERE  (registered = 1) AND (database_id = @intNode_Id) ORDER BY active DESC, priority ASC
	 END
	 
	 
 	 IF (@intNode_Clave = 'OBJD')
	 BEGIN
	     execute dabarc.sp_asp_Treeview_Idioma_RuleInfoTable @strSSIS OUTPUT, @strRegla OUTPUT, @strInfor OUTPUT, @strTable OUTPUT

	 	INSERT INTO #Return 
		SELECT  @intNode_Id,@strTable + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','DM_TFM',NULL,'~/Imagen/_TreeTable.png',4
		FROM    t_TFM WHERE   (registered = 1) AND (tdm_id = @intNode_Id)
		UNION
		SELECT @intNode_Id,@strSSIS + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','DM_SSIS',NULL,'~/Imagen/_TreePackage.ico',1
		FROM    t_SSIS WHERE  (registered = 1) AND (table_id = @intNode_Id) AND name like 'SSIS_TDM%'
		UNION
		SELECT  @intNode_Id,@strRegla + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','DM_RULE',NULL,'~/Imagen/_TreeRule.ICO',2
		FROM    t_RDM  WHERE  (registered = 1) AND (table_id = @intNode_Id)
		UNION
		SELECT  @intNode_Id,@strInfor + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','DM_INFO',NULL,'~/Imagen/_TreeInfo.png',3
		FROM    t_IDM  WHERE  (registered = 1) AND (table_id = @intNode_Id) 
   
	 END
 
	  
 
  
  	 IF (@intNode_Clave = 'DM_TFM')
	 BEGIN			 	
		INSERT INTO #Return 
	 	SELECT  table_id, name, 'OBJM','~/_dTable/wTable.aspx?TBL=FM','~/Imagen/_TreeTable.png',0
		FROM    t_TFM WHERE   (registered = 1) AND (tdm_id = @intNode_Id)
	 END
 
 
  	 IF (@intNode_Clave = 'DM_SSIS')
	 BEGIN
	   INSERT INTO #Return 
	   SELECT  ssis_id,name, NULL,'~/_dSsis/wSsis.aspx?','~/Imagen/_Ssis.ICO',1
	   FROM    t_SSIS WHERE  (registered = 1) AND (table_id = @intNode_Id) AND name like 'SSIS_TDM%'
	 END
	 
  	 IF (@intNode_Clave = 'DM_RULE')
	 BEGIN
	   INSERT INTO #Return 
	 	SELECT  rule_id,name, NULL,'~/_dRules/wRules.aspx?TBL=DM','~/Imagen/_TreeRule.ICO',2
		FROM    t_RDM  WHERE  (registered = 1) AND (table_id = @intNode_Id)
	 END
	 
  	 IF (@intNode_Clave = 'DM_INFO')
	 BEGIN
	   INSERT INTO #Return 
	   SELECT  report_id,name, 'FM_RULER','~/_dReport/wReport.aspx?TBL=DM','~/Imagen/_TreeInfo.png',3
	   FROM    t_IDM  WHERE  (registered = 1) AND (table_id = @intNode_Id)
	 END
 
 	 IF (@intNode_Clave = 'FM_RULER')
	 BEGIN
	   INSERT INTO #Return 
		SELECT  rule_id,name, NULL ,'~/_dRules/wRules.aspx?TBL=RF','~/Imagen/_TreeInfo.png',2
		FROM    t_RRF  WHERE   (registered = 1) AND (info_id = @intNode_Id)
	 END
	 
  	 IF (@intNode_Clave = 'OBJM')
	 BEGIN
	     execute dabarc.sp_asp_Treeview_Idioma_RuleInfoTable @strSSIS OUTPUT, @strRegla OUTPUT, @strInfor OUTPUT, @strTable OUTPUT

	 	INSERT INTO #Return 
			SELECT @intNode_Id,@strSSIS + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','FM_SSIS',NULL,'~/Imagen/_Ssis.ICO',1
			FROM    t_SSIS WHERE  (registered = 1) AND (table_id = @intNode_Id) AND name like 'SSIS_TFM%'
		UNION
			SELECT  @intNode_Id,@strRegla + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','FM_RULE',NULL,'~/Imagen/_TreeRule.ICO',2
			FROM    t_RFM  WHERE  (registered = 1) AND (table_id = @intNode_Id)
		UNION
			SELECT  @intNode_Id,@strInfor + ' (' + RTRIM(CAST(COUNT(*) AS CHAR(7))) + ')','FM_INFO',NULL,'~/Imagen/_TreeInfo.png',3
			FROM    t_IFM  WHERE   (registered = 1) AND (table_id = @intNode_Id)
  
	 END
 
 
   	 IF (@intNode_Clave = 'FM_SSIS')
	 BEGIN
	    
	   INSERT INTO #Return 
		SELECT  ssis_id,name, NULL,'~/_dSsis/wSsis.aspx?','~/Imagen/_Ssis.ICO',1
		FROM    t_SSIS WHERE  (registered = 1) AND (table_id = @intNode_Id) AND name like 'SSIS_TFM%'  
	 END
	 
  	 IF (@intNode_Clave = 'FM_RULE')
	 BEGIN
	   INSERT INTO #Return 
		SELECT  rule_id,name,NULL,'~/_dRules/wRules.aspx?TBL=FM','~/Imagen/_TreeRule.ICO',1
		FROM    t_RFM  WHERE  (registered = 1) AND (table_id = @intNode_Id)
	 END
	 
  	 IF (@intNode_Clave = 'FM_INFO')
	 BEGIN
	   INSERT INTO #Return 
		SELECT  report_id,name, NULL ,'~/_dReport/wReport.aspx?TBL=FM','~/Imagen/_TreeInfo.png',2
		FROM    t_IFM  WHERE   (registered = 1) AND (table_id = @intNode_Id)
	 END
	 
     IF (@intNode_Clave = 'METI')
	 BEGIN
	 	INSERT INTO #Return 
		SELECT  interface_id,name, NULL ,'~/_nInterfaces/wnInterface.aspx?','~/Imagen/_TreeInterface.ico',1
		FROM    t_InterfacesN --WHERE active = 0
		ORDER BY name ASC
     END		
     
	 
	 
	 IF ((@intNode_Clave = 'OBJF') or (@intNode_Clave = 'OBJD') or (@intNode_Clave = 'OBJM') or (@intNode_Clave = 'MISF'))
	 BEGIN
		SELECT Node_Clave,
				Node_Name,
				Node_NexClave,
				RTRIM(Node_Url) + '&FR=TR' as Node_Url,
				Node_Imagen
		 FROM   #Return
		 ORDER BY Node_Orden ASC
	 END
	 ELSE
	 BEGIN
		 SELECT Node_Clave,
				Node_Name,
				Node_NexClave,
				RTRIM(Node_Url) + '&FR=TR' as Node_Url,
				Node_Imagen
		 FROM   #Return
		 ORDER BY Node_Name ASC
	 END
