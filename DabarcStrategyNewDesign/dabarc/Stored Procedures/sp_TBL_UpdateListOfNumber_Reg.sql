CREATE PROCEDURE  [dabarc].[sp_TBL_UpdateListOfNumber_Reg]	
		@TypeOfDB varchar(5),	
		@database_id int,
		@register_user nvarchar(100)
AS
BEGIN 
	SET NOCOUNT ON;
	DECLARE @register_date datetime = GETDATE()
----------------------------------------------------------------
-- Modificamos el Status de la tablas
----------------------------------------------------------------

 IF (RTRIM(@TypeOfDB) = 'DBF')
 BEGIN
	DECLARE @tff_count int;
	SET @tff_count =  (SELECT COUNT(*) FROM dabarc.t_TFF  WHERE database_id = @database_id and registered = 1);
	DECLARE @ssis_count int;
	SET @ssis_count = (SELECT COUNT(*) FROM dabarc.t_SSIS  WHERE database_id = @database_id and registered = 1);
	
	UPDATE dabarc.t_BDF
	SET  tables_number  = @tff_count,
		 ssis_number    = @ssis_count,
		 modify_user	= @register_user,
		 modify_date	= @register_date
	WHERE database_id = @database_id
  END
  
 IF (RTRIM(@TypeOfDB) = 'DBM')
 BEGIN
	
	DECLARE @table_count int;
	SET @tff_count =  (SELECT COUNT(*) FROM dabarc.t_TDM  WHERE database_id = @database_id and registered = 1);
	DECLARE @rules_count int;
	SET @rules_count = (SELECT COUNT(*) FROM dabarc.t_RDM  WHERE table_id in (select table_id from dabarc.t_TDM where database_id =  @database_id) and registered = 1);
	DECLARE @reports_count int;
	SET @reports_count = (SELECT COUNT(*) FROM dabarc.t_IDM  WHERE table_id in (select table_id from dabarc.t_TDM where database_id =  @database_id) and registered = 1);
	
	UPDATE dabarc.t_BDM
	SET    tables_number  = @table_count,
		   ssis_number    = 0,
		   reports_number = @rules_count,
		   rules_number   = @reports_count,
		   modify_user	  = @register_user,
		   modify_date	  = @register_date
    WHERE database_id = @database_id
  END
END
