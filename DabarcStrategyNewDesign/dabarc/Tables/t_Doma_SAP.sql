CREATE TABLE [dabarc].[t_Doma_SAP] (
    [id_Sap]           INT             NOT NULL,
    [id_oNegocio]      INT             NOT NULL,
    [id_CatSap]        INT             NOT NULL,
    [Tabla]            NVARCHAR (70)   NOT NULL,
    [Campo]            NVARCHAR (70)   NOT NULL,
    [Descripcion]      NVARCHAR (2000) NOT NULL,
    [TipoDato]         NVARCHAR (30)   NULL,
    [Tamanio]          INT             NULL,
    [Decimal]          INT             NULL,
    [Tipo]             INT             NULL,
    [Ruta]             NCHAR (10)      NULL,
    [Renglon]          NCHAR (10)      NULL,
    [usuario_alta]     NCHAR (10)      NULL,
    [fecha_alta]       NCHAR (10)      NULL,
    [usuario_modifica] NCHAR (10)      NULL,
    [fecha_modifica]   NCHAR (10)      NULL,
    CONSTRAINT [PK_t_Doma_SAP] PRIMARY KEY CLUSTERED ([id_Sap] ASC)
);

