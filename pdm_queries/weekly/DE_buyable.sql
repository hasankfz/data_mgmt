/*

 Description: This query counts the number of products that are available in the German shops. The query is the same as the "Abfragen Report > W-(F) Kaufbar Deutschland" view in the PDM. 
 
 See https://kfzteile24.atlassian.net/browse/PDM-76 for more details.

*/ 
 
SELECT  COUNT (base.[:Id]) 
 FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.GenericArticles] T5 WITH (NOLOCK) ON T5.[GenericArticleNo] = [T4].[GenericArticle:Link]
 WHERE (((EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias13 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias13.[HasActiveGenArtManufacturerPrio <DE>],0) = 1
                                                        AND base.ArticleID = Alias13.[Article:Link])) AND (T3.[IsBuyableInWebshop <DE>] = 1))) AND (EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias14 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias14.[HasActiveGenArtManufacturerPrio <DE>],0) = 1
                                                        AND base.ArticleID = Alias14.[Article:Link])) AND (T3.[IsBuyableInWebshop <DE>] = 1)
