CREATE TABLE [dabarc].[t_LogServices] (
    [key_date] NVARCHAR (16)  NOT NULL,
    [status]   NCHAR (10)     NOT NULL,
    [text]     NVARCHAR (250) NULL,
    [TodayIs]  SMALLDATETIME  CONSTRAINT [DF_t_LogServices_TodayIs] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_t_LogServices] PRIMARY KEY CLUSTERED ([key_date] ASC)
);

