CREATE PROCEDURE [dabarc].[sp_script_ReadListOfScriptConf]
		@TABLE_NAME VARCHAR(100)
		
AS

SELECT [idsapf]
      ,[sap_table]
      ,[sap_field]
      ,[sap_type]
      ,[sap_checktable]
      ,[sap_scriptcheck]
FROM [dabarc].[t_scriptSap]
WHERE [sap_table] LIKE '%' + @TABLE_NAME + '%'
