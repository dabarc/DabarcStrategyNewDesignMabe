CREATE PROCEDURE [dabarc].[sp_log_InsertRegisterLogMov] @Mov_Type nchar(20),
													@Mov_Table nvarchar(50),
													@Mov_IdTable int,
													@Mov_Description nvarchar(250),
													@Mov_Datetime datetime,
													@Mov_User nchar(20) AS 
													
	INSERT INTO dabarc.t_LogMov(Mov_Type,
								Mov_Table, 
								Mov_IdTable, 
								Mov_Description, 
								Mov_Datetime, 
								Mov_User) 
						VALUES(	@Mov_Type,
								@Mov_Table,
								@Mov_IdTable,
								@Mov_Description, 
								@Mov_Datetime,
								@Mov_User)
