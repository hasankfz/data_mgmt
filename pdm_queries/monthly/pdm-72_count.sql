/*
  Count the number of articles that we delivered as a part of the Sortimentserweiterung.
*/
SELECT DISTINCT
   COUNT(DISTINCT(pdm_art.[:Id]))
/*
   [:Id],
   [:Log.LastModBy],
   [:Log.LastModAt],
   [IsActive],
   [IsBuyableInWebshop <DE>],
   [CheckIsByable],
   [IsActiveSince]
*/

FROM [dbo].[Article.Articles] pdm_art
  LEFT OUTER JOIN [dbo].[Article.Articles:Catalog] art_cat ON  pdm_art.[:Id] = art_cat.[:Id]

WHERE
   CAST(art_cat.IsActiveSince as DATE) >= '2021-06-01'
   AND
   CAST(art_cat.IsActiveSince as DATE) <= '2021-06-30'
/*
   CAST(art_cat.IsActiveSince as DATE) >=  DATEADD(wk, DATEDIFF(wk,7,GETDATE()), 0)
*/

