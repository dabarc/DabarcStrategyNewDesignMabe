
CREATE PROCEDURE [dabarc].[sp_XREF_ReadLisOfEquiv] @xref_id INT 

AS
SET NOCOUNT ON; 
SELECT xequi_id
      ,nameColEx
      ,typeColEx
      ,tblCol
      ,tblColType
      ,tblColSize
      ,tblColPrecision
      ,tblColNull
      ,accion
      ,status
      ,user_registered
      ,registered_user
  FROM [dabarc].[t_XREF_Equiv]
  WHERE xref_id = @xref_id
  ORDER BY xequi_id ASC;
