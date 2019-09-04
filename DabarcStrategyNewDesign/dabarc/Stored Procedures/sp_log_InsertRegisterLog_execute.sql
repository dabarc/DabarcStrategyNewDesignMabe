CREATE PROCEDURE dabarc.sp_log_InsertRegisterLog_execute
	@username		nvarchar(15),
	@status			nvarchar(1024),
	@object_name	nvarchar(128),
	@execute_date	datetime,
	@ip_address		nvarchar(15)
AS
BEGIN
  SET NOCOUNT ON;
  INSERT INTO log_execution (username, status, object_name, execute_date, ip_address)
  VALUES                   (@username, @status, @object_name, @execute_date, @ip_address)
  RETURN;
END;
