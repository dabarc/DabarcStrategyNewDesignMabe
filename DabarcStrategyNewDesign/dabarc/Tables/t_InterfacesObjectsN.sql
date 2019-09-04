CREATE TABLE [dabarc].[t_InterfacesObjectsN] (
    [interface_id] INT            NOT NULL,
    [object_id]    INT            IDENTITY (1, 1) NOT NULL,
    [object_type]  NVARCHAR (20)  NULL,
    [table_name]   NVARCHAR (128) NOT NULL,
    [description]  NVARCHAR (500) NULL,
    [active]       BIT            CONSTRAINT [DF_t_InterfaceObjectsN_active] DEFAULT ((0)) NOT NULL,
    [priority]     INT            CONSTRAINT [DF_t_InterfaceObjectsN_priority] DEFAULT ((0)) NOT NULL,
    [last_error]   NVARCHAR (256) CONSTRAINT [DF_t_InterfacesObjectsN_last_error] DEFAULT (N'Sin ejecutar') NOT NULL,
    [status]       INT            CONSTRAINT [DF_t_InterfacesObjectsN_status] DEFAULT ((0)) NOT NULL,
    [modify_date]  DATETIME       NULL,
    [modify_user]  NVARCHAR (15)  NULL,
    [int_IdObj]    INT            NOT NULL,
    CONSTRAINT [PK_t_InterfaceObjectsNew] PRIMARY KEY CLUSTERED ([object_id] ASC),
    CONSTRAINT [FK_Inter_Objects] FOREIGN KEY ([interface_id]) REFERENCES [dabarc].[t_InterfacesN] ([interface_id])
);

