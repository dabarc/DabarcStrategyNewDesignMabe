CREATE PROCEDURE [dabarc].[sp_XREF_ReadLisOfOfXREF] AS 
 SET NOCOUNT ON;
 SELECT xref_id
      ,bdXref_id
      ,type_bd
      ,tblXref_id
      ,table_name
      ,filename
      ,filename_new
      ,description
      ,version
      ,file_path
      ,path_source
      ,sheet_num
      ,register_user
      ,register_date
      ,delete_user
      ,delete_date
      ,registered
  FROM t_XREF_REP
  WHERE registered = 1 AND delete_user IS NULL
  ORDER BY xref_id DESC;
