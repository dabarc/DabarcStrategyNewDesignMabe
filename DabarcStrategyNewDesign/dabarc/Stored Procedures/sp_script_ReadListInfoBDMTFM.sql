CREATE PROCEDURE [dabarc].[sp_script_ReadListInfoBDMTFM]  AS
 SET NOCOUNT ON;
  SELECT DISTINCT RTRIM(CAST(t.database_id AS CHAR(5))) + '.' + RTRIM(CAST(m.table_id AS CHAR(5))) AS 'KEY',  
			t.name + '.' + m.name AS 'NAME'
	FROM dabarc.t_BDM t
	INNER JOIN dabarc.t_TDM d ON t.database_id = d.database_id
	INNER JOIN dabarc.t_TFM m ON d.table_id = m.tdm_id 
	ORDER BY [KEY] ASC
