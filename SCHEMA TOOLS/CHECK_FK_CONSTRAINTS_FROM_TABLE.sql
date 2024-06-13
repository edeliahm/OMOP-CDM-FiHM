USE BBDD_EmilianoDelia;

DECLARE @TableName NVARCHAR(128) = 'CONDITION_OCCURRENCE';

-- Check Primary Key Constraint
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS ConstraintName,
    type_desc AS ConstraintType,
    NULL AS ColumnName,
    NULL AS ReferencedTableName,
    NULL AS ReferencedColumnName,
    NULL AS CheckDefinition
FROM 
    sys.key_constraints
WHERE 
    parent_object_id = OBJECT_ID(@TableName)
    AND type = 'PK'

UNION ALL

-- Check Unique Constraints
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS ConstraintName,
    type_desc AS ConstraintType,
    NULL AS ColumnName,
    NULL AS ReferencedTableName,
    NULL AS ReferencedColumnName,
    NULL AS CheckDefinition
FROM 
    sys.key_constraints
WHERE 
    parent_object_id = OBJECT_ID(@TableName)
    AND type = 'UQ'

UNION ALL

-- Check Foreign Key Constraints
SELECT 
    OBJECT_NAME(f.parent_object_id) AS TableName,
    f.name AS ConstraintName,
    'FK' AS ConstraintType,
    COL_NAME(fc.parent_object_id, fc.parent_column_id) AS ColumnName,
    OBJECT_NAME(f.referenced_object_id) AS ReferencedTableName,
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS ReferencedColumnName,
    NULL AS CheckDefinition
FROM 
    sys.foreign_keys AS f
INNER JOIN 
    sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id
WHERE 
    OBJECT_NAME(f.parent_object_id) = @TableName

UNION ALL

-- Check Check Constraints
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS ConstraintName,
    'CK' AS ConstraintType,
    NULL AS ColumnName,
    NULL AS ReferencedTableName,
    NULL AS ReferencedColumnName,
    definition AS CheckDefinition
FROM 
    sys.check_constraints
WHERE 
    parent_object_id = OBJECT_ID(@TableName);
