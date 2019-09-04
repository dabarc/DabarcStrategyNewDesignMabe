CREATE PROCEDURE dabarc.sp_INFO_ReadPathInfo @typeOfInformation VARCHAR(5), @report_id INT AS

 DECLARE @DB_NAME NVARCHAR(50)
 
 
 IF (RTRIM(@typeOfInformation) = 'IFF')
 BEGIN 
		SELECT b.name + '\' + f.name
		FROM   t_BDF b
			INNER JOIN t_TFF f ON b.database_id = f.database_id
			INNER JOIN t_IFF i ON f.table_id = i.table_id AND i.report_id = @report_id
 END
 
  IF (RTRIM(@typeOfInformation) = 'IDM')
 BEGIN 
		SELECT  b.name + '\' + f.name
		FROM   t_BDM b
			INNER JOIN t_TDM f ON b.database_id = f.database_id
			INNER JOIN t_IDM i ON f.table_id = i.table_id AND i.report_id = @report_id	
 END
 
 
  IF (RTRIM(@typeOfInformation) = 'IFM')
 BEGIN 
			SELECT  b.name + '\' + m.name
		FROM   t_BDM b
			INNER JOIN t_TDM f ON b.database_id = f.database_id
			INNER JOIN t_TFM m ON f.table_id = m.tdm_id
			INNER JOIN t_IFM i ON m.table_id = i.table_id AND i.report_id = @report_id		
 END
