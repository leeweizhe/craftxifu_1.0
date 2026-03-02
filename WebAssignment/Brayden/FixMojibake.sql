-- Fix common mojibake sequences in FullContent columns
SET NOCOUNT ON;

-- Replace common mojibake sequences with intended Unicode characters
UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'â†?', N' ¡ú ')
WHERE FullContent LIKE N'%â†?%';

UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'â€?', N' - ')
WHERE FullContent LIKE N'%â€?%';

UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'??¡¯', N' ¡ú ')
WHERE FullContent LIKE N'%??¡¯%';

UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'?€¡°', N'-')
WHERE FullContent LIKE N'%?€¡°%';

UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'?€¡±', N' - ')
WHERE FullContent LIKE N'%?€¡±%';

UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'?', N'')
WHERE FullContent LIKE N'%?%';

-- Some sequences can appear as two-character combinations; include common variants
UPDATE potionTable
SET FullContent = REPLACE(FullContent, N'????', N' ¡ú ')
WHERE FullContent LIKE N'%????%';

-- Apply same replacements to enchantmentTable FullContent
UPDATE enchantmentTable
SET FullContent = REPLACE(FullContent, N'â†?', N' ¡ú ')
WHERE FullContent LIKE N'%â†?%';

UPDATE enchantmentTable
SET FullContent = REPLACE(FullContent, N'â€?', N' - ')
WHERE FullContent LIKE N'%â€?%';

UPDATE enchantmentTable
SET FullContent = REPLACE(FullContent, N'??¡¯', N' ¡ú ')
WHERE FullContent LIKE N'%??¡¯%';

UPDATE enchantmentTable
SET FullContent = REPLACE(FullContent, N'?€¡°', N'-')
WHERE FullContent LIKE N'%?€¡°%';

UPDATE enchantmentTable
SET FullContent = REPLACE(FullContent, N'?€¡±', N' - ')
WHERE FullContent LIKE N'%?€¡±%';

UPDATE enchantmentTable
SET FullContent = REPLACE(FullContent, N'?', N'')
WHERE FullContent LIKE N'%?%';

-- Show rows that still contain suspicious characters for manual review
PRINT 'Rows in potionTable with suspicious characters:';
SELECT PotionId, FullContent FROM potionTable
WHERE FullContent LIKE N'%â†?%' OR FullContent LIKE N'%â€?%' OR FullContent LIKE N'%??%' OR FullContent LIKE N'%??%' OR FullContent LIKE N'%?%';

PRINT 'Rows in enchantmentTable with suspicious characters:';
SELECT EnchantmentId, FullContent FROM enchantmentTable
WHERE FullContent LIKE N'%â†?%' OR FullContent LIKE N'%â€?%' OR FullContent LIKE N'%??%' OR FullContent LIKE N'%??%' OR FullContent LIKE N'%?%';

PRINT 'Done.';
