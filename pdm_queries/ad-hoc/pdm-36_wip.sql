SELECT
  base.[ArticleID], 
  base.[Manufacturer:Link], 
  base.[K24Number], 
  T1.[ArticleStatus:Link], 
  base.[ManufacturerArticleNo], 
  T1.[UnitOfMeasure:Link], 
  T2.[ArticleDesignation <de>], 
  T1.[GenericArticle:Link], 
  T3.[IsActive]

FROM [dbo].[Article.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T1 WITH (NOLOCK) ON T1.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T2 WITH (NOLOCK) ON T2.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:DataWarehouseInformation] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] T5 WITH (NOLOCK) ON T5.[:Id] = [base].[:Id]

WHERE
  ((( NOT (select count([:ID]) from [Article.ArticleAttributes] Alias7 WITH (NOLOCK)  where Alias7.[Article:Link] = base.ArticleID) >= 1) AND (T5.[TecDoc.Link] IS NULL)))
  AND
  (NOT (base.[K24Number] IS NULL)) AND (EXISTS( SELECT *
                                                FROM    [Article.GenericArticleReferences] Alias8 WITH (NOLOCK)
                                                WHERE   ISNULL(Alias8.[HasActiveGenArtManufacturerPrio <DE>],0) = 1
                                                        AND base.ArticleID = Alias8.[Article:Link])) AND (T3.[IsBuyableInWebshop <DE>] = 1)

ORDER BY
  T4.[SalesQuantity12MonthsRolling] DESC,
  base.[ArticleID]