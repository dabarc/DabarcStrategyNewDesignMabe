CREATE PROCEDURE [dabarc].[sp_asp_Treeview_Idioma_Equi] @strEqui  NVARCHAR(50) OUTPUT AS

 DECLARE @strLNG NVARCHAR(15)
 											 
 SELECT @strLNG = @@LANGUAGE
 --SELECT @strLNG
 
 SELECT @strEqui = ISNULL(asp_traduction,@strEqui) FROM dabarc.asp_InfoTreeview_LNG WHERE UPPER(RTRIM(asp_lng)) = @strLNG AND UPPER(RTRIM(asp_text)) = @strEqui
