CREATE PROCEDURE [dabarc].[sp_log_InExecuteUpdateTable]
                @row_id            INT,
                @name_col          NCHAR(15),
                @name_table        NCHAR(50),
                @int_status        INT,
                @execute_user      NVARCHAR(15),
                @execute_date      DATETIME,
                @execute_time      NVARCHAR(25)
           

AS
BEGIN
SET NOCOUNT ON;
    -- Programado   (usuario, estado = 1)
        -- En ejecución (usuario, fecha ejecución, estado = 2)
        -- Correcto     (usuario, fecha ejecución, Tiempo, Afectados, estado = 3)
        ---------------------------------------------------------------------------------------------------------------------
        --- Declaraciones de variables
        ---------------------------------------------------------------------------------------------------------------------    
    DECLARE @sqlstr     NVARCHAR(1000),
            @str_date   NVARCHAR(40);

    SET @sqlstr   = 'UPDATE  dabarc.' + RTRIM(@name_table) + ''       
    SET @str_date = CONVERT(nvarchar(30), @execute_date, 103)
    SET @str_date = CAST(YEAR(@execute_date) AS CHAR(4)) + RIGHT('00' + RTRIM(CAST(MONTH(@execute_date) AS CHAR(2))),2) + RIGHT('00' + RTRIM(CAST(DAY(@execute_date) AS CHAR(2))),2)
    SET @str_date = @str_date + ' ' + RTRIM(CONVERT(nvarchar(30), @execute_date, 108))
    
    IF (@int_status = 1)
    BEGIN
                        SET @sqlstr = @sqlstr + ' SET execute_date = ''' + @str_date + ''', 
                                                                                                        execute_user = ''' + @execute_user + ''', 
                                                                                                        execute_time = ''' + @execute_time + ''', 
                                                                                                        last_error = ''Se ejecutó correctamente'',
                                                                                                        status = 1'
        END
            
    IF (@int_status = 2)
    BEGIN
                                        SET @sqlstr = @sqlstr + ' SET execute_date = ''' + @str_date + ''', 
                                                                                                        execute_time = ''' + @execute_time + ''', 
                                                                                                        last_error = ''Se ejecutó correctamente'',
                                                                                                        status = 2'
        END
                           
    IF (@int_status = 3)
    BEGIN
                                        SET @sqlstr = @sqlstr + ' SET  execute_time = ''' + @execute_time + ''', 
                                                                                                        last_error = ''Ejecución satisfactoria'',
                                                                                                        status = 3'
        END
                           
    SET @sqlstr = @sqlstr + ' WHERE ' + @name_col + ' = ' + CONVERT(nchar, @row_id)                                          
    EXEC(@sqlstr);    
    RETURN
END;
