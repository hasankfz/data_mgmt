SELECT TOP 1000
       T1.[IsActive], -- Active in K24 catalog
       base.[ArticleID], 
       base.[K24Number], 
       base.[Manufacturer:Link], -- ATE is manufacturer
       T2.[TecDoc.Link], -- 3 is the link to the manufacturer
       base.[ManufacturerArticleNo], 
       T3.[ArticleStatus:Link], 
       T4.[ArticleDesignation <de>]
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.Manufacturers] T2 WITH (NOLOCK) ON T2.[ManufacturerNo] = [base].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
 WHERE 
  base.[Manufacturer:Link] LIKE 'ATE'
  AND T3.[ArticleStatus:Link] = '1' -- Is active in shops
 ORDER BY base.[ArticleID]