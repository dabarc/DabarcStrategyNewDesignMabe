CREATE PROCEDURE [dabarc].[sp_REC_getStructForBDC]
@script_id INT
AS
BEGIN
SET NOCOUNT ON;
 ----------------------------------------------------------------------------------------------------------------
 -- Creamos la tabla de retorno
 ----------------------------------------------------------------------------------------------------------------
  CREATE TABLE #tmpResult(OrderS		INT,
						  OrderF		INT,
						  ColLetter		CHAR(1),
						  ColName		NVARCHAR(50),
						  ColView		NVARCHAR(100) NULL,
						  ColType		CHAR(20) NULL,
						  ColNoScreen	CHAR(4) NULL,
						  ColNoField	INT,
						  TypeCol		CHAR(4) NULL)
 ----------------------------------------------------------------------------------------------------------------
 -- Insertamos datos
 ----------------------------------------------------------------------------------------------------------------
 INSERT INTO #tmpResult
			SELECT	0,0,'T','Trx Code',script_transcode,null, null, null, null
			FROM	t_recording_script
			WHERE	script_id = @script_id

 INSERT INTO #tmpResult
			SELECT  screen_position,
					0,
					'S',
					screen_sapname,
					null,RTRIM(screen_sapno) + 'P' + CAST(screen_position AS CHAR(10)),
					screen_sapno,NoFields,
					s.screen_typestruc
			FROM	t_recording_screen s
					INNER JOIN (
						SELECT screen_id, COUNT(screen_id)  as NoFields
						FROM t_recording_fields
						GROUP BY screen_id) i ON s.screen_id = i.screen_id
			WHERE	script_id = @script_id
			ORDER BY screen_position ASC

 INSERT INTO #tmpResult
			SELECT	 screen_position,
				     f.field_id,'F',
					 field_SAPname,
					 RTRIM(SUBSTRING(field_fieldview,1,50)),
					 field_typeentry,null,null,s.screen_typestruc
			FROM	 t_recording_fields f
				INNER JOIN t_recording_screen s ON f.screen_id = s.screen_id
			WHERE	 script_id = @script_id
			ORDER BY screen_position ASC , f.field_id ASC;
 ----------------------------------------------------------------------------------------------------------------
 -- Regresamos la structura general
 ----------------------------------------------------------------------------------------------------------------
	SELECT ColLetter,
		   ColName,
		   ColView,
		   ColType,
		   ColNoScreen,
		   ColNoField,
		   TypeCol
    FROM   #tmpResult
    ORDER BY OrderS, OrderF;
END
