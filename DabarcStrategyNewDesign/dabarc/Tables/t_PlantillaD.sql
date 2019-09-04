﻿CREATE TABLE [dabarc].[t_PlantillaD] (
    [plantillad_id]     INT             IDENTITY (1, 1) NOT NULL,
    [plantilla_id]      INT             NOT NULL,
    [table_name]        NVARCHAR (MAX)  NULL,
    [create_date]       DATETIME        NULL,
    [register_user]     NVARCHAR (15)   NULL,
    [active]            BIT             DEFAULT ((0)) NOT NULL,
    [porc_equal]        INT             DEFAULT ((0)) NOT NULL,
    [modify_date]       SMALLDATETIME   NULL,
    [modify_user]       NVARCHAR (15)   NULL,
    [table_esquema]     NVARCHAR (150)  NULL,
    [table_createssis]  NVARCHAR (250)  NULL,
    [table_createtable] NVARCHAR (250)  NULL,
    [table_nametdm]     NVARCHAR (250)  NULL,
    [table_where]       NVARCHAR (900)  NULL,
    [add_data]          BIT             NULL,
    [add_table]         NVARCHAR (100)  NULL,
    [add_message]       NVARCHAR (4000) NULL,
    [ssis_sql001]       NVARCHAR (MAX)  NULL,
    [ssis_sql002]       NVARCHAR (MAX)  NULL,
    [ssis_sql003]       NVARCHAR (MAX)  NULL,
    [ssis_sql004]       NVARCHAR (MAX)  NULL,
    CONSTRAINT [PK_t_PlantillaD] PRIMARY KEY CLUSTERED ([plantillad_id] ASC)
);

