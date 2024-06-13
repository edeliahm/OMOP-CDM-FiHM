use BBDD_EmilianoDelia

DECLARE @schema_name NVARCHAR(128) = 'bbdd_emilianodelia'; -- Replace 'YourSchemaName' with the name of your schema
DECLARE @sql NVARCHAR(MAX) = N'';

-- Generate DROP INDEX statements for each index in the specified schema
SELECT @sql += 'DROP INDEX ' + QUOTENAME(OBJECT_SCHEMA_NAME(indexes.object_id)) + '.' + QUOTENAME(object_name(indexes.object_id)) + '.' + QUOTENAME(indexes.name) + ';' + CHAR(13)
FROM sys.indexes
INNER JOIN sys.objects ON indexes.object_id = objects.object_id
WHERE OBJECT_SCHEMA_NAME(objects.schema_id) = @schema_name;

-- Execute the generated SQL
EXEC sp_executesql @sql;

