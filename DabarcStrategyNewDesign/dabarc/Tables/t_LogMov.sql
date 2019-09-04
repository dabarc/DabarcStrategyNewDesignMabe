CREATE TABLE [dabarc].[t_LogMov] (
    [id_LogMov]       INT            IDENTITY (1, 1) NOT NULL,
    [Mov_Type]        NCHAR (20)     NOT NULL,
    [Mov_Table]       NVARCHAR (50)  NOT NULL,
    [Mov_IdTable]     INT            NOT NULL,
    [Mov_Description] NVARCHAR (250) NOT NULL,
    [Mov_Datetime]    DATETIME       NOT NULL,
    [Mov_User]        NCHAR (20)     NOT NULL,
    CONSTRAINT [PK_t_LogMov] PRIMARY KEY CLUSTERED ([id_LogMov] ASC)
);

