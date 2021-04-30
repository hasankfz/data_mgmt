SELECT TOP 100
  base.[ArticleID], 
  base.[K24Number], 
  T2.[SafetyDataSheetAvailable], 
  T3.[IsValid <DE>], 
  T4.[ProductIDCC], 
  T4.[IsArticleGroupCC], 
  T4.[RevisedOn], 
  T4.[ReplacesVersionOf], 
  T4.[VersionOfSDBByCC], 
  T5.[IsActive], 
  T5.[WebshopVisibility <DE>], 
  T6.[ABCClassificationK24], 
  T6.[TotalStockQuantity], 
  T7.[Name], 
  base.[Manufacturer:Link], 
  base.[ManufacturerArticleNo], 
  T8.[Designation <de>], 
  T9.[ArticleDesignation <de>], 
  T4.[IsCheckedByCC], 
  T4.[IsRegisteredCC], 
  T4.[IsDangerousGoods], 
  T4.[IsHazardousSubstance] 

FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:CountrySpecificProperties] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:CountrySpecificProperties <System.Countries>] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id] AND T2.[:System.Countries_Id] = '2b51cab3-2791-4f4a-89be-fc3b0b660eb5'
  LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T5 WITH (NOLOCK) ON T5.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T6 WITH (NOLOCK) ON T6.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.Manufacturers] T7 WITH (NOLOCK) ON T7.[ManufacturerNo] = [base].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[MasterData.GenericArticles] T8 WITH (NOLOCK) ON T8.[GenericArticleNo] = [T4].[GenericArticle:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T9 WITH (NOLOCK) ON T9.[:Id] = [base].[:Id]

WHERE
 T4.[ArticleStatus:Link] = '1'

ORDER BY
  T6.[ABCClassificationK24] ASC,
  T5.[IsActive], 
  T5.[WebshopVisibility <DE>], 
  base.[ArticleID]

/*
  TODO:
  - Create counts of T5.[IsActive]
*/