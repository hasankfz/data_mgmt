/*
  Generate a list of the new products in our sortiment and send the results on a monthly basis to the retail shops.
*/

SELECT 
  base.[ArticleID] as "Artikel-ID", 
  base.[K24Number] as "K24-Nr", 
  base.[Manufacturer:Link] as "Hersteller", 
  base.[ManufacturerArticleNo] as "Hersteller-Art-Nr", 
  base.[InternalEAN] as "EAN", 
  T1.[ArticleStatus:Link] as "Status", 
  (CASE WHEN T2.[IsActiveSince] IS NULL THEN NULL
     ELSE CAST(YEAR(T2.[IsActiveSince]) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(T2.[IsActiveSince]) as varchar(2)), 2) + '-' + RIGHT('00' + CAST(DAY(T2.[IsActiveSince]) as varchar(2)), 2)
   END) as "Aktiv Seit", 
  T3.[SalesQuantity12MonthsRolling] as "Verkaufsquantität"
 
FROM [dbo].[Article.Articles] base 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T1 ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T2 ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T3 ON T3.[:Id] = [base].[:Id]
 
WHERE
-- Previous week
--  T2.[IsActiveSince] >=  DATEADD(wk, DATEDIFF(wk,7,GETDATE()), 0)
-- Previous month
   MONTH(T2.[IsActiveSince]) = MONTH(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) -1, 0))

ORDER BY
--  T2.[IsActiveSince] DESC,
  T3.[SalesQuantity12MonthsRolling] DESC,
  base.[ArticleID]