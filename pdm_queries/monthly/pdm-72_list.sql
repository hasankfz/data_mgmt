/*
  List the articles that we delivered as a part of the Sortimentserweiterung.
*/
SELECT DISTINCT
   (CASE 
	   WHEN art_cat.[IsActiveSince] IS NULL THEN NULL 
	   ELSE CAST(YEAR(art_cat.[IsActiveSince]) as varchar(4)) + '-' + RIGHT('00' + CAST(MONTH(art_cat.[IsActiveSince]) as varchar(2)), 2)
	   END) as "DateReport",
   pdm_art.[ArticleID],
   pdm_art.[K24Number],
--   art_cat.[IsActive],
   pdm_art.[Manufacturer:Link] as "Manufacturer",
   pdm_art.[ManufacturerArticleNo],
   CAST(pdm_art.[:Log.CreatedAt] as DATE) as "DateCreate",
   CAST(pdm_art.[:Log.LastModAt] as DATE) as "DateModify",
   pdm_art.[:Log.LastModBy]

FROM [dbo].[Article.Articles] pdm_art
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] art_cat ON  pdm_art.[:Id] = art_cat.[:Id]

WHERE
   CAST(art_cat.IsActiveSince as DATE) >= '2021-06-01'
   AND
   CAST(art_cat.IsActiveSince as DATE) <= '2021-06-30'
  
ORDER BY
   pdm_art.[ArticleID],
   pdm_art.[K24Number]
