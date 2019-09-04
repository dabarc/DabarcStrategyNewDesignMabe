

 CREATE PROCEDURE dabarc.[xsp_SAP_ReadListOfFieldsOfTable] @IdTabla INT AS

	SELECT [campo_id]
		  ,[tabla_id]
		  ,[sap_campo]
		  ,[sap_valor]
		  ,[sap_tamanio]
		  ,[sap_tipo]
		  ,[sap_descripcion_es]
		  ,[sap_descripcion_in]
		  ,[pro_usado]
		  ,[pro_tipo]
		  ,[pro_gd]
		  ,[pro_descripcion]
		  ,[user_update]
		  ,[date_update]
	  FROM [dabarc].[t_sap_tabla_campos]
	  WHERE [tabla_id] = @IdTabla
