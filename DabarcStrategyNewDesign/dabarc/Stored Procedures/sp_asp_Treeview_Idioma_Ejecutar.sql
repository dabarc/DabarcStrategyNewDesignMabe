

CREATE PROCEDURE [dabarc].[sp_asp_Treeview_Idioma_Ejecutar] @strEjecuta  NVARCHAR(50) OUTPUT AS

 DECLARE @strLNG NVARCHAR(15)
 											 
 SELECT @strLNG = @@LANGUAGE
 --SELECT @strLNG
 
 SELECT @strEjecuta = ISNULL(asp_traduction,@strEjecuta) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strEjecuta
