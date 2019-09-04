CREATE TABLE [dabarc].[t_PlantillaH] (
    [plantilla_id]     INT             IDENTITY (1, 1) NOT NULL,
    [plan_name]        NVARCHAR (60)   NOT NULL,
    [plan_description] NVARCHAR (256)  NOT NULL,
    [odbc_id]          INT             NOT NULL,
    [sql_server]       NVARCHAR (60)   NOT NULL,
    [sql_database]     NVARCHAR (60)   NOT NULL,
    [sql_esquema]      NVARCHAR (30)   NOT NULL,
    [sql_user]         NVARCHAR (30)   NOT NULL,
    [sql_pasword]      NVARCHAR (30)   NOT NULL,
    [create_date]      DATETIME        NULL,
    [register_user]    NVARCHAR (15)   NULL,
    [modify_date]      DATETIME        NULL,
    [modify_user]      NVARCHAR (15)   NULL,
    [last_error]       NVARCHAR (4000) NULL,
    [status]           INT             NULL,
    [porc_equal]       INT             CONSTRAINT [DF_t_PlantillaH_porc_equal] DEFAULT ((0)) NOT NULL,
    [execute_user]     NVARCHAR (15)   NULL,
    [execute_date]     SMALLDATETIME   NULL,
    [execute_time]     NVARCHAR (25)   NULL,
    [affected_row]     INT             CONSTRAINT [DF_t_PlantillaH_affected_row] DEFAULT ((0)) NOT NULL,
    [plan_type]        NCHAR (5)       NULL,
    [plan_califica]    BIT             CONSTRAINT [DF_t_PlantillaH_plan_califica] DEFAULT ((0)) NULL,
    [add_data]         BIT             NULL,
    [add_where]        NVARCHAR (1000) NULL,
    [instance_source]  NVARCHAR (50)   NULL,
    CONSTRAINT [PK_t_PlantillaH] PRIMARY KEY CLUSTERED ([plantilla_id] ASC)
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [NombrePlantillaIndex]
    ON [dabarc].[t_PlantillaH]([plan_name] ASC);

