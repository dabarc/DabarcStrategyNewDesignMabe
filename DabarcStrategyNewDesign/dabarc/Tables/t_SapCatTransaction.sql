CREATE TABLE [dabarc].[t_SapCatTransaction] (
    [Code_Transaction]  CHAR (10)      NOT NULL,
    [Short_Description] NVARCHAR (250) NULL,
    [Short_Spanish]     NVARCHAR (250) NULL,
    CONSTRAINT [PK_t_SapCatTransaction] PRIMARY KEY CLUSTERED ([Code_Transaction] ASC)
);

