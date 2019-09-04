CREATE TABLE [dabarc].[t_User] (
    [Id_User]            INT            IDENTITY (1, 1) NOT NULL,
    [User_Name]          NVARCHAR (100) NOT NULL,
    [User_NameShort]     NCHAR (10)     NOT NULL,
    [User_Password]      NVARCHAR (300) NOT NULL,
    [User_MobilePIN]     NCHAR (10)     NULL,
    [User_Email]         NVARCHAR (50)  NULL,
    [User_PwdQuestion]   NVARCHAR (100) NULL,
    [User_PwdAnswer]     NVARCHAR (50)  NULL,
    [User_Active]        BIT            NULL,
    [User_OwnerOnlyData] BIT            NULL,
    [Dat_Insert]         DATETIME       NOT NULL,
    [Dat_Update]         DATETIME       NULL,
    [Dat_Delete]         DATETIME       NULL,
    [Is_Admin]           BIT            NOT NULL,
    [lng_id]             NCHAR (5)      CONSTRAINT [DF_t_User_lng_id] DEFAULT (N'SPA') NULL,
    [User_Blocked]       BIT            DEFAULT ((0)) NOT NULL,
    [User_Status]        INT            DEFAULT ((0)) NULL,
    CONSTRAINT [PK_t_User] PRIMARY KEY CLUSTERED ([Id_User] ASC)
);

