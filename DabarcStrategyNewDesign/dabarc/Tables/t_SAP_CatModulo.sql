CREATE TABLE [dabarc].[t_SAP_CatModulo] (
    [id_CatSapModulo]  INT            NOT NULL,
    [mod_Modulo]       NVARCHAR (50)  NOT NULL,
    [mod_Descripcion]  NVARCHAR (500) NOT NULL,
    [usuario_modifica] NCHAR (10)     NULL,
    [fecha_modifica]   DATETIME       NULL,
    CONSTRAINT [PK_t_Doma_CatSapModulo] PRIMARY KEY CLUSTERED ([id_CatSapModulo] ASC)
);

