CREATE TABLE [dabarc].[t_recording_team] (
    [team_id]          INT            IDENTITY (1, 1) NOT NULL,
    [team_name]        NVARCHAR (100) NULL,
    [team_description] NVARCHAR (500) NULL,
    [no_trans]         INT            NULL,
    [usuario_alta]     NVARCHAR (100) NULL,
    [fecha_alta]       DATETIME       NULL,
    [usuario_modifica] NVARCHAR (100) NULL,
    [fecha_modifica]   DATETIME       NULL,
    [team_dbid]        INT            NULL,
    CONSTRAINT [PK_t_tema_recording] PRIMARY KEY CLUSTERED ([team_id] ASC)
);

