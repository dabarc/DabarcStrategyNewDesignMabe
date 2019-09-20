CREATE PROCEDURE  [dabarc].[sp_INFO_updateListOfNumber_Reg] 	
		@TypeOfTBL		varchar(5),	
		@table_id	int,
		@register_user	nvarchar(50)
AS
BEGIN 
	SET NOCOUNT ON;
 	DECLARE @register_date datetime = GETDATE() ;

----------------------------------------------------------------
-- Modificamos el Status de la tablas
----------------------------------------------------------------

 IF (RTRIM(@TypeOfTBL) = 'TFF')
 BEGIN
 	DECLARE @informes_count int;
	SET @informes_count =  (SELECT COUNT(*)  FROM dabarc.t_IFF WHERE table_id = @table_id and registered = 1 );
 	
	UPDATE dabarc.t_TFF
	SET    reports_number   = @informes_count,
		   modify_user	  = @register_user,
		   modify_date	  = @register_date
     WHERE table_id = @table_id;
 END 

 IF (RTRIM(@TypeOfTBL) = 'TDM')
 BEGIN
    DECLARE @info_nunmber int;
	SET @info_nunmber =  (SELECT COUNT(*)  FROM dabarc.t_IDM WHERE table_id = @table_id and registered = 1 );
 	UPDATE dabarc.t_TDM
	SET    reports_number = @info_nunmber,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE table_id = @table_id;
 END 

 IF (RTRIM(@TypeOfTBL) = 'TFM')
 BEGIN
 	DECLARE @informes_ifm int;
	SET @informes_ifm =  (SELECT COUNT(*)  FROM dabarc.t_IFM WHERE table_id = @table_id and registered = 1 );
	UPDATE dabarc.t_TFM
	SET    reports_number = @informes_ifm,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE table_id = @table_id
 END
 END
