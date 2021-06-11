/*
   Count the number of products in the PDM with an active status.
    
*/
SELECT

  COUNT(DISTINCT(pdm_art.[ArticleID])) as "PDM-ArtID",
  COUNT(DISTINCT(pdm_art.[K24Number])) as "PDM-K24Nr"

-- Articles in TecDoc
FROM dbo.[Article.Articles] pdm_art -- ON art_td.[:Id] = pdm_art.[:Id]
   LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]

WHERE
  -- Include articles with an active status in the PDM
  art_props.[ArticleStatus:Link] = '1'
 