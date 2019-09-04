CREATE TABLE [dabarc].[asp_InfoTreeview_Dinamico] (
    [Id_Treeview] INT          IDENTITY (1, 1) NOT NULL,
    [Node_Type]   VARCHAR (50) NOT NULL,
    [Node_Imagen] VARCHAR (50) NOT NULL,
    [Node_Url]    VARCHAR (50) NOT NULL,
    [Node_Name]   VARCHAR (50) NOT NULL,
    [Node_Level]  INT          NOT NULL,
    CONSTRAINT [PK_asp_InfoTreeview] PRIMARY KEY CLUSTERED ([Id_Treeview] ASC)
);

