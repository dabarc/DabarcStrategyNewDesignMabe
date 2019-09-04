CREATE PROCEDURE [dabarc].[sp_INFO_PathDirectory] @Type_File CHAR(5), @Id_Table INT AS
 
	DECLARE @PathDirectory VARCHAR(300)
 
	 IF (RTRIM(UPPER(@Type_File)) = 'BDF' OR 
		 RTRIM(UPPER(@Type_File)) = 'TFF' OR 
		 RTRIM(UPPER(@Type_File)) = 'IFF')
	BEGIN
	 
		SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t.name)+ '\' FROM dabarc.t_BDF f 
			INNER JOIN t_TFF t ON f.database_id = t.database_id
			INNER JOIN t_IFF i ON t.table_id = i.table_id
		WHERE i.report_id = @Id_Table	
	
	 
	 END
	  
	 
	 IF (RTRIM(UPPER(@Type_File)) = 'BDM' OR
		 RTRIM(UPPER(@Type_File)) = 'TDM' OR
		 RTRIM(UPPER(@Type_File)) = 'IDM')
	 BEGIN
	 
		SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t.name) + '\' FROM dabarc.t_BDM f 
			INNER JOIN t_TDM t ON f.database_id = t.database_id
			INNER JOIN t_IDM i ON t.table_id = i.table_id
		WHERE i.report_id = @Id_Table	
	
	 END
	 
	 
	 IF (RTRIM(UPPER(@Type_File)) = 'TFM' OR
		 RTRIM(UPPER(@Type_File)) = 'IFM')
	 BEGIN
	 
		SELECT @PathDirectory = RTRIM(f.name) + '\' + RTRIM(t1.name)+ '\' FROM dabarc.t_BDM f 
			INNER JOIN t_TDM t ON f.database_id = t.database_id
			INNER JOIN t_TFM t1 ON t.table_id = t1.tdm_id
			INNER JOIN t_IFM i ON t1.table_id = i.table_id
		WHERE i.report_id = @Id_Table
			
	 END
	 
	 --SELECT 'D:\_dabarcsystems_dvp06\_vsdabarc\_file_info\' + @PathDirectory
	 SELECT  @PathDirectory
