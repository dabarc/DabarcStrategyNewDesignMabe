CREATE TABLE [dabarc].[t_SAP_CatObjeto] (
    [id_CatSapObjeto]  INT            NOT NULL,
    [id_CatSapModulo]  INT            NOT NULL,
    [obj_Objeto]       NVARCHAR (50)  NOT NULL,
    [obj_Descripcion]  NVARCHAR (500) NULL,
    [usuario_modifica] NCHAR (10)     NOT NULL,
    [fecha_modifica]   DATETIME       NOT NULL,
    CONSTRAINT [PK_t_Doma_CatSAPObjeto] PRIMARY KEY CLUSTERED ([id_CatSapObjeto] ASC)
);

