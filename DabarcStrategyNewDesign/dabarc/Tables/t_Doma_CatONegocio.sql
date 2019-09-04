CREATE TABLE [dabarc].[t_Doma_CatONegocio] (
    [id_oNegocio]      INT             IDENTITY (1, 1) NOT NULL,
    [Tipo]             NCHAR (10)      NULL,
    [Capa]             INT             NULL,
    [Criterio]         NVARCHAR (1000) NULL,
    [usuario_alta]     NCHAR (10)      NULL,
    [fecha_alta]       NCHAR (10)      NULL,
    [usuario_modifica] NCHAR (10)      NULL,
    [fecha_modifica]   NCHAR (10)      NULL,
    CONSTRAINT [PK_t_Doma_ONegocio] PRIMARY KEY CLUSTERED ([id_oNegocio] ASC)
);

