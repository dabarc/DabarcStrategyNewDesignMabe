﻿CREATE TABLE [dabarc].[t_InterfacesN] (
    [interface_id]     INT            IDENTITY (1, 1) NOT NULL,
    [name]             NVARCHAR (128) NOT NULL,
    [description]      VARCHAR (500)  NULL,
    [active]           BIT            NOT NULL,
    [priority]         INT            NULL,
    [execute_ssis]     BIT            NOT NULL,
    [execute_rule]     BIT            NOT NULL,
    [execute_report]   BIT            NOT NULL,
    [execute_table]    BIT            NOT NULL,
    [execute_database] BIT            NOT NULL,
    [schedule_period]  NCHAR (10)     NOT NULL,
    [period]           SMALLDATETIME  NOT NULL,
    [next_execution]   SMALLDATETIME  NULL,
    [day_monday]       BIT            CONSTRAINT [DF_t_InterfacesN_day_Monday] DEFAULT ((0)) NOT NULL,
    [day_tuesday]      BIT            CONSTRAINT [DF_t_InterfacesN_day_Tuesday] DEFAULT ((0)) NOT NULL,
    [day_wednesday]    BIT            CONSTRAINT [DF_t_InterfacesN_day_Wednesday] DEFAULT ((0)) NOT NULL,
    [day_thursday]     BIT            CONSTRAINT [DF_t_InterfacesN_day_Thursday] DEFAULT ((0)) NOT NULL,
    [day_friday]       BIT            CONSTRAINT [DF_t_InterfacesN_day_Friday] DEFAULT ((0)) NOT NULL,
    [day_saturday]     BIT            CONSTRAINT [DF_t_InterfacesN_day_Saturday] DEFAULT ((0)) NOT NULL,
    [day_sunday]       BIT            CONSTRAINT [DF_t_InterfacesN_day_Sunday] DEFAULT ((0)) NOT NULL,
    [last_error]       NVARCHAR (256) NOT NULL,
    [status]           INT            CONSTRAINT [DF_t_InterfacesN_status] DEFAULT ((0)) NULL,
    [modify_date]      DATETIME       NULL,
    [modify_user]      NVARCHAR (15)  NULL,
    [objects_number]   INT            NULL,
    [last_execution]   SMALLDATETIME  NULL,
    CONSTRAINT [PK_t_InterfacesN] PRIMARY KEY CLUSTERED ([interface_id] ASC)
);

