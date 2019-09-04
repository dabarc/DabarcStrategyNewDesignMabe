CREATE PROCEDURE [dabarc].[sp_XREF_InserRowOfXREF]
            @bdXref_id INT, 
			@tblXref_id		   INT, 
			@type_bd           NVARCHAR(3),
			@table_name		   NVARCHAR(128), 
			@filename          NVARCHAR(2000),
			@filename_new	   NVARCHAR(2000),
			@description       NVARCHAR(500),
			@version           INT,
			@file_path	       NVARCHAR(500),
			@path_source       NVARCHAR(2000),
			@sheet_num         INT,
			@register_user     NVARCHAR(15)
			AS 

INSERT INTO [t_XREF_REP]
           ([bdXref_id]
           ,[type_bd]
           ,[tblXref_id]
           ,[table_name]
           ,[filename]
           ,[filename_new]
           ,[description]
           ,[version]
           ,[file_path]
           ,[path_source]
           ,[sheet_num]
           ,[register_user]
           ,[register_date]
           ,[registered])
           
VALUES	(	@bdXref_id,
			@type_bd,
			@tblXref_id,
			@table_name,
			@filename,
			@filename_new,
			@description,
			@version,
			@file_path,
			@path_source,
			@sheet_num,
			@register_user,
			GETDATE(),
			1)
