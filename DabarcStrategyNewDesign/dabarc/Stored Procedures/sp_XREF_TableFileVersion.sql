CREATE PROCEDURE dabarc.sp_XREF_TableFileVersion(@sType NCHAR(1),@iIdDB INT, @IdTable INT) AS 

DECLARE @NextVersion VARCHAR(6)

SELECT @NextVersion = CAST((ISNULL(MAX(version),0) + 1) AS NCHAR(3))   FROM dabarc.t_XREF_REP
WHERE type_bd = @sType 
AND bdXref_id = @iIdDB And tblXref_id = @IdTable 


SET @NextVersion = '000' + LTRIM(@NextVersion)
SELECT  'V' + SUBSTRING(@NextVersion,LEN(LTRIM(@NextVersion)) - 2 ,3) AS MaxCero
