CREATE TABLE [dabarc].[t_sap_tabla] (
    [tabla_id]        INT            IDENTITY (1, 1) NOT NULL,
    [odbc_id]         INT            NULL,
    [sap_esquema]     NVARCHAR (50)  NULL,
    [sap_table]       NVARCHAR (50)  NULL,
    [sap_descripcion] NVARCHAR (500) NULL,
    [sap_usado]       BIT            NULL,
    [sap_status]      NCHAR (20)     NULL,
    [sap_status_desc] NVARCHAR (500) NULL,
    [user_update]     NCHAR (20)     NULL,
    [date_update]     DATETIME       NULL,
    CONSTRAINT [PK_t_sap_table] PRIMARY KEY CLUSTERED ([tabla_id] ASC)
);

