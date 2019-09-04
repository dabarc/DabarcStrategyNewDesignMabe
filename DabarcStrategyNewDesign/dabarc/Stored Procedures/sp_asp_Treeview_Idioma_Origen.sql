
CREATE PROCEDURE [dabarc].[sp_asp_Treeview_Idioma_Origen] @strOrigen  NVARCHAR(50) OUTPUT AS

 DECLARE @strLNG NVARCHAR(15)
 											 
 SELECT @strLNG = @@LANGUAGE
 --SELECT @strLNG
 
 SELECT @strOrigen = ISNULL(asp_traduction,@strOrigen) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strOrigen
