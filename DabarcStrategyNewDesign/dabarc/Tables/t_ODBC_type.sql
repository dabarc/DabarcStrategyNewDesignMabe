CREATE TABLE [dabarc].[t_ODBC_type] (
    [type_id]             INT           NOT NULL,
    [driver_id]           INT           NOT NULL,
    [type_name]           NVARCHAR (50) NOT NULL,
    [type_operasize]      NCHAR (5)     NULL,
    [type_valuesize]      INT           NULL,
    [type_operascale]     NCHAR (5)     NULL,
    [type_valuescale]     INT           NULL,
    [type_operaprecision] NCHAR (5)     NULL,
    [type_valueprecision] INT           NULL,
    [MSS_type]            NVARCHAR (50) NOT NULL,
    [MSS_size]            INT           NULL,
    [MSS_scale]           INT           NULL,
    [MSS_precision]       INT           NULL,
    [type_copy_size]      BIT           NULL,
    [create_date]         SMALLDATETIME NOT NULL,
    [register_user]       NVARCHAR (15) NOT NULL,
    [rule_name]           NVARCHAR (50) NULL,
    CONSTRAINT [PK_t_ODBC_type] PRIMARY KEY CLUSTERED ([type_id] ASC)
);

