CREATE TABLE [dabarc].[t_Doma_ActorONegocio] (
    [id_actor_x_ONegocio] INT        IDENTITY (1, 1) NOT NULL,
    [id_actor]            INT        NOT NULL,
    [id_oNegocio]         INT        NOT NULL,
    [usuario_alta]        NCHAR (10) NULL,
    [fecha_alta]          DATETIME   NULL,
    CONSTRAINT [PK_t_Doma_ActoroNegocio] PRIMARY KEY CLUSTERED ([id_actor_x_ONegocio] ASC)
);

