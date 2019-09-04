CREATE TABLE [dabarc].[t_Doma_CatEmpresa] (
    [id_empresa]   NCHAR (10)     NOT NULL,
    [empresa]      NVARCHAR (100) NOT NULL,
    [direccion]    NVARCHAR (500) NOT NULL,
    [usuario_alta] NCHAR (10)     NOT NULL,
    [fecha_alta]   DATETIME       NOT NULL,
    CONSTRAINT [PK_t_Doma_Empresa] PRIMARY KEY CLUSTERED ([id_empresa] ASC)
);

