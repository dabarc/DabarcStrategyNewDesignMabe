CREATE PROCEDURE  [dabarc].[sp_SSIS_UpdateListOfSSIS_Reg_ByName] 
	@table_id		int,
	@ssis_name		nvarchar(30),
	@register_user	nvarchar(15)
AS
BEGIN
SET NOCOUNT ON;
 
 
 	DECLARE @register_date	DATETIME,
			@strTable		VARCHAR(15),
			@db_name		VARCHAR(30),
			@Int_Index		INT
 
	---------------------------------------------------------------------------------------------
	--- Validamos los Objetos
	---------------------------------------------------------------------------------------------
	
	IF (SELECT COUNT(*) FROM t_SSIS WHERE table_id = @table_id AND UPPER(RTRIM(name)) = UPPER(RTRIM(@ssis_name))) > 0
    BEGIN
       --RAISERROR('Este SSIS ya está registrado.', 16, 1);
	   RAISERROR (50024,16,1,'','');
	   RETURN;
    END;
    
	---------------------------------------------------------------------------------------------
	--- Insertamos los Objetos
	---------------------------------------------------------------------------------------------
	
	
	with ChildFolders 
	as
	(    
		select	PARENT.parentfolderid, 
				PARENT.folderid, 
				PARENT.foldername, 
				cast('' as sysname) as RootFolder, 
				cast(PARENT.foldername as varchar(max)) as FullPath, 
				0 as Lvl 
		   
		from msdb.dbo.sysssispackagefolders PARENT 
		where PARENT.parentfolderid is null		  
		UNION ALL		   
		select	CHILD.parentfolderid, 
				CHILD.folderid, 
				CHILD.foldername, 
				case ChildFolders.Lvl 
					when 0 then CHILD.foldername           
					else ChildFolders.RootFolder 
				end as RootFolder, 
				cast(ChildFolders.FullPath + '/' + CHILD.foldername as varchar(max)) as FullPath, 
				ChildFolders.Lvl + 1 as Lvl 
		from msdb.dbo.sysssispackagefolders CHILD     
			inner join ChildFolders on ChildFolders.folderid = CHILD.parentfolderid 
	)
	INSERT INTO t_SSIS (path, name, description, create_date, table_id)
	select F.FullPath, P.name, P.description, P.createdate, 0
	from ChildFolders F 
		inner join msdb.dbo.sysssispackages P on P.folderid = F.folderid 
	WHERE UPPER(RTRIM(P.name)) = UPPER(RTRIM(@ssis_name)) AND (name NOT IN
							(SELECT        name
	                         FROM            t_SSIS AS t_SSIS_1))
	
	--(name LIKE 'SSIS[_]'+ @table_type +'[_]%') AND (name NOT IN
	--						(SELECT        name
	--                      FROM            t_SSIS AS t_SSIS_1))
    
    
	--------------------------------------------------------------
	-- Registramos la tabla
	--------------------------------------------------------------	
	
	SELECT	@Int_Index = ssis_id  
	FROM	t_SSIS 
	WHERE	table_id = @table_id 
			AND UPPER(RTRIM(name)) = UPPER(RTRIM(@ssis_name))
	
    
    IF (ISNULL(@Int_Index,0) = 0) 
		BEGIN
		--  RAISERROR('El SSIS no se encontró en la base de datos.', 16, 1);
		RAISERROR (50012,16,1,'','');
		END
	ELSE
		BEGIN
		 EXECUTE sp_SSIS_UpdateListOfSSIS_Reg @Int_Index,@table_id,1,@register_user
		END
END;
