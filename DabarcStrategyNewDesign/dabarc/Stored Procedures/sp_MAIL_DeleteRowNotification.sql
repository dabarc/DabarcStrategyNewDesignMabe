CREATE PROCEDURE dabarc.sp_MAIL_DeleteRowNotification @IdMail INT AS 

 DELETE FROM dabarc.t_MAIL WHERE mail_id = @IdMail
