/*
SQL migration: create potionComment and enchantmentComment tables.
Run this against your application database (e.g., in SSMS or Visual Studio SQL Server Object Explorer).
*/

-- Create potionComment table
IF OBJECT_ID('dbo.potionComment', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.potionComment (
        CommentId INT PRIMARY KEY IDENTITY(1,1),
        PotionId INT NOT NULL,
        UserId INT NOT NULL,
        CommentText NVARCHAR(MAX) NOT NULL,
        CommentDate DATETIME NOT NULL DEFAULT(GETDATE()),
        Status NVARCHAR(20) NOT NULL DEFAULT('Visible'),
        FOREIGN KEY (PotionId) REFERENCES potionTable(PotionId),
        FOREIGN KEY (UserId) REFERENCES userTable(UserId)
    );
    PRINT 'Table potionComment created successfully';
END
ELSE
BEGIN
    PRINT 'Table potionComment already exists';
END
GO

-- Create enchantmentComment table
IF OBJECT_ID('dbo.enchantmentComment', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.enchantmentComment (
        CommentId INT PRIMARY KEY IDENTITY(1,1),
        EnchantmentId INT NOT NULL,
        UserId INT NOT NULL,
        CommentText NVARCHAR(MAX) NOT NULL,
        CommentDate DATETIME NOT NULL DEFAULT(GETDATE()),
        Status NVARCHAR(20) NOT NULL DEFAULT('Visible'),
        FOREIGN KEY (EnchantmentId) REFERENCES enchantmentTable(EnchantmentId),
        FOREIGN KEY (UserId) REFERENCES userTable(UserId)
    );
    PRINT 'Table enchantmentComment created successfully';
END
ELSE
BEGIN
    PRINT 'Table enchantmentComment already exists';
END
GO

-- Create reportTable if it doesn't exist (for team synchronization)
IF OBJECT_ID('dbo.reportTable', 'U') IS NULL
BEGIN
    CREATE TABLE [dbo].[reportTable] (
        [ReportId]   INT          IDENTITY (1, 1) NOT NULL,
        [CommentId]  INT          NOT NULL,
        [BeginnerId] INT          NULL,
        [MobId]      INT          NULL,
        [PotionId]   INT          NULL,
        [FarmId]     INT          NULL,
        [ReporterId] INT          NOT NULL,
        [ReportDate] DATETIME     DEFAULT (getdate()) NOT NULL,
        [Status]     VARCHAR (20) DEFAULT ('Pending') NOT NULL,
        PRIMARY KEY CLUSTERED ([ReportId] ASC)
    );
    PRINT 'Table reportTable created successfully';
END
ELSE
BEGIN
    PRINT 'Table reportTable already exists';
END
GO

-- Update reportTable to support PotionID and EnchantmentID if columns don't exist
IF COL_LENGTH('dbo.reportTable', 'PotionID') IS NULL
BEGIN
    ALTER TABLE dbo.reportTable
    ADD PotionID INT NULL;
    PRINT 'Column PotionID added to reportTable';
END
ELSE
BEGIN
    PRINT 'Column PotionID already exists in reportTable';
END

IF COL_LENGTH('dbo.reportTable', 'EnchantmentID') IS NULL
BEGIN
    ALTER TABLE dbo.reportTable
    ADD EnchantmentID INT NULL;
    PRINT 'Column EnchantmentID added to reportTable';
END
ELSE
BEGIN
    PRINT 'Column EnchantmentID already exists in reportTable';
END
GO

PRINT 'Migration complete: potionComment, enchantmentComment, and reportTable ready';
