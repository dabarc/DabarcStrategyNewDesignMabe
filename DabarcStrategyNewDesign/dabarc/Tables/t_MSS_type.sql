CREATE TABLE [dabarc].[t_MSS_type] (
    [MSS_TypeId]    INT           NOT NULL,
    [MSS_Type]      NVARCHAR (50) NOT NULL,
    [create_date]   SMALLDATETIME NOT NULL,
    [register_user] NVARCHAR (15) NOT NULL,
    CONSTRAINT [PK_t_MSS_type] PRIMARY KEY CLUSTERED ([MSS_TypeId] ASC)
);

