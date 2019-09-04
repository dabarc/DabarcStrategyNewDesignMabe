CREATE TABLE [dabarc].[t_User_Logins] (
    [Id]            INT      IDENTITY (1, 1) NOT NULL,
    [Id_User]       INT      NOT NULL,
    [Dat_Login]     DATETIME NOT NULL,
    [Estatus_Login] BIT      NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_t_User_User_Logins] FOREIGN KEY ([Id_User]) REFERENCES [dabarc].[t_User] ([Id_User]) ON DELETE CASCADE ON UPDATE CASCADE
);

