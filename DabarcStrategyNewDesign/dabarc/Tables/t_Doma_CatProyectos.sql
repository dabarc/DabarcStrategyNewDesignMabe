CREATE TABLE [dabarc].[t_Doma_CatProyectos] (
    [id_proyecto]     INT            NOT NULL,
    [id_empresa]      INT            NOT NULL,
    [proyecto]        NVARCHAR (100) NOT NULL,
    [proyecto_desc]   NVARCHAR (500) NULL,
    [proyecto_inicio] DATETIME       NULL,
    [usuario_alta]    NCHAR (10)     NOT NULL,
    [fecha_alta]      NCHAR (10)     NOT NULL,
    CONSTRAINT [PK_t_Doma_CatProyectos] PRIMARY KEY CLUSTERED ([id_proyecto] ASC)
);

