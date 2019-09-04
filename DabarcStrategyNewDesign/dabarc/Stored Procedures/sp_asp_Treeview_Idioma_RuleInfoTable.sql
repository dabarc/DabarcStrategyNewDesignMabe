CREATE PROCEDURE dabarc.[sp_asp_Treeview_Idioma_RuleInfoTable] @strSSIS  NVARCHAR(50) OUTPUT,
												 @strRegla NVARCHAR(50) OUTPUT,
												 @strInfor NVARCHAR(50) OUTPUT,
												 @strTable NVARCHAR(50) OUTPUT AS

 DECLARE @strLNG NVARCHAR(15)
 											 
 SELECT @strLNG = @@LANGUAGE
 --SELECT @strLNG
 
 SELECT @strSSIS = ISNULL(asp_traduction,@strSSIS) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strSSIS
 SELECT @strRegla = ISNULL(asp_traduction,@strRegla) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strRegla
 SELECT @strInfor = ISNULL(asp_traduction,@strInfor) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strInfor
 SELECT @strTable = ISNULL(asp_traduction,@strTable) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strTable
