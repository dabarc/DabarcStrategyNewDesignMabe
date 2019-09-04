CREATE PROCEDURE [dabarc].[sp_MAIL_UpdateListNotification] @mail_id INT, @mail_active BIT, @mail_individual BIT AS

 UPDATE		dabarc.t_MAIL
 SET		mail_active = @mail_active, 
			mail_individual = @mail_individual
 WHERE		mail_id = @mail_id
