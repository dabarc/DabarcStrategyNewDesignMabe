﻿CREATE TABLE [dabarc].[Users] (
    [Id]                   NVARCHAR (450)     NOT NULL,
    [AccessFailedCount]    INT                NOT NULL,
    [ConcurrencyStamp]     NVARCHAR (MAX)     NULL,
    [Email]                NVARCHAR (256)     NULL,
    [EmailConfirmed]       BIT                NOT NULL,
    [LockoutEnabled]       BIT                NOT NULL,
    [LockoutEnd]           DATETIMEOFFSET (7) NULL,
    [NormalizedEmail]      NVARCHAR (256)     NULL,
    [NormalizedUserName]   NVARCHAR (256)     NULL,
    [PasswordHash]         NVARCHAR (MAX)     NULL,
    [PhoneNumber]          NVARCHAR (MAX)     NULL,
    [PhoneNumberConfirmed] BIT                NOT NULL,
    [SecurityStamp]        NVARCHAR (MAX)     NULL,
    [TwoFactorEnabled]     BIT                NOT NULL,
    [UserName]             NVARCHAR (256)     NULL,
    [Idioma]               NVARCHAR (MAX)     NULL,
    [Nombre]               NVARCHAR (MAX)     NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [dabarc].[Users]([NormalizedEmail] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dabarc].[Users]([NormalizedUserName] ASC) WHERE ([NormalizedUserName] IS NOT NULL);

