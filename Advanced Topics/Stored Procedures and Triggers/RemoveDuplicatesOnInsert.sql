CREATE TRIGGER RemoveDuplicatesOnInsert  
ON TargetTable  
AFTER INSERT  
AS  
BEGIN  

    -- Log or Archive Duplicates (Optional)
    INSERT INTO DuplicateLog (Column1, Column2, ...)  
    SELECT Column1, Column2, ...  
    FROM INSERTED I  
    WHERE EXISTS (  
        SELECT 1  
        FROM TargetTable T  
        WHERE T.Column1 = I.Column1  
          AND T.Column2 = I.Column2  
    );
  
    -- Remove duplicates based on a specific set of columns  
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
