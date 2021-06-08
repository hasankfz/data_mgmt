/*

*/
SELECT
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
WHERE
 artProp.[ArticleStatus:Link] = 1 
 AND
 artUDF.[Artikel ohne Bild] = 1

 ORDER BY
 art.[:Log.LastModAt] DESC