CREATE TABLE [dabarc].[t_SAP_CatTablas] (
    [id_CatSapTabla]   INT            IDENTITY (1, 1) NOT NULL,
    [id_CatSapModulo]  INT            NOT NULL,
    [id_CatSapObjeto]  INT            NOT NULL,
    [tbl_Tabla]        NVARCHAR (50)  NOT NULL,
    [tbl_Descripcion]  NVARCHAR (500) NOT NULL,
    [usuario_modifica] NCHAR (10)     NOT NULL,
    [fecha_modifica]   DATETIME       NOT NULL,
    CONSTRAINT [PK_t_Doma_CatSAPTablas] PRIMARY KEY CLUSTERED ([id_CatSapTabla] ASC)
);

