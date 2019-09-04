CREATE TABLE [dabarc].[t_recording_fields] (
    [field_id]          INT            IDENTITY (1, 1) NOT NULL,
    [screen_id]         INT            NOT NULL,
    [field_SAPname]     NVARCHAR (50)  NOT NULL,
    [field_SAP]         NVARCHAR (100) NULL,
    [field_description] NVARCHAR (500) NULL,
    [field_typeentry]   NCHAR (10)     NOT NULL,
    [usuario_alta]      NVARCHAR (100) NULL,
    [fecha_alta]        DATETIME       NULL,
    [usuario_modifica]  NVARCHAR (100) NULL,
    [fecha_modifica]    DATETIME       NULL,
    [field_fieldview]   NCHAR (30)     NULL,
    [field_fieldspace]  BIT            NULL,
    CONSTRAINT [PK_t_recording_fields] PRIMARY KEY CLUSTERED ([field_id] ASC)
);

