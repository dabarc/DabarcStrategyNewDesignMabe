CREATE PROCEDURE [dabarc].[sp_INT_ReadListOfObjectsN]
(
	@interface_id int
)
AS

CREATE TABLE #tempMaxId (execute_unickey nvarchar(40),object_id int,interface_id int)

	INSERT INTO #tempMaxId
	SELECT MAX(execute_unickey)as llave_ejecucion,execute_object_id, interface_id
	FROM dabarc.t_LogInterfacesN
	GROUP BY execute_object_id,interface_id

    SELECT iob.object_id
			,inn.name
			,iob.description
			,iob.active
			,iob.priority
			,iob.modify_date
			,loi.execute_message
			,loi.execute_date
   FROM dabarc.t_InterfacesObjectsN iob
   LEFT JOIN dabarc.vw_Active_Objects inn ON dabarc.fnt_ObjectIdAndType(iob.int_IdObj,iob.object_type) = inn.object_id 
   LEFT JOIN #tempMaxId tem on iob.int_IdObj = tem.object_id and iob.interface_id = tem.interface_id
   LEFT JOIN dabarc.t_LogInterfacesN loi ON loi.execute_unickey = tem.execute_unickey
   WHERE iob.interface_id = @interface_id
   ORDER BY iob.active DESC, iob.priority ASC
   
RETURN
