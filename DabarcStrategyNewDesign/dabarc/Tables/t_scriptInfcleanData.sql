CREATE TABLE [dabarc].[t_scriptInfcleanData] (
    [idsinfom]   INT            IDENTITY (1, 1) NOT NULL,
    [tablename]  NVARCHAR (100) NOT NULL,
    [fieldname]  NVARCHAR (100) NOT NULL,
    [idsinfo]    INT            NOT NULL,
    [dateinsert] DATETIME       NOT NULL,
    [userinsert] NCHAR (10)     NULL,
    [datecreate] DATETIME       NULL,
    [error]      NVARCHAR (500) NULL,
    CONSTRAINT [PK_t_scriptInfcleandata] PRIMARY KEY CLUSTERED ([idsinfom] ASC)
);

