
CREATE PROCEDURE [dabarc].[sp_XREF_getListTBL] @db_id INT AS
 
SELECT table_id, name
FROM vw_Active_TABLE 
WHERE database_id = @db_id
