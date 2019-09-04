CREATE TABLE [dabarc].[t_ODBC_ctypes] (
    [type_id]             INT           IDENTITY (1, 1) NOT NULL,
    [driver_id]           INT           NOT NULL,
    [type_name]           NVARCHAR (50) NOT NULL,
    [type_valuesize]      INT           NULL,
    [type_valuescale]     INT           NULL,
    [type_valueprecision] INT           NULL,
    [type_Action]         NVARCHAR (10) NULL,
    [type_ActionforSize]  NVARCHAR (10) NULL,
    [MSS_type]            NVARCHAR (50) NOT NULL,
    [MSS_size]            INT           NULL,
    [MSS_scale]           INT           NULL,
    [MSS_precision]       INT           NULL,
    [create_date]         SMALLDATETIME NOT NULL,
    [register_user]       NVARCHAR (15) NOT NULL,
    [MSS_ReplaceValue]    NVARCHAR (50) NULL,
    CONSTRAINT [PK_t_ODBC_ctypes] PRIMARY KEY CLUSTERED ([type_id] ASC)
);

