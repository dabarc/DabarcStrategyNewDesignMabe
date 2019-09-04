
CREATE PROCEDURE [dabarc].[sp_USER_Security] 
			  @username		nvarchar(100)
             ,@screen_Name	nvarchar(100) --- 'wlistssis.apx'
             ,@TypeObject	nvarchar(5)   --- 'BDF', 'TFF', 'RFF','SSIS_TFF','SSIS_TDM'
             ,@IdObjType	int			  ---  1,2,3,4	
AS
	---------------------------------------------------------------------------------------------------------
	---- Obtiene un consulta de usuario con la seguridad que se aplica a la pantalla.
	---- Norma Jiménez
	---- 09-01-2014
	---------------------------------------------------------------------------------------------------------


	---------------------------------------------------------------------------------------------------------
	---- Declaración de tabla temporal
	---------------------------------------------------------------------------------------------------------
	--DECLARE @TypeObject NVARCHAR(3)		
	DECLARE @DB_NAME	NVARCHAR(50)		
			
	SET @DB_NAME = ''	
			
	 CREATE TABLE #temp ( 
			  Id_User int
			  ,User_Name nvarchar(100)
			  ,User_NameShort nvarchar(10)
			  ,User_Password nvarchar(300)
			  ,User_MobilePIN nchar(10)
			  ,User_Email nvarchar(50)
			  ,User_PwdQuestion nvarchar(50)
			  ,User_PwdAnswer nvarchar (50)
			  ,User_Active bit
			  ,User_OwnerOnlyData bit
			  ,Dat_Insert datetime
			  ,Dat_Update datetime
			  ,Dat_Delete datetime
			  ,nameScreen nvarchar(100) 
			  ,Per_Exec bit
			  ,Per_Insert bit
     		  ,Per_Update bit
     		  ,Per_Delete bit
     		  ,Lng_Id nchar(5) )				
 
 INSERT INTO #temp SELECT Id_User
			  ,User_Name
			  ,User_NameShort
			  ,User_Password
			  ,User_MobilePIN
			  ,User_Email
			  ,User_PwdQuestion
			  ,User_PwdAnswer
			  ,User_Active
			  ,User_OwnerOnlyData
			  ,Dat_Insert
			  ,Dat_Update
			  ,Dat_Delete
			  ,NULL
			  ,1
			  ,1
			  ,1
			  ,1
			  ,lng_id
	      FROM dabarc.t_User
		  WHERE User_NameShort = @username
		  
		  
	---------------------------------------------------------------------------------------------------------
	---- Obtenemos los permisos sumados de todos los roles que le dan seguridad a esa pantalla y en donde
	---- el usuario está asignado
	---------------------------------------------------------------------------------------------------------		  

	IF (@screen_Name <> 'NULL') --'wSsisList.aspx'
	BEGIN
		  UPDATE t
		   SET
			t.nameScreen = screen,
			t.Per_Exec = exe,
			t.Per_Insert = ins,
			t.Per_Update = upd,
			t.Per_Delete = del
		   FROM #temp t
			INNER JOIN (SELECT t.Id_User, RTRIM(dabarc.fnt_get_screenName(b.Node_Url)) as screen,
			   case when sum(cast(rp.Per_Execute as int)) > 0 then 1 else 0 end as exe,
			   case when sum(cast(rp.Per_Insert as int)) > 0 then 1 else 0 end as ins,
			   case when sum(cast(rp.Per_Modify as int)) > 0 then 1 else 0 end as upd,
			   case when sum(cast(rp.Per_Delete as int)) > 0 then 1 else 0 end as del
		   FROM #temp t 
			INNER JOIN dabarc.t_User_Permissions  p ON t.Id_User  = p.Id_User 	
			INNER JOIN dabarc.t_User_RolPermissions rp ON rp.Id_Rol = p.Id_Rol 
			INNER JOIN dabarc.asp_InfoTreeview_Base b  ON rp.Id_TreeViewB = b.Id_TreeviewB 
		  WHERE rp.Active = 1 AND dabarc.fnt_get_screenName(b.Node_Url) = @screen_Name 
		  GROUP BY t.Id_User, dabarc.fnt_get_screenName(b.Node_Url)) p ON p.Id_User = t.Id_User
		    
	 END		 
	ELSE
	 BEGIN --'BDF_FUENTE_SAP' (y para la lista de SSIS) / 'TFF' / 'RFF', 'IFF', 
	 
IF (@TypeObject = 'BDF')
		 SET @DB_NAME =(SELECT name FROM dabarc.t_BDF where database_id = @IdObjType)
		 
		 
	 IF (@TypeObject = 'BDM')
		  SET @DB_NAME = (SELECT name FROM dabarc.t_BDM where database_id = @IdObjType)
		  	 
	 If (@TypeObject = 'TFF')
		 SET @DB_NAME =(SELECT f.name  FROM dabarc.t_BDF f
			INNER JOIN dabarc.t_TFF f2 ON f.database_id = f2.database_id AND table_id = @IdObjType)
			
	If (@TypeObject = 'TDM')
		  SET @DB_NAME =(SELECT f.name  FROM dabarc.t_BDM f
			INNER JOIN dabarc.t_TDM f2 ON f.database_id = f2.database_id AND table_id = @IdObjType)
			
	If (@TypeObject = 'TFM')
		  SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDM f
			INNER JOIN dabarc.t_TDM f2 ON f.database_id = f2.database_id 
			INNER JOIN dabarc.t_TFM f3 ON f2.table_id = f3.tdm_id AND f3.table_id = @IdObjType)			
					
	 IF (@TypeObject = 'RFF')
		  SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDF f
			INNER JOIN dabarc.t_TFF f2 ON f.database_id = f2.database_id
			INNER JOIN dabarc.t_RFF f3 ON f2.table_id = f3.table_id AND rule_id = @IdObjType)
		
	 IF (@TypeObject = 'RDM')
		 SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDM f
			INNER JOIN dabarc.t_TDM f2 ON f.database_id = f2.database_id
			INNER JOIN dabarc.t_RDM f3 ON f2.table_id = f3.table_id AND rule_id = @IdObjType)	
			
	 IF (@TypeObject = 'RFM')
		  SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDM f
			INNER JOIN dabarc.t_TDM f2 ON f.database_id = f2.database_id
			INNER JOIN dabarc.t_TFM f3 ON f2.database_id = f3.tdm_id
			INNER JOIN dabarc.t_RFM f4 ON f3.table_id = f4.table_id AND rule_id = @IdObjType)
				
	 IF (@TypeObject = 'IFF')
		 SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDF f
			INNER JOIN dabarc.t_TFF f2 ON f.database_id = f2.database_id
			INNER JOIN dabarc.t_IFF f3 ON f2.table_id = f3.table_id AND report_id = @idObjType)
						
	 IF (@TypeObject = 'IDM')
		 SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDM f
			INNER JOIN dabarc.t_TDM f2 ON f.database_id = f2.database_id
			INNER JOIN dabarc.t_IDM f3 ON f2.table_id = f3.table_id AND report_id = @idObjType)
			
	 IF (@TypeObject = 'IFM')
		 SET @DB_NAME = (SELECT f.name  FROM dabarc.t_BDM f
			INNER JOIN dabarc.t_TDM f2 ON f.database_id = f2.database_id
			INNER JOIN dabarc.t_TFM f3 ON f2.database_id = f3.tdm_id
			INNER JOIN dabarc.t_IFM f4 ON f3.table_id = f4.table_id AND report_id = @IdObjType)
			
	 IF (@TypeObject = 'SSIF')
		   SET @DB_NAME = (SELECT b.name 
		  FROM	dabarc.t_SSIS t
				INNER JOIN dabarc.t_BDF b ON t.database_id  = b.database_id
		  WHERE ssis_id = @IdObjType)
		  
	 IF (@TypeObject = 'SSID')
		  SET @DB_NAME = (SELECT b.name 
		  FROM	dabarc.t_SSIS t
				INNER JOIN t_BDM b ON t.database_id  = b.database_id
		  WHERE ssis_id = @IdObjType)
		  
	
		UPDATE t
		   SET
			t.nameScreen = dbName,
			t.Per_Exec = exe,
			t.Per_Insert = ins,
			t.Per_Update = upd,
			t.Per_Delete = del
		   FROM #temp t
			INNER JOIN (SELECT t.Id_User, RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name))) as dbName,
			   case when sum(cast(rp.Per_Execute as int)) > 0 then 1 else 0 end as exe,
			   case when sum(cast(rp.Per_Insert as int)) > 0 then 1 else 0 end as ins,
			   case when sum(cast(rp.Per_Modify as int)) > 0 then 1 else 0 end as upd,
			   case when sum(cast(rp.Per_Delete as int)) > 0 then 1 else 0 end as del,
			    RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name))) AS gf
		   FROM #temp t 
			INNER JOIN dabarc.t_User_Permissions  p ON t.Id_User  = p.Id_User 	
			INNER JOIN dabarc.t_User_RolPermissions rp ON rp.Id_Rol = p.Id_Rol 
		  WHERE rp.Active = 1 AND RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name))) = @DB_NAME
		  GROUP BY t.Id_User, RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name)))) p ON p.Id_User = t.Id_User
		    
		 
	 END
	 IF (SELECT UPPER(User_NameShort)FROM #temp) != 'ADMIN'

	 	 SELECT * FROM #temp
