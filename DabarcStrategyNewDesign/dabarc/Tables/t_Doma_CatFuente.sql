CREATE TABLE [dabarc].[t_Doma_CatFuente] (
    [id_fuente]        INT            IDENTITY (1, 1) NOT NULL,
    [id_actor]         INT            NULL,
    [nombre]           NVARCHAR (80)  NOT NULL,
    [descripcion]      NVARCHAR (400) NULL,
    [ubicacion]        NVARCHAR (200) NOT NULL,
    [plataforma]       NVARCHAR (50)  NOT NULL,
    [usuario_alta]     NCHAR (10)     NOT NULL,
    [fecha_alta]       DATETIME       NOT NULL,
    [usuario_modifica] NCHAR (10)     NULL,
    [fecha_modifica]   DATETIME       NULL,
    CONSTRAINT [PK_t_Doma_CatFuente] PRIMARY KEY CLUSTERED ([id_fuente] ASC)
);

