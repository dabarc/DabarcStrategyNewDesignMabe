
 CREATE VIEW [dabarc].[vw_SapColumns] AS
 
  SELECT SapCol_id, 
       RTRIM(s.SapTable_name) + '-' + RTRIM(c.SapCol_Name) AS NameKey
      ,SapCol_Position As Position
      ,SapCol_Name AS Name
      ,SapCol_IsKey As [Key]
      ,SapCol_DataElement AS DataElement 
      ,SapCol_Domain As Domain
      ,SapCol_Datatype AS Datatype
      ,SapCol_Length AS [Length]
      ,SapCol_Decimal AS [Decimal]
      ,SapCol_Description AS [Description]
      ,SapCol_Spanish As Descripcion
      ,SapCol_TableCheck AS TableCheck
  FROM   dabarc.t_SapCatTable s
	INNER JOIN dabarc.t_SapCatColumns c ON s.SapTable_id = c.SapTable_id
