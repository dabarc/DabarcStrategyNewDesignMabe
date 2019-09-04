CREATE TABLE [dabarc].[asp_Language] (
    [lng_id]        NCHAR (5)     NOT NULL,
    [lenguaje]      NVARCHAR (50) NOT NULL,
    [lenguaje_sql]  VARCHAR (20)  NULL,
    [lenguaje_asp]  VARCHAR (20)  NULL,
    [lenguaje_trew] VARCHAR (20)  NULL,
    CONSTRAINT [PK_asp_Language] PRIMARY KEY CLUSTERED ([lng_id] ASC)
);

