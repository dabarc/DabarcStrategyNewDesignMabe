CREATE TABLE [dabarc].[t_ODBC_driver] (
    [driver_id]   INT            NOT NULL,
    [driver_dbms] NVARCHAR (50)  NOT NULL,
    [driver_text] NVARCHAR (140) NOT NULL,
    [create_date] DATE           NOT NULL,
    [driver_cva]  NCHAR (10)     NULL,
    CONSTRAINT [PK_t_ODBC_driver] PRIMARY KEY CLUSTERED ([driver_id] ASC)
);

