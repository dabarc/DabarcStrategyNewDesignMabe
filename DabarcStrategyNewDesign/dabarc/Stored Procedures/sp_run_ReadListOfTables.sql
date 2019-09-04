CREATE PROCEDURE [dabarc].[sp_run_ReadListOfTables] @database_id INT, @tabType VARCHAR(100) AS	

IF @tabType = 'BDF'

SELECT 
	tab.table_id AS Id,
	tab.name as Name
FROM dabarc.vw_Active_TABLE tab inner join dabarc.vw_Active_DB db
ON tab.database_id = db.database_id
WHERE   tab.Type_Table IN ('TFF') AND tab.database_id = @database_id and db.Type_Table = @tabType

IF @tabType = 'BDM'

SELECT tab.table_id AS Id,
       tab.name AS Name  
FROM    dabarc.vw_Active_TABLE tab inner join dabarc.vw_Active_DB db
ON tab.database_id = db.database_id
where   tab.Type_Table IN ('TDM') AND db.database_id = @database_id and db.Type_Table = @tabType
UNION
SELECT  t.table_id, t.name  
FROM    dabarc.vw_Active_TABLE t 
   INNER JOIN dabarc.vw_Active_TABLE t2 inner join dabarc.vw_Active_DB db
ON t2.database_id = db.database_id ON t.tdm_id = t2.table_id
   AND t.Type_Table = 'TFM' AND t2.Type_Table = 'TDM' AND t2.database_id = @database_id and db.Type_Table = @tabType
