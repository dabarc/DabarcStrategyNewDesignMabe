CREATE PROCEDURE [dabarc].[sp_run_ReadListOfCatObjects] @strType CHAR(4) AS	
 
 DECLARE @strSQL NVARCHAR(250)
 
   If (@strType IS NOT NULL AND @strType = 'INTE')
  BEGIN
 SELECT 
		[Type],[sDescription],[sTable]
  FROM [dabarc].[vw_ListOfTypeObjects]
  WHERE Type <> 'INTE' ORDER BY Type ASC 
  END
  ELSE
  BEGIN
 SELECT 
		[Type],[sDescription],[sTable]
  FROM [dabarc].[vw_ListOfTypeObjects] ORDER BY Type ASC
  END
