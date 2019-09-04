 
 CREATE PROCEDURE [dabarc].[sp_script_DeleteListScriptDuplicate] @groupkey  NCHAR(12) AS
 
 
 DELETE FROM dabarc.t_scriptDuplicate WHERE groupkey = @groupkey
