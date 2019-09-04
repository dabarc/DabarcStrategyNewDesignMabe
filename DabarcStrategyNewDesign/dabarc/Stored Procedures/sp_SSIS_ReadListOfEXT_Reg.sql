CREATE PROCEDURE [dabarc].[sp_SSIS_ReadListOfEXT_Reg] @IsRegister INT, @database_id INT AS

--EXEC [dabarc].[sp_SSIS_ReadListOfEXT_Reg] 1, 4

-----------------------------------------------------------------------
-- Tabla Interfaz de Trabajo
-----------------------------------------------------------------------

CREATE TABLE #t_Objeto(
Object_id	int NULL,
name	nvarchar(128) NULL,
description nvarchar(256) NULL,
path	nvarchar(1000) NULL,
type nvarchar(10) NULL)


-----------------------------------------------------------------------
-- Carga de tabla Interfaz
-----------------------------------------------------------------------
IF (@IsRegister = 0)
BEGIN
INSERT INTO #t_Objeto	
SELECT ssis_id
,name
,description
,path
,'SSIS' as type	
FROM t_SSIS
INNER JOIN (
SELECT database_id AS id, '/' + REPLACE(name, '(No Existe)', '') AS db_path 
FROM [dabarc].[t_BDF]
WHERE database_id = @database_id
) tmp ON tmp.db_path = path
WHERE	registered = 0 AND (name NOT LIKE 'SSIS[_]TDM[_]%') AND table_id IS NULL -- AND name NOT LIKE 'SSIS[_]TFM[_]%'
END
ELSE
BEGIN
INSERT INTO #t_Objeto	
SELECT ssis_id
,name
,description
,path
,'SSIS' as type	
FROM t_SSIS
WHERE	registered = 1 and database_id = @database_id and (name NOT LIKE 'SSIS[_]TDM[_]%') AND table_id IS NULL -- AND name NOT LIKE 'SSIS[_]TFM[_]%'
END

-----------------------------------------------------------------------
-- Retorno de Valores
-----------------------------------------------------------------------

SELECT	Object_id
,name
,description
,path
,type 
FROM #t_Objeto
ORDER BY name
