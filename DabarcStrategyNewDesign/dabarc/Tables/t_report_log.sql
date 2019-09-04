CREATE TABLE [dabarc].[t_report_log] (
    [Id]               INT             NOT NULL,
    [Process_name]     NVARCHAR (100)  NOT NULL,
    [Process_norow]    INT             NOT NULL,
    [Process_datetime] DATETIME        NOT NULL,
    [Process_status]   NCHAR (20)      NOT NULL,
    [Process_error]    NVARCHAR (2000) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

