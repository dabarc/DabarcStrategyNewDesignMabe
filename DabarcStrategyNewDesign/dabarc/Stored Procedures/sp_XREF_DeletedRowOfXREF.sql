CREATE PROCEDURE [dabarc].[sp_XREF_DeletedRowOfXREF](
				@xref_id		int,
				@deleted_user	nvarchar(15)
 ) AS 
 
 
   ----------------------------------------------------------------------------
   -- hay que validar si no se usar en un ODBC
   ----------------------------------------------------------------------------
 
    IF (SELECT COUNT(*) FROM dabarc.t_XREF_REP WHERE xref_id = @xref_id AND delete_user IS NOT NULL) > 0
	BEGIN
	    RAISERROR('Esta referencia ya esta alimnada.', 16, 1);
	  
	  
 --RAISERROR (50023,
 --   16, -- Severity.
 --   1, -- State.
 --   '',
 --   '') -- Second substitution argument.
	  
	  
	   RETURN;
	END

   UPDATE dabarc.t_XREF_REP 
   SET delete_date	= GETDATE(), 
	delete_user		= @deleted_user
   WHERE xref_id	= @xref_id
