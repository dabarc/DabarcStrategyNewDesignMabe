
CREATE PROCEDURE [dabarc].[sp_INT_ReadListOfObjects_RegN]
(
	@interface_type char(6)
)
AS

  ----------------------------------------------------------------------------------------------------------------
  --- Filtro de Type
  ----------------------------------------------------------------------------------------------------------------    


  IF (@interface_type = '*')
  BEGIN
		SELECT       object_id,name 
  		FROM         dabarc.vw_Active_Objects actObj
  		ORDER BY     object_type ASC
  		
 END
 ELSE
 BEGIN
 		SELECT      object_id,name 
		FROM       dabarc.vw_Active_Objects actObj
		WHERE RTRIM(actObj.object_type)= @interface_type 
		ORDER BY    object_type ASC

 END


RETURN
