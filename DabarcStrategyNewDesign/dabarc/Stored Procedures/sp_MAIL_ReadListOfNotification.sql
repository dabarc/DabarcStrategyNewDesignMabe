CREATE PROCEDURE [dabarc].[sp_MAIL_ReadListOfNotification] AS

SELECT mail_id
      ,'[' + mail_objectstype + '] ' + o.name as Nombre
      ,mail_active
	  ,u.User_Name + ' | ' + u.User_Email as User_Email
      ,mail_name
      ,mail_email
      ,CASE WHEN mail_InfoOutput = 1 THEN 'Mostrar la Ruta del Archivo'
			WHEN mail_InfoOutput = 2 THEN 'Mostrar el Archivo Adjunto' ELSE 'Mostrar solo el estado del informe' END as [mail_InfoOutput]
      ,mail_insert
      ,mail_user
      ,mail_individual 
  FROM t_MAIL m
		INNER JOIN vw_Active_Objects o 
		ON m.mail_idobjects = o.objectid AND m.mail_objectstype = o.object_type
		LEFT OUTER JOIN t_User u ON m.mail_iduser = u.Id_User
		order by mail_active desc
