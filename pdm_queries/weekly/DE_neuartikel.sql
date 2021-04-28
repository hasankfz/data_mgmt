/*
         Name: PDM-94 
  Description: Send the results of a weekly query to the retail shops that summarizes the new products in our sortiment. 
*/

SELECT TOP 100
  base.[ArticleID], 
  base.[Manufacturer:Link], 
  base.[K24Number], 
  base.[ManufacturerArticleNo], 
  base.[InternalEAN], 
  T1.[ArticleStatus:Link], 
  (CASE WHEN T2.[IsActiveSince] IS NULL THEN NULL
     ELSE CAST(YEAR(T2.[IsActiveSince]) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(T2.[IsActiveSince]) as varchar(2)), 2) + '-' + RIGHT('00' + CAST(DAY(T2.[IsActiveSince]) as varchar(2)), 2)
   END), 
  T3.[SalesQuantity12MonthsRolling]
 
FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
 
WHERE
 -- (((T2.[IsActiveSince] >= @p114) AND (T2.[IsActiveSince] < @p115)))
  CURRENT_TIMESTAMP >= DATEADD(week, DATEDIFF(week,0,GETDATE())-1,-1)

ORDER BY
   T3.[SalesQuantity12MonthsRolling] DESC,
   base.[ArticleID]