CREATE TRIGGER RemoveDuplicatesOnInsert  
ON TargetTable  
AFTER INSERT  
AS  
BEGIN

    -- Log or Archive Duplicates (Optional) based on INSERTED table
    INSERT INTO DuplicateLog (Column1, Column2, ...)  
    SELECT T.Column1, T.Column2, ...
    FROM
    (
    SELECT *
    , DupRank = ROW_NUMBER() OVER (
                  PARTITION BY Column1, Column2
                  ORDER BY (SELECT NULL)
                )
    FROM INSERTED
    ) AS T
    WHERE DupRank > 1 
    
    -- Remove duplicates from the INSERTED table
    DELETE T
    FROM
    (
    SELECT *
    , DupRank = ROW_NUMBER() OVER (
                  PARTITION BY Column1, Column2
                  ORDER BY (SELECT NULL)
                )
    FROM INSERTED
    ) AS T
    WHERE DupRank > 1 

    -- Log or Archive Duplicates (Optional) based on target table
    INSERT INTO DuplicateLog (Column1, Column2, ...)  
    SELECT Column1, Column2, ...  
    FROM INSERTED I  
    WHERE EXISTS (  
        SELECT 1  
        FROM TargetTable T  
        WHERE T.Column1 = I.Column1  
          AND T.Column2 = I.Column2  
    );
  
    -- Remove duplicates based on a specific set of columns with values in targeted table
    DELETE I  
    FROM INSERTED I  
    INNER JOIN TargetTable T  
        ON T.Column1 = I.Column1  
       AND T.Column2 = I.Column2;  

    -- Insert only unique rows into the target table  
    INSERT INTO TargetTable (Column1, Column2, ...)  
    SELECT Column1, Column2, ...  
    FROM INSERTED I  
    WHERE NOT EXISTS (  
        SELECT 1  
        FROM TargetTable T  
        WHERE T.Column1 = I.Column1  
          AND T.Column2 = I.Column2  
    ); 

END;  
