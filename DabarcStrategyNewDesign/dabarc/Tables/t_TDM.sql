﻿CREATE TABLE [dabarc].[t_TDM] (
    [table_id]          INT            IDENTITY (1, 1) NOT NULL,
    [name]              NVARCHAR (128) NOT NULL,
    [description]       NVARCHAR (256) NULL,
    [short_description] NVARCHAR (50)  NULL,
    [active]            BIT            CONSTRAINT [DF_t_TDM_active] DEFAULT ((0)) NOT NULL,
    [priority]          INT            CONSTRAINT [DF_t_TDM_priority] DEFAULT ((0)) NOT NULL,
    [create_date]       DATETIME       NOT NULL,
    [register_date]     DATETIME       NULL,
    [execute_date]      DATETIME       NULL,
    [register_user]     NVARCHAR (15)  NULL,
    [execute_user]      NVARCHAR (15)  NULL,
    [tables_number]     INT            CONSTRAINT [DF_t_TDM_tables_number] DEFAULT ((0)) NOT NULL,
    [rules_number]      INT            CONSTRAINT [DF_t_TDM_rules_number] DEFAULT ((0)) NOT NULL,
    [reports_number]    INT            CONSTRAINT [DF_t_TDM_reports_number] DEFAULT ((0)) NOT NULL,
    [execute_time]      NVARCHAR (25)  NULL,
    [modify_date]       DATETIME       NULL,
    [modify_user]       NVARCHAR (15)  NULL,
    [registered]        BIT            CONSTRAINT [DF_t_TDM_registered] DEFAULT ((0)) NOT NULL,
    [database_id]       INT            NOT NULL,
    [last_error]        NVARCHAR (256) CONSTRAINT [DF_t_TDM_last_error] DEFAULT (N'Sin ejecutar') NULL,
    [status]            INT            CONSTRAINT [DF_t_TDM_status] DEFAULT ((0)) NULL,
    [execute_rules]     BIT            CONSTRAINT [DF_t_TDM_execute_rules] DEFAULT ((1)) NOT NULL,
    [execute_reports]   BIT            CONSTRAINT [DF_t_TDM_execute_reports] DEFAULT ((1)) NOT NULL,
    [execute_ssis]      BIT            CONSTRAINT [DF_t_TDM_execute_ssis] DEFAULT ((1)) NOT NULL,
    [ssis_number]       INT            CONSTRAINT [DF_t_TDM_ssis_number] DEFAULT ((0)) NOT NULL,
    [table_createzip]   INT            CONSTRAINT [DF_t_TDM_table_createzip] DEFAULT ((0)) NULL,
    CONSTRAINT [PK_t_TDM] PRIMARY KEY CLUSTERED ([table_id] ASC)
);

