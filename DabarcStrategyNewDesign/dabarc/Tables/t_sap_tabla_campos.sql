CREATE TABLE [dabarc].[t_sap_tabla_campos] (
    [campo_id]           INT             IDENTITY (1, 1) NOT NULL,
    [tabla_id]           INT             NOT NULL,
    [sap_campo]          NVARCHAR (100)  NOT NULL,
    [sap_valor]          NVARCHAR (50)   NOT NULL,
    [sap_tamanio]        INT             NOT NULL,
    [sap_tipo]           NCHAR (10)      NULL,
    [sap_descripcion_es] NVARCHAR (1500) NULL,
    [sap_descripcion_in] NVARCHAR (1500) NULL,
    [pro_usado]          BIT             NULL,
    [pro_tipo]           NCHAR (10)      NULL,
    [pro_gd]             BIT             NULL,
    [pro_descripcion]    NVARCHAR (1500) NULL,
    [user_update]        NCHAR (20)      NOT NULL,
    [date_update]        DATETIME        NOT NULL,
    CONSTRAINT [PK_t_sap_tabla_campos] PRIMARY KEY CLUSTERED ([campo_id] ASC)
);

