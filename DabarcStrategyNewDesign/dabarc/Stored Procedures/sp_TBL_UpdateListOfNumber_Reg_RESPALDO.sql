CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateListOfNumber_Reg_RESPALDO]	
	(
		@TypeOfDB varchar(5),	
		@database_id int,
		@register_user nvarchar(50)
	)
	
AS
	DECLARE @register_date datetime

	SET @register_date = GETDATE()

----------------------------------------------------------------
-- Modificamos el Status de la tablas
----------------------------------------------------------------

 IF (RTRIM(@TypeOfDB) = 'DBF')
 BEGIN
	UPDATE a
	SET    a.tables_number  = b.tbl_count,
		   a.ssis_number    = b.ssis_number,
		   a.reports_number = b.reports_number,
		   a.rules_number   = b.rules_number,
		   a.modify_user	= @register_user,
		   a.modify_date	= @register_date
	FROM dabarc.t_BDF a 
		INNER JOIN (
	SELECT COUNT(*)          tbl_count,
		  COALESCE(SUM(ssis_number),0)  ssis_number,
		  COALESCE(SUM(reports_number),0) reports_number, 
		  COALESCE(SUM(rules_number),0) rules_number 
     FROM dabarc.t_TFF  WHERE database_id = @database_id and registered = 1) b ON a.database_id = @database_id
  END
  
  
 IF (RTRIM(@TypeOfDB) = 'DBM')
 BEGIN
	UPDATE a
	SET    a.tables_number  = b.tbl_count,
		   a.ssis_number    = b.ssis_number,
		   a.reports_number = b.reports_number,
		   a.rules_number   = b.rules_number,
		   a.modify_user	= @register_user,
		   a.modify_date	= @register_date
	FROM dabarc.t_BDM a 
		INNER JOIN (
	SELECT COUNT(*)          tbl_count,
		   COALESCE(SUM(ssis_number),0)  ssis_number,
		   COALESCE(SUM(reports_number),0) reports_number, 
		   COALESCE(SUM(rules_number),0) rules_number 
     FROM dabarc.t_TDM  WHERE database_id = @database_id and registered = 1) b ON a.database_id = @database_id          
  END
