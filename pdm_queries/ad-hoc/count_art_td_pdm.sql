/*
   Count the number of products in TecDoc and in the PDM with an active status.
    
*/
SELECT

  COUNT(DISTINCT(td_art.[ArticleNo])) as "TD-Art",
  COUNT(DISTINCT(art_td.[TecDoc.Link])) as "PDM-Art",

  COUNT(DISTINCT(pdm_art.[ArticleID])) as "PDM-ArtID",
  COUNT(DISTINCT(pdm_art.[K24Number])) as "PDM-K24Nr"

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 
-- TecDoc articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art.[ArticleNo] = art_td.[TecDoc.Link] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
-- Articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles] pdm_art ON art_td.[:Id] = pdm_art.[:Id]
  LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401' -- art_td.[TecDoc.Version] = '20210401'  
  -- Get articles with an active status in TecDoc
  AND
  td_art.[State:Link] = '73-001' -- art_td.[Status:Link] = '73-001'
  -- Include articles with an active status in the PDM
  AND
  art_props.[ArticleStatus:Link] = '1'
 
/*
  2021-05-16
  ----------
  TD-Art  PDM-Art  PDM-ArtID  PDM-K24Nr
  6903998 2528579  2761838    2076626   Articles in TecDoc with an active status
  1782449 1782449  1840331    1839692   Articles in the PDM with an active status

*/