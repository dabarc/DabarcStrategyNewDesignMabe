/****** Object:  StoredProcedure [dabarc].[sp_INFO_PathDirectory]    Script Date: 08/05/2014 16:17:07 ******/

CREATE PROCEDURE [dabarc].[sp_dbs_PathOfObjects] @Type CHAR(3), @Id INT AS 

 DECLARE @PathDirectory NVARCHAR(1000)
 
	 
	 IF (@Type = 'BDF') SELECT @PathDirectory = name FROM t_BDF WHERE database_id = @Id 
	 IF (@Type = 'BDM') SELECT @PathDirectory = name FROM t_BDM WHERE database_id = @Id
	 
	 If (@Type = 'TFF')
		 SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' 
		 FROM	t_BDF		f 
				INNER JOIN t_TFF t ON f.database_id = t.database_id
		 WHERE	t.table_id = @Id  
	
	 IF (@Type = 'TDM')
		 SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' 
		 FROM	t_BDM		f 
				INNER JOIN t_TDM	t ON f.database_id = t.database_id
		 WHERE	t.table_id = @Id 
	
	 IF (@Type = 'TFM')
		 SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t1.name)+ '\' 
		 FROM   t_BDM f 
				INNER JOIN t_TDM	t  ON f.database_id = t.database_id
				INNER JOIN t_TFM	t1 ON t.table_id = t1.tdm_id
		 WHERE	t1.table_id = @Id
	
	 IF (@Type = 'IFF')
 		 SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' 
		 FROM	t_BDF		f 
				INNER JOIN t_TFF	t ON f.database_id = t.database_id
	 			INNER JOIN t_IFF	i ON t.table_id = i.table_id
		WHERE	i.report_id = @Id  	
	
	 IF (@Type = 'IDM')
		 SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' 
		 FROM	t_BDM		f 
				INNER JOIN t_TDM	t ON f.database_id = t.database_id
				INNER JOIN t_IDM	i ON t.table_id =  i.table_id
		WHERE	i.report_id = @Id
	
	IF (@Type = 'IFM')
		SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t1.name)+ '\'
		FROM	t_BDM f 
				INNER JOIN t_TDM	t  ON f.database_id = t.database_id
				INNER JOIN t_TFM	t1 ON t.table_id = t1.tdm_id
				INNER JOIN t_IFM	i  ON t1.table_id = i.table_id
		WHERE	i.report_id = @Id 

    SELECT @PathDirectory AS Data
