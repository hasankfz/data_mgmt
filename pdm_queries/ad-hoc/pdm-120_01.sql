/*
   Join article data in PDM with TecDoc data in PDM
*/

SELECT TOP 100
  base.[:Id] as "ArtID", 
  T2.[:Id] as "TD-ArtID",

  base.[ArticleID], 
  base.[K24Number], 
  T2.[TecDoc.ArtNo],

  base.[ManufacturerArticleNo]
  
  
FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles] T3 WITH (NOLOCK) ON T3.[ArticleNo] = T2.[TecDoc.ArtNo]
 
 
WHERE base.[K24Number] IS NOT NULL
  AND T2.[TecDoc.ArtNo] IS NOT NULL

ORDER BY base.[ArticleID]