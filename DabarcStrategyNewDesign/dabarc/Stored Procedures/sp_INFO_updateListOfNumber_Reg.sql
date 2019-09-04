CREATE PROCEDURE  [dabarc].[sp_INFO_updateListOfNumber_Reg] 	
	(
		@TypeOfTBL		varchar(5),	
		@table_id	int,
		@register_user	nvarchar(50)
	)	
AS
 
 	DECLARE @register_date datetime

	SET @register_date = GETDATE()

----------------------------------------------------------------
-- Modificamos el Status de la tablas
----------------------------------------------------------------

 IF (RTRIM(@TypeOfTBL) = 'TFF')
 BEGIN
 	UPDATE a
	SET    a.reports_number   = b.info_nunber,
		   a.modify_user	  = @register_user,
		   a.modify_date	  = @register_date
	FROM dabarc.t_TFF  a 
		INNER JOIN (
	SELECT COUNT(*)          info_nunber
     FROM dabarc.t_IFF WHERE table_id = @table_id and registered = 1) b ON a.table_id = @table_id
 END 

 
 IF (RTRIM(@TypeOfTBL) = 'TDM')
 BEGIN
 	UPDATE a
	SET    a.reports_number = b.info_nunber,
		   a.modify_user	= @register_user,
		   a.modify_date	= @register_date
	FROM dabarc.t_TDM  a 
		INNER JOIN (
	SELECT COUNT(*)          info_nunber		    
     FROM dabarc.t_IDM WHERE table_id = @table_id and registered = 1) b ON a.table_id = @table_id
 END 

 
 
 IF (RTRIM(@TypeOfTBL) = 'TFM')
 BEGIN
 	UPDATE a
	SET    a.reports_number = b.info_nunber,
		   a.modify_user	= @register_user,
		   a.modify_date	= @register_date
	FROM dabarc.t_TFM  a 
		INNER JOIN (
	SELECT COUNT(*)          info_nunber		    
     FROM dabarc.t_IFM WHERE table_id = @table_id and registered = 1) b ON a.table_id = @table_id
 END
