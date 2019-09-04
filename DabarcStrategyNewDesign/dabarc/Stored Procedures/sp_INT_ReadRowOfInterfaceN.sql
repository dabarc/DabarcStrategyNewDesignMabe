
CREATE PROCEDURE [dabarc].[sp_INT_ReadRowOfInterfaceN]
(
	@interface_id int
)
AS

SELECT interface_id
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
      ,CASE WHEN NOT period IS NULL THEN RTRIM(CAST(DATEPART(HOUR,period) AS CHAR(2))) ELSE NULL END as cHours
      ,CASE WHEN NOT period IS NULL THEN CAST(DATEPART(MINUTE,period) AS CHAR(2)) ELSE NULL END cMinute
      ,next_execution
      ,CASE WHEN NOT next_execution IS NULL THEN RTRIM(CAST(DATEPART(HOUR,next_execution) AS CHAR(2))) ELSE NULL END as cHours
      ,CASE WHEN NOT next_execution IS NULL THEN CAST(DATEPART(MINUTE,next_execution) AS CHAR(2)) ELSE NULL END cMinute
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
      ,CASE WHEN NOT modify_date IS NULL THEN RTRIM(CAST(DATEPART(HOUR,modify_date) AS CHAR(2))) ELSE NULL END as cHours
      ,CASE WHEN NOT modify_date IS NULL THEN CAST(DATEPART(MINUTE,modify_date) AS CHAR(2)) ELSE NULL END cMinute
      ,modify_user
      ,objects_number
      ,last_execution
      
  FROM dabarc.t_InterfacesN
  WHERE interface_id = @interface_id
  
  
SELECT CONVERT(VARCHAR(10),GETDATE(),108)
SELECT DATEPART(HOUR,GETDATE())
SELECT DATEPART(MINUTE,GETDATE())


RETURN
