CREATE VIEW [dabarc].[vw_Cat_typeActive] AS
 
  
  
	SELECT 'CTLE' AS cKey,'Coincide Tipo de Dato, Longitud y Escala' As cDescription
	UNION
	SELECT 'CEM','Cualquier escala mayor que 0'
	UNION
	SELECT 'MIMT','Mayor que o Igual a Maximo Tamaño'
	UNION
	SELECT 'PCTD','Por defecto para cualquier tipo de datos'
	UNION
	SELECT 'STD','Solo coincide Tipo de Dato'
	UNION
	SELECT 'TCE','Tipo de datos y coincide con la Escala'
	UNION
	SELECT 'TDCL','Tipo de datos y coincide con la longitud'
