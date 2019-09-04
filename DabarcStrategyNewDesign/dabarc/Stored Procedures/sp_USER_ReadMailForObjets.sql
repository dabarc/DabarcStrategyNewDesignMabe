CREATE PROCEDURE [dabarc].[sp_USER_ReadMailForObjets]
@ppath_unickey NVARCHAR(80) ,
@mail_idobjects INT = 0 ,
@mail_tablename NVARCHAR(50) = ''
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Object_id NCHAR(10)
  ---------------------------------------------------------------------------------------------------------------------------
  --- Creamos una tabla temporal para colocar, los objetos definidos en la tabla en las interfaces
  ---------------------------------------------------------------------------------------------------------------------------
	CREATE TABLE #tmpMAIL(	typeMail	NVARCHAR(4),
							nameUser	NVARCHAR(50),
							adressMail	NVARCHAR(100),
							infoOutput	INT,
							individual	BIT)
  ------------TIPO DE OBJETO
  -- NORM : DB, TABLA, REGLA , INFORME, SSIS , TSSIS
  -- INTE : Interfaces
  ------------infoOutput 
  -- 0 Solo mostrar estatus
  -- 1 Mandar la ruta del reporte
  -- 2 Mandar Reporte Adjunto
  ---------------------------------------------------------------------------------------------------------------------------
  --- Obtenemos la clave del objeto 
  --------------------------------------------------------------------------------------------------------------------------
	SELECT DISTINCT	
		@Object_id = dabarc.fnt_ObjectIdAndType(path_id, CASE WHEN RTRIM(Path_hType) = 'SSIS' THEN Path_hType ELSE path_TypeClass END) 
  FROM	dabarc.t_Sql_process_executeH
  WHERE	Path_hKey = @ppath_unickey
  ---------------------------------------------------------------------------------------------------------------------------
  --- Insertamos tablas
  ---------------------------------------------------------------------------------------------------------------------------
  --- Insetamos objeto de interfaces
  ---------------------------------------------------------------------------------------------------------------------------
		  IF (SELECT COUNT(*) FROM t_Sql_process_executeH WHERE UPPER(RTRIM(path_hTypeProcess)) = 'INTERFAZ' AND Path_hKey = @ppath_unickey) > 0
			  BEGIN	   
  					INSERT INTO #tmpMAIL
						SELECT 'INTE', 
								ISNULL(u.User_Email, m.mail_name) , 
								ISNULL(u.User_Email, m.mail_email),
								m.mail_InfoOutput,
								m.mail_individual
						FROM t_InterfacesN n
							INNER JOIN t_InterfacesObjectsN	o ON n.interface_id = o.interface_id
							INNER JOIN t_LogInterfacesN		l ON o.int_IdObj = l.execute_object_id AND RTRIM(l.execute_unickey) = @ppath_unickey
							INNER JOIN t_MAIL				m ON n.interface_id = m.mail_idobjects AND mail_objectstype = 'INTE'
							LEFT OUTER JOIN t_User			u ON m.mail_iduser = u.Id_User
						WHERE dabarc.fnt_ObjectIdAndType(int_IdObj,object_type) = RTRIM(@Object_id) 
							  AND n.active = 1 AND o.active = 1  AND m.mail_active = 1	
			  END
		  ELSE 
		  BEGIN
		    IF(@mail_idobjects <> 0 AND @mail_tablename <> '')
			     BEGIN 
					INSERT INTO #tmpMAIL
					SELECT 'NORM', 
							ISNULL(u.User_Email, m.mail_name)  AS 'User_Name', 
							ISNULL(u.User_Email, m.mail_email) AS User_Email,
							m.mail_InfoOutput,
							m.mail_individual
					FROM t_MAIL m 
					INNER JOIN vw_Active_Objects o		ON m.mail_idobjects = o.objectid AND m.mail_objectstype = o.object_type
					LEFT OUTER JOIN t_User u			ON m.mail_iduser = u.Id_User
					WHERE mail_idobjects = @mail_idobjects AND mail_tablename = @mail_tablename AND M.mail_active = 1
				 END
	         ELSE
				 BEGIN
					INSERT INTO #tmpMAIL
					SELECT 'NORM', 
							ISNULL(u.User_Email, m.mail_name) , 
							ISNULL(u.User_Email, m.mail_email),
							m.mail_InfoOutput,
							m.mail_individual
					FROM t_MAIL m 
					INNER JOIN vw_Active_Objects o		ON m.mail_idobjects = o.objectid AND m.mail_objectstype = o.object_type
					LEFT OUTER JOIN t_User u			ON m.mail_iduser = u.Id_User
					WHERE 	RTRIM(object_id) = RTRIM(@Object_id) AND M.mail_active = 1
				 END
			 END
---------------------------------------------------------------------------------------------------------------------------
  --- Retornamos datos 
  ---------------------------------------------------------------------------------------------------------------------------
   SELECT	typeMail, 
			LTRIM(RTRIM(nameUser)) + '|' + LTRIM(RTRIM(adressMail)) cons_mail, 
			infoOutput as cons_typeinfo,
			individual as cons_indivi
   FROM		#tmpMAIL
   ORDER BY individual DESC, infoOutput ASC
END
