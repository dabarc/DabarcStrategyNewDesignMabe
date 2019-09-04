CREATE TABLE [dabarc].[t_Sql_process_executeD] (
    [path_unickey]        NVARCHAR (40)  NOT NULL,
    [path_position]       INT            IDENTITY (1, 1) NOT NULL,
    [path_table]          NVARCHAR (30)  NULL,
    [path_id]             INT            NULL,
    [path_name]           NVARCHAR (150) NULL,
    [path_type]           NVARCHAR (50)  NULL,
    [path_date]           DATETIME       NULL,
    [path_dateini]        DATETIME       NULL,
    [path_datefin]        DATETIME       NULL,
    [path_status]         INT            NULL,
    [path_executeuser]    NVARCHAR (15)  NULL,
    [path_Priority]       INT            NULL,
    [path_message]        NVARCHAR (300) NULL,
    [path_extra]          NVARCHAR (200) NULL,
    [path_table_padre_id] INT            NULL,
    [path_id_name]        NVARCHAR (50)  NULL,
    [path_TypeClass]      NCHAR (10)     NULL,
    [path_extra2]         NVARCHAR (100) NULL,
    [tssis_pathid]        BIGINT         NULL,
    [affected_rows]       INT            NULL
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'SSIS, INFO, RULE', @level0type = N'SCHEMA', @level0name = N'dabarc', @level1type = N'TABLE', @level1name = N't_Sql_process_executeD', @level2type = N'COLUMN', @level2name = N'path_type';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'0 - en espera, 1 - terminado, 2 -cancelado, 3 - error', @level0type = N'SCHEMA', @level0name = N'dabarc', @level1type = N'TABLE', @level1name = N't_Sql_process_executeD', @level2type = N'COLUMN', @level2name = N'path_status';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica si el proceso corresponde aun DBM o DBF', @level0type = N'SCHEMA', @level0name = N'dabarc', @level1type = N'TABLE', @level1name = N't_Sql_process_executeD', @level2type = N'COLUMN', @level2name = N'path_TypeClass';

