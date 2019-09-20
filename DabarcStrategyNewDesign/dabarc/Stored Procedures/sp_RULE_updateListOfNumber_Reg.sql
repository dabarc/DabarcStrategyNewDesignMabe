CREATE PROCEDURE  [dabarc].[sp_RULE_updateListOfNumber_Reg] 	
		@TypeOfTBL		varchar(5),	
		@table_id	int,
		@register_user	nvarchar(50)
AS
 	DECLARE @register_date datetime = GETDATE()
----------------------------------------------------------------
-- Modificamos el Status de la tablas
----------------------------------------------------------------

 IF (RTRIM(@TypeOfTBL) = 'TFF')
 BEGIN
    DECLARE @rule_count INT;
	SET  @rule_count = (SELECT COUNT(*) FROM t_RFF WHERE table_id = @table_id and registered = 1);
	UPDATE dabarc.t_TFF
	SET    rules_number   = @rule_count,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE table_id = @table_id;
 END 

 IF (RTRIM(@TypeOfTBL) = 'TDM')
 BEGIN
 	DECLARE @rule_tdm_count INT;
	SET  @rule_tdm_count = (SELECT COUNT(*) FROM t_RDM WHERE table_id = @table_id and registered = 1);
	UPDATE t_TDM
	SET    rules_number   = @rule_tdm_count,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE table_id = @table_id;
 END 

 IF (RTRIM(@TypeOfTBL) = 'TFM')
 BEGIN
    DECLARE @rule_tfm_count INT;
	SET  @rule_tfm_count = (SELECT COUNT(*) FROM t_RFM WHERE table_id = @table_id and registered = 1);
 	UPDATE t_TFM
	SET    rules_number   = @rule_tfm_count,
		   modify_user	= @register_user,
		   modify_date	= @register_date
	WHERE table_id = @table_id;
 END
