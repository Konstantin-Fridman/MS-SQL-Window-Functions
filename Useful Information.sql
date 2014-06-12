/*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*\
 Always use the `ROWS BETWEEN` window :
	RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
 This flow is slowly then:
	ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
\*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
-- Remark: The window definition should be unique
   SELECT actid,
		  /*Bad:*/ Sum(val) OVER( PARTITION BY actid ORDER BY tranid) AS balance
	   -- SQL automatically uses this form:
	   -- /*Bad:*/ Sum(val) OVER( PARTITION BY actid ORDER BY tranid RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
	   -- We should use this form:
	   -- /*OK:*/ Sum(val) OVER( PARTITION BY actid ORDER BY tranid ROW /*!!NB!!*/ BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS balance
    FROM dbo.Transactions; 
