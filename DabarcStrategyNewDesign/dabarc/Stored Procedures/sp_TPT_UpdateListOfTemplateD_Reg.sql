CREATE PROCEDURE  [dabarc].[sp_TPT_UpdateListOfTemplateD_Reg]	
	(	
	@platilla_id	INT,
	@tablename		VARCHAR(100),--cambio
	@tableesquema	VARCHAR(30),
	@registered		INT,
	@register_user	NVARCHAR(15)
	)
	
AS
BEGIN
SET NOCOUNT ON;
DECLARE @add_data		BIT
DECLARE @PlantillaD_id	INT

SELECT @add_data = add_data 
FROM t_PlantillaH 
WHERE plantilla_id = @platilla_id
    
IF (@registered = 1)
BEGIN	
	IF (SELECT COUNT(*) FROM t_PlantillaD WHERE plantilla_id = @platilla_id AND RTRIM(table_name) = RTRIM(@tablename) AND UPPER(RTRIM(table_esquema)) = UPPER(RTRIM(@tableesquema))) > 0
	BEGIN
	   --  RAISERROR('La tabla ya existe.', 16, 1);
	   RAISERROR (50043,16, 1,'','') 
	   RETURN;
	END
	
    INSERT INTO t_PlantillaD(plantilla_id,table_name,table_esquema,create_date,register_user,active) 
    VALUES	(@platilla_id,RTRIM(@tablename),RTRIM(@tableesquema), GETDATE(),@register_user,1)
  
   --Verificamos y es un proceso de agregación de datos   
    SELECT @PlantillaD_id = @@IDENTITY 
    
    If (@add_data = 1) 
		EXECUTE sp_TPT_UpdateAppendDataOfTable @PlantillaD_id, 1
END
ELSE
BEGIN
	 DELETE FROM t_PlantillaC 
	 WHERE plantillad_id IN (
			SELECT plantillad_id 
			FROM dabarc.t_PlantillaD 
			WHERE plantilla_id = @platilla_id AND RTRIM(table_name) = RTRIM(@tablename)
			)	
	 
	 DELETE FROM dabarc.t_PlantillaD 
	  WHERE plantilla_id = @platilla_id 
		AND RTRIM(table_name) = RTRIM(@tablename)
		AND RTRIM(table_esquema) = RTRIM(@tableesquema)
END
--Calculamos los porcentajes de la tablas
EXECUTE [dabarc].[sp_TPT_UpdatePorc_equalOfPlantilla] @platilla_id
END
