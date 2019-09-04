CREATE TABLE [dabarc].[t_scriptInfcleanData1] (
    [idsinfom]     INT             IDENTITY (1, 1) NOT NULL,
    [tablename]    NVARCHAR (100)  NOT NULL,
    [fieldname]    NVARCHAR (100)  NOT NULL,
    [idsinfo]      INT             NOT NULL,
    [dateinsert]   DATETIME        NOT NULL,
    [userinsert]   NVARCHAR (10)   NULL,
    [datecreate]   DATETIME        NULL,
    [error]        NVARCHAR (500)  NULL,
    [script_final] NVARCHAR (4000) NULL,
    [info_name]    NVARCHAR (200)  NULL,
    [active]       BIT             NULL,
    CONSTRAINT [PK_t_scriptInfcleandata1] PRIMARY KEY CLUSTERED ([idsinfom] ASC)
);

