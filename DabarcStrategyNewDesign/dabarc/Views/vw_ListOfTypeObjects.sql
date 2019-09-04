

CREATE VIEW [dabarc].[vw_ListOfTypeObjects] AS

SELECT 1 as Id, 'BDF' as Type, 'Base de Datos Fuente (BDF)' as sDescription, 't_BDF' as sTable
UNION  SELECT 2 as Id, 'BDM' as Type, 'Base de Datos de Manipulación (BDM)' as sDescription, 't_BDM' as sTable
UNION  SELECT 3 as Id, 'TFF' as Type, 'Tablas Fuente (TFF)' as sDescription, 't_TFF' as sTable
UNION  SELECT 4 as Id, 'TFM' as Type, 'Tablas de Manipulación (TFM)' as sDescription, 't_TFM' as sTable
UNION  SELECT 5 as Id, 'TDM' as Type, 'Tablas Destino (TDM)' as sDescription, 't_TDM' as sTable
UNION  SELECT 6 as Id, 'SSIS' as Type, 'Paquetes de extracción (SSIS)' as sDescription, 't_SSIS' as sTable
UNION  SELECT 7 as Id, 'RFF' as Type, 'Reglas Fuente (RFF)' as sDescription, 't_RFF' as sTable
UNION  SELECT 8 as Id, 'RFM' as Type, 'Reglas de Manipulación (RFM)' as sDescription, 't_RFM' as sTable
UNION  SELECT 9 as Id, 'RDM' as Type, 'Reglas Destino (RDM)' as sDescription, 't_RDM' as sTable
UNION  SELECT 10 as Id, 'IFF' as Type, 'Informes Fuente (IFF)' as sDescription, 't_IFF' as sTable
UNION  SELECT 11 as Id, 'IFM' as Type, 'Informes de Manipulación (IFM)' as sDescription, 't_IFM' as sTable
UNION  SELECT 12 as Id, 'IDM' as Type, 'Informes Destino (IDM)' as sDescription, 't_IDM' as sTable
UNION  SELECT 13 as Id, 'INTE' as Type, 'Interfaces' as sDescription, 't_InterfacesN' as sTable
UNION  SELECT 14 as Id, 'DBSS' as Type, 'Todos los SSIS de BDF' as sDescription, 't_BDF' as sTable
