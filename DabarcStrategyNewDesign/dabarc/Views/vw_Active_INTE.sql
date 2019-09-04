
CREATE VIEW [dabarc].[vw_Active_INTE] AS

	SELECT interface_id,
		  name,
		  description as short_description,
		  'INTE' As Type,	
		  'INTE' As Type_Table
   FROM t_InterfacesN i
	WHERE   active = 1
			AND [priority] > 0;
