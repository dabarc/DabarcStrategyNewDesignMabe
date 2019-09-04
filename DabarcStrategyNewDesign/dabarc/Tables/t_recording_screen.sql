CREATE TABLE [dabarc].[t_recording_screen] (
    [screen_id]         INT            IDENTITY (1, 1) NOT NULL,
    [script_id]         INT            NOT NULL,
    [screen_title]      NVARCHAR (200) NULL,
    [screen_position]   INT            NOT NULL,
    [screen_sapname]    NVARCHAR (100) NOT NULL,
    [screen_sapno]      NCHAR (10)     NOT NULL,
    [screen_typestruc]  NCHAR (10)     NOT NULL,
    [screen_nofields]   INT            NULL,
    [usuario_alta]      NVARCHAR (100) NULL,
    [fecha_alta]        DATETIME       NULL,
    [usuario_modifica]  NVARCHAR (100) NULL,
    [fecha_modifica]    DATETIME       NULL,
    [screen_fieldview]  NCHAR (30)     NULL,
    [screen_fieldwhere] NVARCHAR (100) NULL,
    CONSTRAINT [PK_t_recording_screen] PRIMARY KEY CLUSTERED ([screen_id] ASC)
);

