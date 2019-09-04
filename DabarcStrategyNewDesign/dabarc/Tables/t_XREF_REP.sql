CREATE TABLE [dabarc].[t_XREF_REP] (
    [xref_id]       INT             IDENTITY (1, 1) NOT NULL,
    [bdXref_id]     INT             NOT NULL,
    [type_bd]       NCHAR (10)      NULL,
    [tblXref_id]    INT             NULL,
    [table_name]    NVARCHAR (128)  NULL,
    [filename]      NVARCHAR (2000) NULL,
    [filename_new]  NVARCHAR (2000) NOT NULL,
    [description]   NVARCHAR (500)  NULL,
    [version]       INT             NOT NULL,
    [file_path]     NVARCHAR (2000) NULL,
    [path_source]   NVARCHAR (2000) NULL,
    [sheet_num]     INT             CONSTRAINT [DF_t_XREF_REP_sheet_num] DEFAULT ((1)) NOT NULL,
    [register_user] NVARCHAR (15)   NULL,
    [register_date] DATETIME        NULL,
    [delete_user]   NVARCHAR (15)   NULL,
    [delete_date]   DATETIME        NULL,
    [registered]    INT             CONSTRAINT [DF_t_XREF_REP_registered] DEFAULT ((1)) NULL,
    CONSTRAINT [PK_t_XREF_REP] PRIMARY KEY CLUSTERED ([xref_id] ASC)
);

