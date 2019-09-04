CREATE PROCEDURE [dabarc].[sp_INT_ReadListOfInterfaceN]

	@param nchar(1)

AS
BEGIN
    SET NOCOUNT ON;
	SELECT
	   interface_id
      ,name
      ,description
      ,active
      ,priority
      ,execute_ssis
      ,execute_rule
      ,execute_report
      ,execute_table
      ,execute_database
      ,schedule_period
      ,period
      ,next_execution
      ,day_monday
      ,day_tuesday
      ,day_wednesday
      ,day_thursday
      ,day_friday
      ,day_saturday
      ,day_sunday
      ,last_error
      ,status
      ,modify_date
      ,modify_user
      ,objects_number
      ,last_execution
	FROM dabarc.t_InterfacesN
	ORDER BY active DESC , priority ASC
END
