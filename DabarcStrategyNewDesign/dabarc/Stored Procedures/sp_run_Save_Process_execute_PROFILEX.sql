CREATE PROCEDURE [dabarc].[sp_run_Save_Process_execute_PROFILEX] 
(
   @path_type		nvarchar(100), -- (TFF / TDM / TFM) o (BDF / BDM)
   @path_id			int, -- Id base de datos 
   @isdb			int,
   @execute_user	nvarchar(15), -- Usuario que Ejecuta
   @ppath_unickey	nvarchar(80)
)AS

 DECLARE @path_id2 INT
 
 IF (@isdb = 0)
 BEGIN
   EXECUTE [dabarc].[sp_run_Save_Process_execute_PROFILE] @path_type, @path_id, 0, @execute_user, @ppath_unickey
 END 
 ELSE
 BEGIN
   IF (RTRIM(@path_type) = 'BDF')
   BEGIN
   
        DECLARE tbl_cursor CURSOR FOR   
  
			SELECT  table_id
			FROM    dabarc.t_TFF
			WHERE   database_id = @path_id
    
    OPEN tbl_cursor  
    FETCH NEXT FROM tbl_cursor INTO @path_id2  
    WHILE @@FETCH_STATUS = 0  
    BEGIN  
          
          EXECUTE [dabarc].[sp_run_Save_Process_execute_PROFILE] 'TFF', 
																 @path_id2, 
																 0, 
																 @execute_user, 
																 @ppath_unickey
 
 
        FETCH NEXT FROM tbl_cursor INTO @path_id2  
        END  
  
    CLOSE tbl_cursor  
    DEALLOCATE tbl_cursor 
    
   END
 END
