CREATE PROCEDURE [dabarc].[sp_script_ReadListScriptDuplicate]  AS
 SET NOCOUNT ON;
 SELECT groupkey
      ,tablename
      ,fieldsname
      ,datecreate
      ,error
  FROM dabarc.t_scriptDuplicate
 ORDER BY groupkey DESC;
