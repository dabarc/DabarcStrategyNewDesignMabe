
CREATE PROCEDURE [dabarc].[sp_RECc_InsertRowOfScreen]   @script_id INT,
													@screen_title NVARCHAR(200),
													@screen_position INT,
													@screen_sapname NVARCHAR(100),
													@screen_sapno NCHAR(10),
													@screen_typestruc NCHAR(10) ,
													@screen_fieldview NCHAR(30) ,
													@screen_fieldwhere NVARCHAR(100),
													@usuario_alta NVARCHAR(100) AS
													
   
		
		INSERT INTO t_recording_screen
				   (script_id
				   ,screen_title
				   ,screen_position
				   ,screen_sapname
				   ,screen_sapno
				   ,screen_typestruc
				   ,screen_fieldview
				   ,screen_fieldwhere
				   ,screen_nofields
				   ,usuario_alta
				   ,fecha_alta)
			 VALUES
				   (@script_id
				   ,@screen_title
				   ,@screen_position
				   ,@screen_sapname
				   ,@screen_sapno
				   ,@screen_typestruc
				   ,@screen_fieldview
				   ,@screen_fieldwhere
				   ,0
				   ,@usuario_alta
				   ,GETDATE())
				   
				              
--Recalculamos el numero de registros 
EXECUTE sp_REC_LoadtxtCalculateFields @script_id
