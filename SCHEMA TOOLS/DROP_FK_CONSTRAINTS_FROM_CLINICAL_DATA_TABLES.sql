USE BBDD_EmilianoDelia;

DECLARE @TableName NVARCHAR(MAX);
DECLARE @ConstraintName NVARCHAR(MAX);
DECLARE @DropConstraintSql NVARCHAR(MAX);

DECLARE TableCursor CURSOR FOR
SELECT t.name AS TableName, fk.name AS ConstraintName
FROM sys.tables t
JOIN sys.foreign_keys fk ON t.object_id = fk.parent_object_id
WHERE t.name IN ('PERSON', 'CARE_SITE', 'LOCATION', 'CONDITION_OCCURRENCE', 'DEATH', 'DRUG_EXPOSURE', 
                 'OBSERVATION', 'OBSERVATION_PERIOD', 'PROCEDURE_OCCURRENCE', 'PROVIDER', 'VISIT_DETAIL', 
                 'VISIT_OCCURRENCE', 'CONDITION_ERA', 'DOSE_ERA', 'META_DATA', 'EPISODE_EVENT', 'EPISODE');

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