CREATE PROCEDURE [dabarc].[sp_script_InsertRowOfScriptConfig] 
		    @table_name nvarchar(100)
		   ,@field_name nvarchar(100)
		   ,@idsapf int
		   ,@userinsert nvarchar(10)
		   ,@sap_scriptcheck nvarchar(4000)
          
AS
 
INSERT INTO dabarc.t_scriptSapData
           (active
            ,tablename
			,fieldname
			,idsapf
			,dateinsert
			,userinsert
			,sap_scriptcheck)
			
     VALUES
           (0
           ,@table_name
           ,@field_name
           ,@idsapf
           ,GETDATE()
           ,@userinsert
           ,@sap_scriptcheck)
