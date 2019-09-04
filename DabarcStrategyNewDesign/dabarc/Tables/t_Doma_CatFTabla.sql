CREATE TABLE [dabarc].[t_Doma_CatFTabla] (
    [id_fTabla]        INT            IDENTITY (1, 1) NOT NULL,
    [id_fuente]        INT            NOT NULL,
    [Tabla]            NVARCHAR (80)  NULL,
    [Descripcion]      NVARCHAR (200) NULL,
    [usuario_alta]     NCHAR (10)     NULL,
    [fecha_alta]       DATETIME       NULL,
    [usuario_modifica] NCHAR (10)     NULL,
    [fecha_modifica]   DATETIME       NULL,
    CONSTRAINT [PK_t_Doma_CatFTabla] PRIMARY KEY CLUSTERED ([id_fTabla] ASC)
);

