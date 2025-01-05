--Variable Table (@Table)
--A lightweight, memory-optimized table used within a batch or stored procedure.

--✔️ Scope: Limited to the batch or procedure where it's declared.
--✔️ Storage: Stored in memory (or tempdb if overflow occurs).
--✔️ Performance: Faster for small datasets but not ideal for large data operations.
--✔️ Transactions: Not affected (changes cannot be rolled back).
--✔️ Indexes: Supports only constraints like primary keys during declaration.
--✔️ Use Case: Small, quick data manipulations in procedures or scripts.

--🛠 Example:
  
DECLARE @TableVar TABLE (ID INT, Name NVARCHAR(50));  
INSERT INTO @TableVar VALUES (1, 'Alice'), (2, 'Bob');  
SELECT * FROM @TableVar; 

--Temporary Table (#TempTable)
--A versatile table stored in tempdb and perfect for larger, complex tasks.

--✔️ Scope: Available for the session or batch. Can be accessed by nested procedures.
--✔️ Storage: Fully stored in tempdb.
--✔️ Performance: Better for larger datasets or when explicit indexing is needed.
--✔️ Transactions: Fully transaction-aware (changes can be rolled back).
--✔️ Indexes: Allows explicit indexing for better query optimization.
--✔️ Use Case: Complex operations, larger datasets, or queries requiring indexes.

--🛠 Example:

CREATE TABLE #TempTable (ID INT, Name NVARCHAR(50));  
INSERT INTO #TempTable VALUES (1, 'Alice'), (2, 'Bob');  
SELECT * FROM #TempTable;  
DROP TABLE #TempTable;  
