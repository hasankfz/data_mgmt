SELECT
  T4.[Artikelnummer],
  base.[ArticleID], 
  base.[K24Number], 
  T3.[ArticleDesignation <de>], 
  T2.[CustomsTariffNumber:Link]
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [ji_reporting].[dbo].[210419_Versand AT_Maerz] T4 ON T4.[Artikelnummer] = base.[K24Number]
 WHERE T4.[Artikelnummer] IS NOT NULL
 ORDER BY T4.[Artikelnummer]
