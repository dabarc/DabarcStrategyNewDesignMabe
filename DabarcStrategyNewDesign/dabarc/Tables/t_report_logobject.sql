CREATE TABLE [dabarc].[t_report_logobject] (
    [logobject_Id]          INT             NOT NULL,
    [logobject_IdParent]    INT             NOT NULL,
    [logobject_type]        NCHAR (20)      NOT NULL,
    [logobject_typeP]       NCHAR (20)      NOT NULL,
    [logobject_name]        NVARCHAR (100)  NOT NULL,
    [logobject_descripcion] NVARCHAR (3000) NULL,
    [logobject_typedesc]    NCHAR (50)      NULL,
    [logobject_datecreate]  DATETIME        NOT NULL,
    [logobject_lastexecute] DATETIME        NULL,
    [logobject_laststatus]  NCHAR (20)      NULL,
    [logobject_noexecute]   INT             NULL,
    [logobject_nocorrect]   INT             NULL,
    [logobject_noerror]     INT             NULL,
    [logobject_time]        NCHAR (100)     NULL,
    [logobject_notable]     INT             NULL,
    [logobject_nossis]      INT             NULL,
    [logobject_norule]      INT             NULL,
    [logobject_noinfo]      INT             NULL,
    [logobject_active]      BIT             NULL,
    [logobject_dateprocess] DATETIME        NULL,
    CONSTRAINT [PK_t_report_logobject] PRIMARY KEY CLUSTERED ([logobject_Id] ASC)
);

