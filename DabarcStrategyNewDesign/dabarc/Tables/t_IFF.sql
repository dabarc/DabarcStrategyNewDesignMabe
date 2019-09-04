﻿CREATE TABLE [dabarc].[t_IFF] (
    [report_id]         INT            IDENTITY (1, 1) NOT NULL,
    [name]              NVARCHAR (128) NOT NULL,
    [description]       NVARCHAR (256) NULL,
    [short_description] NVARCHAR (50)  NULL,
    [active]            BIT            CONSTRAINT [DF_t_IFF_active] DEFAULT ((0)) NOT NULL,
    [priority]          INT            CONSTRAINT [DF_t_IFF_priority] DEFAULT ((0)) NOT NULL,
    [create_date]       DATETIME       NOT NULL,
    [register_date]     DATETIME       NULL,
    [execute_date]      DATETIME       NULL,
    [register_user]     NVARCHAR (15)  NULL,
    [execute_user]      NVARCHAR (15)  NULL,
    [execute_time]      NVARCHAR (25)  NULL,
    [affected_rows]     INT            CONSTRAINT [DF_t_IFF_affected_rows] DEFAULT ((0)) NOT NULL,
    [modify_date]       DATETIME       NULL,
    [modify_user]       NVARCHAR (15)  NULL,
    [registered]        BIT            CONSTRAINT [DF_t_IFF_registered] DEFAULT ((0)) NOT NULL,
    [table_id]          INT            NULL,
    [last_error]        NVARCHAR (256) CONSTRAINT [DF_t_IFF_last_error] DEFAULT (N'Sin ejecutar') NULL,
    [status]            INT            CONSTRAINT [DF_t_IFF_status] DEFAULT ((0)) NULL,
    [IsTypeError]       BIT            CONSTRAINT [DF_t_IFF_Error] DEFAULT ((0)) NOT NULL,
    [report_type]       NVARCHAR (14)  NULL,
    [report_export]     NVARCHAR (10)  NULL,
    [report_separator]  NVARCHAR (10)  NULL,
    [report_typeseg]    NVARCHAR (10)  NULL,
    [report_segamount]  NUMERIC (18)   NULL,
    [report_segfield]   NVARCHAR (50)  NULL,
    [report_adddate]    BIT            CONSTRAINT [DF_t_IFF_report_adddate] DEFAULT ((0)) NOT NULL,
    [report_createzip]  INT            CONSTRAINT [DF_t_IFF_report_createzip] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_t_IFF] PRIMARY KEY CLUSTERED ([report_id] ASC),
    CONSTRAINT [FK_t_IFF_t_TFF] FOREIGN KEY ([table_id]) REFERENCES [dabarc].[t_TFF] ([table_id]) ON UPDATE CASCADE
);
