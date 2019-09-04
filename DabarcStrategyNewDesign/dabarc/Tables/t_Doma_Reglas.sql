CREATE TABLE [dabarc].[t_Doma_Reglas] (
    [id_criterio]      INT            IDENTITY (1, 1) NOT NULL,
    [id_Sap]           INT            NOT NULL,
    [id_fuente]        INT            NULL,
    [TipoValor]        NCHAR (1)      NOT NULL,
    [ValorFijo]        NVARCHAR (200) NULL,
    [Reglas]           NVARCHAR (MAX) NULL,
    [usuario_alta]     NCHAR (10)     NULL,
    [fecha_alta]       DATETIME       NULL,
    [usuario_modifica] NCHAR (10)     NULL,
    [fecha_modifica]   DATETIME       NULL,
    CONSTRAINT [PK_t_Doma_Reglas] PRIMARY KEY CLUSTERED ([id_criterio] ASC)
);

