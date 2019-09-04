

CREATE PROCEDURE dabarc.sp_SAP_ReadListTableSAP AS

  ---------------------------------------------------------------------------------
  --- Obtenemos una consulta de la tablas tomadas para el recipiente de SAP
  --- Se limita solo a origenes de datos que no sean de tipo texto 
  ---------------------------------------------------------------------------------

	SELECT	'[' + d.driver_dbms + '] ' + o.odbc_name as odbc_name, 
			o.odbc_server, 
			o.odbc_database,
			s.sap_esquema, 
			s.sap_table, 
			s.sap_status, 
			s.sap_status_desc, 
			s.user_update 
	FROM dabarc.t_ODBC_driver d
		INNER JOIN dabarc.t_ODBC o ON d.driver_id = o.driver_id
		INNER JOIN dabarc.t_sap_tabla s ON o.odbc_id = s.odbc_id
	WHERE d.driver_id not in (14,15,16,17,18)
