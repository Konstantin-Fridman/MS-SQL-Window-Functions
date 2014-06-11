-- Useful information:

-- Fake the number of CPUs ( for an execution plan only ) 

DBCC OPTIMIZER_WHATIF(1, 64) --! 

SELECT top 
	   actid,
       tranid,
       val,
       Ntile(100)         OVER(           PARTITION BY actid           ORDER BY val) AS rownum
FROM   dbo.Transactions 
OPTION(RECOMPILE) --!


