
CREATE PROCEDURE [dabarc].sp_script_ReadListTableSAP @sap_table NVARCHAR(50) AS
 
SELECT [idsapf]
      ,[sap_table]
      ,[sap_field]
      ,[sap_key]
      ,[sap_mandatory]
      ,[sap_type]
      ,[sap_length]
      ,[sap_decimal]
      ,[sap_tablenameE]
      ,[sap_tablenameS]
      ,[sap_fieldnameE]
      ,[sap_fieldnameS]
      ,[sap_checktable]
      ,[sap_checkfield]
      ,[user_insert]
      ,[user_date]
      ,[sap_scriptcheck]
  FROM [dabarc].[t_scriptSap]
  WHERE [sap_table] = @sap_table
