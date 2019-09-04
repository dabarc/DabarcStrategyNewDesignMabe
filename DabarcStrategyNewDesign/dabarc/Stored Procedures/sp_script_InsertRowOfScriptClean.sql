CREATE PROCEDURE [dabarc].[sp_script_InsertRowOfScriptClean] 
		    @table_name nvarchar(100)
		   ,@field_name nvarchar(100)
		   ,@idsinfo int
		   ,@userinsert nvarchar(10)
		   ,@script_final nvarchar(400)
		   ,@info_name nvarchar(200)
          
AS
 
INSERT INTO dabarc.t_scriptInfcleanData1
           (active
            ,tablename
			,fieldname
			,idsinfo
			,dateinsert
			,userinsert
			,script_final
			,info_name)
			
     VALUES
           (0
           ,@table_name
           ,@field_name
           ,@idsinfo
           ,GETDATE()
           ,@userinsert
           ,@script_final
           ,@info_name)
