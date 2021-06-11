/*
  Create a list of articles that do not have pictures (images) in the PDM. 
*/
SELECT
   (CASE
     WHEN mdResPers.[Name] IS NULL
     THEN 'Nicht zugewiesen'
     ELSE mdResPers.[Name]
     END) AS Verantwortlicher,

   art.ArticleID,
   art.[Manufacturer:Link] AS HLK,
   art.ManufacturerArticleNo AS ArtN,
   art.K24Number,
   artText.[ArticleDesignation <de>] AS ArtikelText,
   CAST(art.[:Log.CreatedAt] as DATE) AS created_at,
   CAST(art.[:Log.LastModAt] as DATE) AS lastmod_at

FROM [Article.Articles] AS art
   LEFT JOIN [Article.Articles:ArticleProperties] AS artProp ON art.[:Id] = artProp.[:Id]
   LEFT JOIN [Article.Articles:Texts] AS artText ON art.[:Id] = artText.[:Id]
   LEFT JOIN [Article.Articles:UDF ArticleManagement] AS artUDF ON art.[:Id] = artUDF.[:Id]
   LEFT JOIN [MasterData.SubCategories] AS mdSubCat ON artProp.[SubCategory:Link] = mdSubCat.[:Caption]
   LEFT JOIN [MasterData.ResponsiblePersonsForArticles] AS mdResPers ON mdSubCat.[ResponsiblePerson:Link] = mdResPers.[ResponsiblePersonNo]
     
WHERE
   artProp.[ArticleStatus:Link] = 1
   AND
   artUDF.[Artikel ohne Bild] = 1
/*
   -- Get articles that were created in 2021
   AND
   YEAR(art.[:Log.CreatedAt]) = '2021'
*/

ORDER BY
   mdResPers.[Name],
   art.[:Log.LastModAt] DESC;

/*
  TODO:
  - Improve handling of K24-Nr
*/