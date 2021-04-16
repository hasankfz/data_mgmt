/*

 Description: This query counts the number of products that are available at carpardoo.nl. The query is the same as the "Abfragen Report > W-(F) Kaufbar Niederlande" view in the PDM. 
 
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
 WHERE (((T4.[IsBuyableInWebshop <NL>] = 1) AND (EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias7 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias7.[HasActiveGenArtManufacturerPrio <NL>],0) = 1
                                                        AND base.ArticleID = Alias7.[Article:Link])))) AND (T4.[IsBuyableInWebshop <NL>] = 1) AND (EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias8 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias8.[HasActiveGenArtManufacturerPrio <NL>],0) = 1
                                                        AND base.ArticleID = Alias8.[Article:Link]))
