CREATE TABLE [dabarc].[t_Sql_process_executeH] (
    [Path_hKey]         NVARCHAR (40)  NOT NULL,
    [Path_hName]        NVARCHAR (100) NOT NULL,
    [Path_hType]        NVARCHAR (50)  NULL,
    [Path_hDateInitial] DATETIME       NOT NULL,
    [Path_hDateFinal]   DATETIME       NULL,
    [Path_hTime]        NCHAR (20)     NULL,
    [Path_hUser]        NVARCHAR (100) NOT NULL,
    [Path_hStatus]      INT            CONSTRAINT [DF_t_sql_process_executeH_Path_hStatus] DEFAULT ((0)) NOT NULL,
    [path_message]      NCHAR (20)     NULL,
    [path_hTypeProcess] VARCHAR (50)   NULL,
    [path_TypeClass]    NCHAR (10)     NULL,
    [path_id]           INT            NULL,
    [path_Zip]          INT            NULL
);

