CREATE TABLE [dabarc].[t_LogInterfacesN] (
    [id_intExec]        INT            IDENTITY (1, 1) NOT NULL,
    [execute_unickey]   NVARCHAR (40)  NOT NULL,
    [execute_object_id] INT            NULL,
    [tipo_objeto]       NVARCHAR (50)  NULL,
    [execute_date]      DATETIME       NULL,
    [execute_message]   NVARCHAR (500) NULL,
    [execute_status]    INT            NULL,
    [interface_id]      INT            NOT NULL,
    [tssis_pathid]      NVARCHAR (40)  NULL,
    PRIMARY KEY CLUSTERED ([id_intExec] ASC)
);

