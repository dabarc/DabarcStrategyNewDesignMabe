
CREATE PROCEDURE [dabarc].[sp_TPT_UpdateAppendDataOfTable] 
@PlantillaDId INT, 
@bolActive BIT 
AS
BEGIN
SET NOCOUNT ON ;

DECLARE @IdPlantillaH INT
DECLARE @IdDB		INT
DECLARE @IdTbl		INT
DECLARE @NameDb	NVARCHAR(80)
DECLARE @NameTbl	NVARCHAR(80)
DECLARE @Where		NVARCHAR(1000)
DECLARE @sql		NVARCHAR(500)
IF (@bolActive = 0)
	BEGIN
	  UPDATE dabarc.t_PlantillaD
	  SET	 add_data = 0, 
			 add_table = null,
			 add_message = null
	  WHERE	 plantillad_id = @PlantillaDId
	END
 
ELSE
	BEGIN
	    SELECT	@NameDb			= h.sql_database, 
				@NameTbl		= 'TFF_' + RTRIM(d.table_name),
				@IdPlantillaH	= h.plantilla_id,
				@Where			= ISNULL(h.add_where,'')
		FROM	dabarc.t_PlantillaH h
				INNER JOIN t_PlantillaD d ON h.plantilla_id = d.plantilla_id
		WHERE plantillad_id = @PlantillaDId
		
		 --------------------------------------------------------------------------------------------------------------------------------------------
		 --- Se valida que exista la base de datos y tabla destino 
		 --------------------------------------------------------------------------------------------------------------------------------------------
		 SET @sql = 'SELECT * FROM ' + RTRIM(UPPER(@NameDb)) + '.dbo.' + RTRIM(UPPER(@NameTbl))
		 EXECUTE(@sql)
		 --IF(SELECT COUNT(*) FROM dabarc.t_BDF f
		 --		INNER JOIN dabarc.t_TFF t ON f.database_id = t.database_id
		 --	  WHERE RTRIM(UPPER(f.name)) = RTRIM(UPPER(@NameDb)) AND  RTRIM(UPPER(t.name)) = RTRIM(UPPER(@NameTbl))) = 0
		 IF (@@ERROR <> 0)
		  BEGIN
			UPDATE	dabarc.t_PlantillaD 
			SET		add_data	= 0, 
							add_table	= 'Error ' + @NameTbl, 
							add_message = '¡No se encontró la DB o tabla destino.!'
		    WHERE		plantillad_id = @PlantillaDId
		    RETURN;
		  END
	      UPDATE	dabarc.t_PlantillaD 		 
		   SET		add_data	= 1, 
					add_table	= @NameTbl, 
					add_message = null
		   WHERE	plantillad_id = @PlantillaDId   
	END 
END
