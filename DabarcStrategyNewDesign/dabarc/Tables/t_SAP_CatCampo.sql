CREATE TABLE [dabarc].[t_SAP_CatCampo] (
    [id_CatCampo]      INT             IDENTITY (1, 1) NOT NULL,
    [id_CatSapTabla]   INT             NOT NULL,
    [Campo]            NVARCHAR (70)   NOT NULL,
    [Val]              NVARCHAR (50)   NULL,
    [Descripcion]      NVARCHAR (2000) NOT NULL,
    [TipoDato]         NVARCHAR (30)   NULL,
    [Tamanio]          INT             NULL,
    [Decimal]          INT             NULL,
    [Tab_Verifica]     NVARCHAR (70)   NOT NULL,
    [usuario_modifica] NCHAR (10)      NULL,
    [fecha_modifica]   NCHAR (10)      NULL
);

