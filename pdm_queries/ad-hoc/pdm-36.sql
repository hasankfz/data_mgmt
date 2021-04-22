SELECT TOP 10
  T1.[IsActive], 
  T1.[IsBuyableInWebshop <DE>], 
  T2.[ArticleStatus:Link], 
  
  base.[ArticleID], 
  base.[K24Number], 
  base.[Manufacturer:Link], 
  base.[ManufacturerArticleNo], 
  
  T3.[ArticleDesignation <de>], 

  -- Categories
  T4.[GenericArticleNo], 
  T4.[Designation <de>], 

  -- Catman
  T6.[Name], 
  
  -- BI data
  T7.[ABCClassificationK24], 
  T7.[TurnoverRankK24], 
  T7.[TotalStockQuantity]
 
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.GenericArticles] T4 WITH (NOLOCK) ON T4.[GenericArticleNo] = [T2].[GenericArticle:Link]
  LEFT OUTER JOIN [dbo].[MasterData.SubCategories] T5 WITH (NOLOCK) ON T5.[SubCategoryNo] = [T2].[SubCategory:Link]
  LEFT OUTER JOIN [dbo].[MasterData.ResponsiblePersonsForArticles] T6 WITH (NOLOCK) ON T6.[ResponsiblePersonNo] = [T5].[ResponsiblePerson:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T7 WITH (NOLOCK) ON T7.[:Id] = [base].[:Id]
 
 WHERE
  T1.[IsActive] IS NULL 

 ORDER BY
   T6.[Name],
   T7.[ABCClassificationK24],
   base.[Manufacturer:Link],
   base.[ArticleID]