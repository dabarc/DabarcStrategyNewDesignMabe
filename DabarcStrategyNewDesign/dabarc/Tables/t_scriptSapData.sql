CREATE TABLE [dabarc].[t_scriptSapData] (
    [idsapfd]         INT             IDENTITY (1, 1) NOT NULL,
    [active]          BIT             NOT NULL,
    [tablename]       NVARCHAR (100)  NOT NULL,
    [fieldname]       NVARCHAR (100)  NOT NULL,
    [idsapf]          INT             NOT NULL,
    [dateinsert]      DATETIME        NOT NULL,
    [userinsert]      NCHAR (10)      NOT NULL,
    [datecreate]      DATETIME        NULL,
    [error]           NVARCHAR (500)  NULL,
    [sap_scriptcheck] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_t_scriptSapData] PRIMARY KEY CLUSTERED ([idsapfd] ASC)
);

