/*
SQL migration: add Variant column to userInventoryTable.
Run this against your application database (e.g., in SSMS or Visual Studio SQL Server Object Explorer).
This adds a NOT NULL NVARCHAR(20) column with default 'name' for existing rows.
*/

IF COL_LENGTH('dbo.userInventoryTable', 'Variant') IS NULL
BEGIN
    ALTER TABLE dbo.userInventoryTable
    ADD Variant NVARCHAR(20) NOT NULL CONSTRAINT DF_userInventoryTable_Variant DEFAULT('name');
END
ELSE
BEGIN
    PRINT 'Column Variant already exists on dbo.userInventoryTable';
END
