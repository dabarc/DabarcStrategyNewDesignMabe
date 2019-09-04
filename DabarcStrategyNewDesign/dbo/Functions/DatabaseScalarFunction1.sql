CREATE FUNCTION [dbo].[DatabaseScalarFunction1](@OdbcId int)
RETURNS TABLE
AS

RETURN
SELECT  'DRIVER=' + r.driver_text + 
        ';SERVER=' + odbc_server + 
        ';DBQ=' + odbc_database + 
		';UID=' + odbc_user + 
		';PWD=' + odbc_pasword +  '' AS  odbc_string
FROM dabarc.t_ODBC o
INNER JOIN dabarc.t_ODBC_driver r 
ON o.driver_id = r.driver_id
WHERE o.odbc_id = @OdbcId;
