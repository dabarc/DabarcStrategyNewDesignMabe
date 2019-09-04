 
 CREATE PROCEDURE [dabarc].sp_script_DeleteRowScriptconfig @Id_script  INT AS
 
 
 DELETE FROM dabarc.t_scriptSapData WHERE idsapfd = @Id_script
