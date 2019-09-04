CREATE TABLE [dabarc].[t_MAIL] (
    [mail_id]          INT            IDENTITY (1, 1) NOT NULL,
    [mail_active]      BIT            CONSTRAINT [DF_t_MAIL_mail_active] DEFAULT ((0)) NOT NULL,
    [mail_idobjects]   INT            NOT NULL,
    [mail_objectstype] NVARCHAR (500) NOT NULL,
    [mail_tablename]   NVARCHAR (100) NOT NULL,
    [mail_iduser]      INT            NULL,
    [mail_name]        NVARCHAR (100) NULL,
    [mail_email]       NVARCHAR (100) NULL,
    [mail_InfoOutput]  INT            NULL,
    [mail_insert]      DATETIME       NULL,
    [mail_user]        NVARCHAR (15)  NULL,
    [mail_individual]  BIT            NULL,
    CONSTRAINT [PK_t_MAIL] PRIMARY KEY CLUSTERED ([mail_id] ASC)
);

