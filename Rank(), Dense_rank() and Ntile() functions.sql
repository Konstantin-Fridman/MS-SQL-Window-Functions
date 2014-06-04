SET NOCOUNT ON
/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*\
| Build demo data
\*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
IF OBJECT_ID('tempdb..#Test') IS NOT NULL
    DROP TABLE #Test

CREATE TABLE #Test( TestId INT, Value DECIMAL(3,1))

INSERT INTO #Test( TestId, Value )
	 SELECT TOP 9
	 		TestId = 1 + ROW_NUMBER() OVER ( ORDER BY (SELECT NULL) ) % 2
		  , Value = 0.1 * ABS(CHECKSUM(CAST(NEWID() AS VARCHAR(100))) % 1000) 
	   FROM sys.columns

/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*\
| Example of Rank(), Dense_rank() and Ntile() functions
| ------ ----- ------------ ------ ------------ --------
| TestId Value Row_Number() RANK() DENSE_RANK() NTILE(3) /* 3 - means 3 equal-size groups */
| ------ ----- ------------ ------ ------------ --------
| 1      59.9  1            1      1            1
| 1      79.0  2            1      1            1
| 1      86.2  3            1      1            2
| 1      86.4  4            1      1            3
| 2      10.0  1            5      2            1
| 2      34.6  2            5      2            1
| 2      62.9  3            5      2            2 
| 2      66.2  4            5      2            2
| 2      93.0  5            5      2            3
\*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
	SELECT TestId
		  ,Value
		  ,Row_Number() OVER (PARTITION BY TestId ORDER BY Value) AS [Row_Number()]
		  ,RANK() OVER (ORDER BY TestId) AS [RANK()] -- Group's ID equals to Row_Number() value
		  ,DENSE_RANK() OVER (ORDER BY TestId) AS [DENSE_RANK()] -- Group's ID is sequential
		  ,NTILE(3) OVER (PARTITION BY TestId ORDER BY Value) AS [NTILE(3)] -- Number of groups
	  FROM #Test
  ORDER BY TestId
		 , Value
