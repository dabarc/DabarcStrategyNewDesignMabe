CREATE TABLE [dabarc].[t_SapCatColumns] (
    [SapTable_id]        INT            NULL,
    [SapCol_id]          INT            IDENTITY (1, 1) NOT NULL,
    [SapCol_Position]    INT            NOT NULL,
    [SapCol_Name]        NCHAR (50)     NOT NULL,
    [SapCol_IsKey]       BIT            CONSTRAINT [DF_t_SapCatColumns_SapCol_IsKey] DEFAULT ((0)) NOT NULL,
    [SapCol_DataElement] NCHAR (50)     NULL,
    [SapCol_Domain]      NCHAR (50)     NULL,
    [SapCol_Datatype]    NCHAR (30)     NULL,
    [SapCol_Length]      INT            NULL,
    [SapCol_Decimal]     INT            NULL,
    [SapCol_Description] NVARCHAR (100) NULL,
    [SapCol_Spanish]     NVARCHAR (100) NULL,
    [SapCol_TableCheck]  NCHAR (30)     NULL,
    CONSTRAINT [PK_t_SapCatColumns] PRIMARY KEY CLUSTERED ([SapCol_id] ASC)
);

