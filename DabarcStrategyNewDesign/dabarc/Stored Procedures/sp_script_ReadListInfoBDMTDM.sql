
CREATE PROCEDURE [dabarc].[sp_script_ReadListInfoBDMTDM]  AS
 SET NOCOUNT ON;
  SELECT DISTINCT RTRIM(CAST(t.database_id AS CHAR(5))) + '.' + RTRIM(CAST(d.table_id AS CHAR(5))) AS 'KEY',  
			t.name + '.' + d.name  AS 'NAME'  FROM dabarc.t_BDM t
	INNER JOIN dabarc.t_TDM d ON t.database_id = d.database_id ORDER BY [KEY] ASC
