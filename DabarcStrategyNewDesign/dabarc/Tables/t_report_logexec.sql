CREATE TABLE [dabarc].[t_report_logexec] (
    [logexec_clave]       NCHAR (50)      NOT NULL,
    [logexec_Id]          INT             NOT NULL,
    [logexec_IdParent]    INT             NOT NULL,
    [logexec_typeO]       NCHAR (20)      NOT NULL,
    [logexec_name]        NVARCHAR (200)  NOT NULL,
    [logexec_dateI]       DATETIME        NOT NULL,
    [logexec_dateF]       DATETIME        NULL,
    [logexec_time]        NCHAR (500)     NOT NULL,
    [logexec_status]      NCHAR (20)      NOT NULL,
    [logexec_norow]       INT             NOT NULL,
    [logexec_objerror]    NVARCHAR (200)  NULL,
    [logexec_msgerror]    NVARCHAR (4000) NULL,
    [logexec_isinterface] BIT             NULL,
    [logexec_lastexec]    BIT             NULL,
    [logexec_result]      INT             NULL,
    CONSTRAINT [PK_t_report_logexec] PRIMARY KEY CLUSTERED ([logexec_Id] ASC)
);

