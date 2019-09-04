CREATE PROCEDURE [dabarc].[sp_script_InsertRowOfDuplicate] 
		    @table_name nvarchar(50)
		   ,@fields_name nchar(4000)
	          
AS
DECLARE @path_unickey NCHAR(12)

SELECT	@path_unickey	= VALOR_INTER FROM dabarc.fnt_get_KeyUnic()
 
INSERT INTO dabarc.t_scriptDuplicate
           (groupkey
			,tablename
			,fieldsname
			,datecreate
			,error)
     VALUES
           (@path_unickey
           ,@table_name
           ,@fields_name
           ,GETDATE()
           ,'')
