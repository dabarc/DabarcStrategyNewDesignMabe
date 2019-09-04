CREATE TABLE [dabarc].[t_User_Password_History] (
    [Id]            INT            IDENTITY (1, 1) NOT NULL,
    [Id_User]       INT            NOT NULL,
    [User_Password] NVARCHAR (300) NOT NULL,
    [Dat_Insert]    DATETIME       DEFAULT (getdate()) NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_User_UserPaswordHistory] FOREIGN KEY ([Id_User]) REFERENCES [dabarc].[t_User] ([Id_User]) ON DELETE CASCADE ON UPDATE CASCADE
);

