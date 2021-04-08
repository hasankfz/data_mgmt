-- https://kfzteile24.atlassian.net/browse/PDM-76

SELECT base.[:Id], 
       base.[K24Number], 
       base.[ManufacturerArticleNo], 
       T1.[Name], 
       T1.[:Id], 
       T3.[Designation], 
       T3.[:Id], 
       T2.[SubCategory:Link]
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[MasterData.Manufacturers] T1 WITH (NOLOCK) ON T1.[ManufacturerNo] = [base].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.SubCategories] T3 WITH (NOLOCK) ON T3.[SubCategoryNo] = [T2].[SubCategory:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
 WHERE (T4.[IsBuyableInWebshop <FR>] = 1) AND (EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias115 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias115.[HasActiveGenArtManufacturerPrio <FR>],0) = 1
                                                        AND base.ArticleID = Alias115.[Article:Link]))