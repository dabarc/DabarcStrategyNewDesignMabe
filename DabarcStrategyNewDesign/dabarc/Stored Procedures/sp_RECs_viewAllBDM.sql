CREATE PROCEDURE [dabarc].[sp_RECs_viewAllBDM]
AS
BEGIN
  SET NOCOUNT ON;
  SELECT database_id, name FROM t_BDM WHERE active = 1;
END
