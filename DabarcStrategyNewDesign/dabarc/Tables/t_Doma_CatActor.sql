CREATE TABLE [dabarc].[t_Doma_CatActor] (
    [id_actor]         INT            CONSTRAINT [DF_doma_actor_id_actor] DEFAULT ((0)) NOT NULL,
    [id_empresa]       INT            NOT NULL,
    [id_titulo]        INT            NOT NULL,
    [Nombre]           NVARCHAR (60)  NOT NULL,
    [Correo]           NVARCHAR (60)  NOT NULL,
    [Telefono]         NVARCHAR (60)  NULL,
    [Puesto]           NVARCHAR (150) NULL,
    [usuario_alta]     NCHAR (10)     NULL,
    [fecha_alta]       DATETIME       NULL,
    [usuario_modifica] NCHAR (10)     NULL,
    [fecha_modifica]   DATETIME       NULL,
    CONSTRAINT [PK_doma_actor] PRIMARY KEY CLUSTERED ([id_actor] ASC)
);

