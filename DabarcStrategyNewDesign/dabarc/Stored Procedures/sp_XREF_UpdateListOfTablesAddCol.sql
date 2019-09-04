CREATE PROCEDURE [dabarc].[sp_XREF_UpdateListOfTablesAddCol] @xref_Id INT,
														 @nameCol   NVARCHAR(60),
														 @typeCol   NVARCHAR(60),
														 @sizeCol	INT,
														 @register_user  nvarchar (15) AS 	
														 

 IF (SELECT COUNT(*) FROM t_XREF_Equiv 
			WHERE xref_id = @xref_Id AND UPPER(nameColEx) = UPPER(@nameCol)) > 0
 BEGIN
	UPDATE 	t_XREF_Equiv
	SET		nameColEx = @typeCol,
			typeColEx = @typeCol,
			tblColSize = @sizeCol,
			registered_user = @register_user
	WHERE xref_id = @xref_Id AND UPPER(nameColEx) = UPPER(@nameCol)
 
 END
 ELSE
 BEGIN
    INSERT INTO dabarc.t_XREF_Equiv
           (xref_id
           ,nameColEx
           ,typeColEx
           ,tblColSize
           ,registered_user)
     VALUES
           (@xref_Id
           ,@nameCol
           ,@typeCol
           ,@sizeCol
           ,@register_user)
 END
