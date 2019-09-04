CREATE TABLE [dabarc].[AspParameters] (
    [ParameterId]            INT            IDENTITY (1, 1) NOT NULL,
    [RestartServiceData]     BIT            NOT NULL,
    [NumberServiceProcesses] INT            NOT NULL,
    [ReadingTime_service]    INT            NOT NULL,
    [ModifyDate]             DATETIME       NULL,
    [ModifyUser]             NVARCHAR (15)  NULL,
    [RestartServiceMessage]  NVARCHAR (200) NULL,
    [GridRumberTow]          INT            NULL,
    [NumberDaySerial]        INT            NULL,
    [MailNotification]       NVARCHAR (200) NULL,
    [ProfileIsNull]          NVARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([ParameterId] ASC)
);

