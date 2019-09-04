CREATE PROCEDURE [dabarc].[sp_TPT_UpdateListOfTablesAddCol] @PlantillaD_Id INT,
														 @Nombre_Col NVARCHAR(60),
														 @Type	NVARCHAR(60),
														 @Size	INT,
														 @Precision	INT,
														 @Scale INT,
														 @IsNull BIT,
														 @register_user  nvarchar (15)
AS 	
BEGIN 
	SET NOCOUNT ON;

	IF (@Size) > 4000
	BEGIN
		SET @Size = 4000
	END

	 IF (SELECT COUNT(*) FROM dabarc.t_PlantillaC 
				WHERE plantillad_id = @PlantillaD_Id AND UPPER(pl_NameCol) = UPPER(@Nombre_Col)) > 0
		 BEGIN
			UPDATE 	dabarc.t_PlantillaC
			SET		pl_typeOdbc = @Type,
					pl_size = @Size,
					pl_precision = @Precision,
					pl_scale = @Scale,
					pl_isnull = @IsNull,
					create_date = GETDATE(),
					register_user = @register_user,
					active = 1,
					last_status = ''
			WHERE	plantillad_id = @PlantillaD_Id AND UPPER(pl_NameCol) = UPPER(@Nombre_Col)
		 END
	 ELSE
	 BEGIN
		INSERT INTO dabarc.t_PlantillaC
			   (plantillad_id
			   ,pl_NameCol
			   ,pl_typeOdbc
			   ,pl_size
			   ,pl_precision
			   ,create_date
			   ,register_user
			   ,active
			   ,last_status
			   ,pl_isnull
			   ,pl_scale)
		 VALUES
			   (@PlantillaD_Id
			   ,@Nombre_Col
			   ,@Type
			   ,@Size
			   ,@Precision
			   ,GETDATE()
			   ,@register_user
			   ,1
			   ,''
			   ,@IsNull
			   ,@Scale)
	 END
 
	 --Actualizamos el porcentaje de columnas modificadas
	 EXECUTE dabarc.sp_TPT_UpdatePorc_equalOfTable @PlantillaD_Id
END
