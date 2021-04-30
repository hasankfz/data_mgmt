/*

 Description: This query counts the number of products that are available at carpardoo.pl. The query is the same as the "Abfragen Report > W-(F) Kaufbar Polen" view in the PDM. 
 
 See https://kfzteile24.atlassian.net/browse/PDM-76 for more details.

*/ 

SELECT  COUNT (base.[:Id]) 
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.SubCategories] T2 WITH (NOLOCK) ON T2.[SubCategoryNo] = [T1].[SubCategory:Link]
  LEFT OUTER JOIN [dbo].[MasterData.ResponsiblePersonsForArticles] T3 WITH (NOLOCK) ON T3.[ResponsiblePersonNo] = [T2].[ResponsiblePerson:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T5 WITH (NOLOCK) ON T5.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T6 WITH (NOLOCK) ON T6.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Lookup.ArticleTypes] T7 WITH (NOLOCK) ON T7.[ArticleTypeNo] = [T1].[ArticleType:Link]
 WHERE (((EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias10 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias10.[HasActiveGenArtManufacturerPrio <PL>],0) = 1
                                                        AND base.ArticleID = Alias10.[Article:Link])) AND (T4.[IsBuyableInWebshop <PL>] = 1))) AND (EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias11 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias11.[HasActiveGenArtManufacturerPrio <PL>],0) = 1
                                                        AND base.ArticleID = Alias11.[Article:Link])) AND (T4.[IsBuyableInWebshop <PL>] = 1)
