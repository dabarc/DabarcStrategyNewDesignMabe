CREATE PROCEDURE [dabarc].[sp_run_ReadListOfBD] AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @strSQL NVARCHAR(250)
 
 SELECT [objectid] AS Id,
        name AS [Name]
 FROM dabarc.vw_Active_Objects 
 WHERE RTRIM(object_type) 
 IN('BDF','BDM')  
 ORDER BY [Name] ASC;
END
