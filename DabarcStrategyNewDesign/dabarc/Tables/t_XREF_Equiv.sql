CREATE TABLE [dabarc].[t_XREF_Equiv] (
    [xequi_id]        INT            IDENTITY (1, 1) NOT NULL,
    [xref_id]         INT            NOT NULL,
    [nameColEx]       NVARCHAR (200) NOT NULL,
    [typeColEx]       NVARCHAR (70)  NOT NULL,
    [tblCol]          NVARCHAR (200) NULL,
    [tblColType]      NVARCHAR (80)  NULL,
    [tblColSize]      INT            NULL,
    [tblColPrecision] INT            NULL,
    [tblColScale]     INT            NOT NULL,
    [tblColNull]      BIT            NULL,
    [accion]          NVARCHAR (100) NULL,
    [status]          INT            NULL,
    [user_registered] NCHAR (10)     NULL,
    [registered_user] NVARCHAR (15)  NULL,
    CONSTRAINT [PK_t_XREF_Equiv] PRIMARY KEY CLUSTERED ([xequi_id] ASC)
);

