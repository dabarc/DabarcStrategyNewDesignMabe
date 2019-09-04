CREATE TABLE [dabarc].[t_scriptInfclean] (
    [idsinfo]          INT             NOT NULL,
    [topic]            NVARCHAR (100)  NOT NULL,
    [name_information] NVARCHAR (100)  NOT NULL,
    [description]      NVARCHAR (1000) NOT NULL,
    [script]           NVARCHAR (4000) NULL,
    CONSTRAINT [PK_t_script_infclean] PRIMARY KEY CLUSTERED ([idsinfo] ASC)
);

