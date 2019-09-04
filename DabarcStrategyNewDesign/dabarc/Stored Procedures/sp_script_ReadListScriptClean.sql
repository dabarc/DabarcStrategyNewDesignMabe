 CREATE PROCEDURE dabarc.sp_script_ReadListScriptClean  AS
SET NOCOUNT ON;
SELECT idsinfo
      ,topic
      ,name_information
      ,description
      ,script
  FROM dabarc.t_scriptInfclean
  ORDER BY idsinfo ASC;
