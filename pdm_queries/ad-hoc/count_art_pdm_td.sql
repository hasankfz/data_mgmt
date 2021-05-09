/*
   Count the number of products in the PDM and in TecDoc with an active status.
*/

SELECT 
  COUNT(DISTINCT(td_art.[ArticleNo])) as "TD-Art",
  COUNT(DISTINCT(art_td.[TecDoc.Link])) as "PDM-Art",

  COUNT(DISTINCT(pdm_art.[ArticleID])) as "PDM-ArtID",
  COUNT(DISTINCT(pdm_art.[K24Number])) as "PDM-K24Nr"

-- Articles in PDM
FROM [dbo].[Article.Articles] pdm_art 
   LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] art_props ON art_props.[:Id] = pdm_art.[:Id]
-- TecDoc articles in the PDM
   LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] art_td ON pdm_art.[:Id] = art_td.[:Id] 
-- Articles in TecDoc
   LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles] td_art ON art_td.[TecDoc.Link] = td_art.[ArticleNo] 

WHERE
  -- Include articles with an active status in the PDM
  art_props.[ArticleStatus:Link] = '1'
  -- Use the latest dataset
  AND
  td_art.[ImportVersionNo] = '20210401' -- art_td.[TecDoc.Version] = '20210401'  
  -- Get articles with an active status in TecDoc
  AND
  td_art.[State:Link] = '73-001' -- art_td.[Status:Link] = '73-001'

/*
  2021-05-09
  ----------
  TD-Art  PDM-Art  PDM-ArtID  PDM-K24Nr
                   3954780    3154206   Articles in the PDM
                   2035526    2031679   Articles in the PDM with an active status
  1782800 1782800  1840685    1840041   Articles in the PDM with an active status from TecDoc 
*/