CREATE TABLE [dabarc].[t_SapCatTable] (
    [SapTable_id]          INT            IDENTITY (1, 1) NOT NULL,
    [SapTable_name]        NCHAR (20)     NOT NULL,
    [SapTable_description] NVARCHAR (300) NOT NULL,
    [SapTable_category]    NCHAR (20)     NULL,
    CONSTRAINT [PK_t_SapCatTable] PRIMARY KEY CLUSTERED ([SapTable_id] ASC)
);

