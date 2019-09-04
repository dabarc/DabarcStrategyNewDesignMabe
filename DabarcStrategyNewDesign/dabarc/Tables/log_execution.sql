CREATE TABLE [dabarc].[log_execution] (
    [id]           INT             IDENTITY (1, 1) NOT NULL,
    [username]     NVARCHAR (15)   NULL,
    [status]       NVARCHAR (1024) NULL,
    [object_name]  NVARCHAR (128)  NULL,
    [execute_date] DATETIME        NULL,
    [ip_address]   NCHAR (15)      NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

