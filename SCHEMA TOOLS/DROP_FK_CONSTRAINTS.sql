USE BBDD_EmilianoDelia

DECLARE @TableName NVARCHAR(MAX);
DECLARE @ConstraintName NVARCHAR(MAX);
DECLARE @DropConstraintSql NVARCHAR(MAX);

DECLARE TableCursor CURSOR FOR
SELECT t.name AS TableName, fk.name AS ConstraintName
FROM sys.tables t
JOIN sys.foreign_keys fk ON t.object_id = fk.parent_object_id

OPEN TableCursor;
FETCH NEXT FROM TableCursor INTO @TableName, @ConstraintName;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @DropConstraintSql = 'ALTER TABLE ' + QUOTENAME(@TableName) + ' DROP CONSTRAINT ' + QUOTENAME(@ConstraintName);
    EXEC(@DropConstraintSql);
    
    FETCH NEXT FROM TableCursor INTO @TableName, @ConstraintName;
END

CLOSE TableCursor;
DEALLOCATE TableCursor;
