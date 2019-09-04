CREATE TABLE [dabarc].[t_User_RolPermissions] (
    [Id_RolPermissions] INT           NOT NULL,
    [Id_Rol]            INT           NOT NULL,
    [Id_TreeViewB]      INT           NOT NULL,
    [Per_Table]         NVARCHAR (50) NULL,
    [Per_Id]            INT           NULL,
    [Per_Name]          NVARCHAR (50) NULL,
    [Active]            BIT           NOT NULL,
    [Per_Execute]       BIT           CONSTRAINT [DF_t_User_RolPermissions_Per_Execute] DEFAULT ((1)) NULL,
    [Per_Insert]        BIT           CONSTRAINT [DF_t_User_RolPermissions_Per_Insert] DEFAULT ((1)) NULL,
    [Per_Modify]        BIT           CONSTRAINT [DF_t_User_RolPermissions_Per_Modify] DEFAULT ((1)) NULL,
    [Per_Delete]        BIT           CONSTRAINT [DF_t_User_RolPermissions_Per_Delete] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_t_User_RolPermissions] PRIMARY KEY CLUSTERED ([Id_RolPermissions] ASC)
);

