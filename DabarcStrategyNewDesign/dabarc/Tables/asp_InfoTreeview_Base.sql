CREATE TABLE [dabarc].[asp_InfoTreeview_Base] (
    [Id_TreeviewB]  INT           NOT NULL,
    [Node_Clave]    VARCHAR (10)  NOT NULL,
    [Node_Name]     VARCHAR (50)  NOT NULL,
    [Node_Level]    INT           NOT NULL,
    [Node_Parent]   VARCHAR (10)  NOT NULL,
    [Node_Url]      VARCHAR (200) NULL,
    [Node_Imagen]   VARCHAR (50)  NOT NULL,
    [Node_Position] INT           NULL,
    [Node_Name_ING] VARCHAR (50)  NULL
);

