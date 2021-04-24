SELECT  TOP 100
       base.[ArticleID], 
       T1.[IsActive], 
       base.[K24Number], 
       base.[ManufacturerArticleNo], 
       T2.[ProductGroup:Link], 
       base.[Manufacturer:Link], 
       T2.[UnitOfMeasure:Link], 
       T3.[Artikel ohne Bild], 
       T2.[ArticleStatus:Link]
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:UDF ArticleManagement] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
 WHERE ((T3.[Artikel ohne Bild] = 1) AND (T2.[ArticleStatus:Link] = 1))
 ORDER BY base.[ArticleID]