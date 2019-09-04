
 CREATE PROCEDURE dabarc.[xsp_SAP_UpdateListOfTablaColumnas] 
 @id_campo		INT,
 @pro_usado		BIT,
 @pro_tipo		NCHAR(10),
 @pro_gd		BIT, 
 @pro_descripcion NVARCHAR(1500), 
 @user_update	NCHAR(20) AS
 
 
  UPDATE dabarc.t_sap_tabla_campos 
  SET    pro_usado	= @pro_usado,
		 pro_tipo	= @pro_tipo,
		 pro_gd		= @pro_gd,
		 pro_descripcion = @pro_descripcion,
		 user_update   = @user_update,
		 date_update	= GETDATE()
  WHERE campo_id = @id_campo
