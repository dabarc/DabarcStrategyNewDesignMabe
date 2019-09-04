
CREATE PROCEDURE [dabarc].[sp_RECf_ReadRowOfFields] @intField_Id NVARCHAR(300) As 


	SELECT field_id
	      ,screen_id
		  ,field_SAPname
		  ,field_SAP
		  ,field_description
		  ,field_typeentry
		  ,field_fieldview
		  ,field_fieldspace
		  ,usuario_alta
		  ,fecha_alta
		  ,usuario_modifica
		  ,fecha_modifica
	FROM  t_recording_fields
	WHERE field_id = @intField_Id