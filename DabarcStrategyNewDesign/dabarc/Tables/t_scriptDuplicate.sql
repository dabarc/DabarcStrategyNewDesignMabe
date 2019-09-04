CREATE TABLE [dabarc].[t_scriptDuplicate] (
    [groupkey]     NCHAR (12)      NOT NULL,
    [tablename]    NVARCHAR (50)   NOT NULL,
    [fieldsname]   NVARCHAR (4000) NOT NULL,
    [typefield]    NCHAR (10)      NULL,
    [datecreate]   SMALLDATETIME   NOT NULL,
    [error]        NVARCHAR (500)  NOT NULL,
    [script_final] NVARCHAR (4000) NULL
);

