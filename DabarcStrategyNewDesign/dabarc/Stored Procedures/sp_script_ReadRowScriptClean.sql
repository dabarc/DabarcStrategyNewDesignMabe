CREATE PROCEDURE [dabarc].sp_script_ReadRowScriptClean 
					@id_Script INT			
AS

	SELECT script_final
	 FROM [dabarc].[t_scriptInfcleanData1]
      WHERE idsinfom = @id_Script
