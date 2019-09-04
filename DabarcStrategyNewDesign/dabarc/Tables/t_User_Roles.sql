CREATE TABLE [dabarc].[t_User_Roles] (
    [Id_Rol]           INT            NOT NULL,
    [Rol_Name]         NVARCHAR (50)  NOT NULL,
    [Rol_Description]  NVARCHAR (250) NULL,
    [Active]           BIT            NOT NULL,
    [Rol_AccesUser]    BIT            NOT NULL,
    [Rol_AccesSsis]    BIT            NOT NULL,
    [Rol_AccesMethod]  BIT            NOT NULL,
    [Rol_AccesLog]     BIT            NOT NULL,
    [Rol_AccesExecute] BIT            NOT NULL,
    [Dat_Insert]       DATETIME       NOT NULL,
    [Dat_Delete]       DATETIME       NULL,
    [Dat_Update]       DATETIME       NULL,
    CONSTRAINT [PK_t_User_Roles] PRIMARY KEY CLUSTERED ([Id_Rol] ASC)
);

