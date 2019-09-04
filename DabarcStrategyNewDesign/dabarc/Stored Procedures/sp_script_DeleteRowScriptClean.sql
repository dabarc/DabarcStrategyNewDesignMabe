CREATE PROCEDURE [dabarc].sp_script_DeleteRowScriptClean 
					@id_Script INT			
AS

	DELETE FROM [dabarc].[t_scriptInfcleanData1]
      WHERE idsinfom = @id_Script
