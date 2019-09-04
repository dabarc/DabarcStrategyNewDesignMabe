CREATE TABLE [dabarc].[t_scriptSap] (
    [idsapf]          INT             IDENTITY (1, 1) NOT NULL,
    [sap_table]       NVARCHAR (50)   NOT NULL,
    [sap_field]       NVARCHAR (50)   NOT NULL,
    [sap_key]         BIT             NULL,
    [sap_mandatory]   BIT             NULL,
    [sap_type]        NVARCHAR (30)   NULL,
    [sap_length]      INT             NULL,
    [sap_decimal]     INT             NULL,
    [sap_tablenameE]  NVARCHAR (100)  NULL,
    [sap_tablenameS]  NVARCHAR (100)  NULL,
    [sap_fieldnameE]  NVARCHAR (100)  NULL,
    [sap_fieldnameS]  NVARCHAR (100)  NULL,
    [sap_checktable]  NVARCHAR (50)   NULL,
    [sap_checkfield]  NVARCHAR (50)   NULL,
    [user_insert]     NCHAR (10)      NULL,
    [user_date]       DATETIME        NULL,
    [sap_scriptcheck] NVARCHAR (4000) NULL,
    CONSTRAINT [PK_t_scriptSap2] PRIMARY KEY CLUSTERED ([idsapf] ASC)
);

