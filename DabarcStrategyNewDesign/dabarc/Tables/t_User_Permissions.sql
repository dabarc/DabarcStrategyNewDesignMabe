CREATE TABLE [dabarc].[t_User_Permissions] (
    [Id_UserPermissions] INT NOT NULL,
    [Id_User]            INT NOT NULL,
    [Id_Rol]             INT NOT NULL,
    CONSTRAINT [PK_t_User_Permissions] PRIMARY KEY CLUSTERED ([Id_UserPermissions] ASC)
);

