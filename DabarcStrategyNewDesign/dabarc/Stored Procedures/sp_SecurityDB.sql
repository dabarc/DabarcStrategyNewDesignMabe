CREATE PROCEDURE [dabarc].[sp_SecurityDB] 
			  @username		nvarchar(100)
			 ,@actionType nvarchar(10)
             ,@IdDB	int			  ---  1,2,3,4	
AS
	---------------------------------------------------------------------------------------------------------
	---- Verifica si la base de datos puede o no ejecutarse
	---- Norma Jiménez
	---- 17-01-2014
	---------------------------------------------------------------------------------------------------------
	
	
	----------------------------------------------------------------------------
    -- Crea tabla temporal
    ----------------------------------------------------------------------------
	DECLARE @Perm BIT
	SET @Perm = 0;
	
	CREATE TABLE #TEMP(
	          id_User int
			  ,User_NameShort nvarchar(10)
			  ,dataName nvarchar(100)
			  ,Per_Exec bit
			  ,Per_Insert bit 
			  ,Per_Modify bit 
			  ,Per_Delete bit  )
			  
	INSERT INTO #TEMP SELECT Id_User,
			  User_NameShort
			  ,NULL
			  ,1
			  ,1
			  ,1
			  ,1
	      FROM dabarc.t_User
		  WHERE User_NameShort = @username
	
	
	UPDATE t
		   SET
			t.Per_Exec = exe,
			t.Per_Insert = ins,
			t.Per_Modify = upd,
			t.Per_Delete = del,
			t.dataName = dbName
		   FROM #TEMP t
			INNER JOIN (SELECT t.id_User, RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name))) as dbName,
			   case when sum(cast(rp.Per_Execute as int)) > 0 then 1 else 0 end as exe,
			   case when sum(cast(rp.Per_Insert as int)) > 0 then 1 else 0 end as ins,
			   case when sum(cast(rp.Per_Modify as int)) > 0 then 1 else 0 end as upd,
			   case when sum(cast(rp.Per_Delete as int)) > 0 then 1 else 0 end as del,
			    RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name))) AS gf
		   FROM #TEMP t 
			INNER JOIN dabarc.t_User_Permissions  p ON t.id_User  = p.Id_User 	
			INNER JOIN dabarc.t_User_RolPermissions rp ON rp.Id_Rol = p.Id_Rol 
		  WHERE rp.Active = 1 AND rp.Per_Id = @IdDB
		  GROUP BY t.id_User, RTRIM(SUBSTRING(rp.Per_Name,CHARINDEX('\',rp.Per_Name)+1,LEN(rp.Per_Name)))) p ON p.id_User = t.id_User

    
    IF (@actionType = 'EXECUTE')
    
     IF (SELECT COUNT(*) from #TEMP WHERE Per_Exec = 1) = 0
     BEGIN
	 
	 
	 
	 
    --   RAISERROR('No tiene permisos de ejecución.', 16, 1);
	   RAISERROR (50056, 16, 1, '','') 
	   SET @Perm = 1;
	   RETURN @Perm;
	END
     
     
     IF (@actionType = 'UPDATE')
    
    
     IF (SELECT COUNT(*) from #TEMP WHERE Per_Modify = 1) = 0
     BEGIN
	--   RAISERROR('No tiene permisos para realizar cambios.', 16, 1);
	 RAISERROR (50059,16, 1, '','') 
	   SET @Perm = 1;
	   RETURN @Perm;
	END
	
	IF (@actionType = 'DELETE')
    
    
    IF (SELECT COUNT(*) from #TEMP WHERE Per_Delete = 1) = 0
     BEGIN
	--   RAISERROR('No tiene permisos para eliminar la BD.', 16, 1);
	   RAISERROR (50058,16,1, '','') 
	   SET @Perm = 1;
	   RETURN @Perm;
	END
	
	IF (@actionType = 'INSERT')
    
     IF (SELECT COUNT(*) from #TEMP WHERE Per_Insert = 1) = 0
     BEGIN
	  -- RAISERROR('No tiene permisos para agregar BD.', 16, 1);
	   RAISERROR (50057,16, 1,'','') 
	   SET @Perm = 1;
	   RETURN @Perm;
	END
