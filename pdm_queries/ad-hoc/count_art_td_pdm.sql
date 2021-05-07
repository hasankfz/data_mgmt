/*
   Count the number of products in TecDoc and in the PDM with an active status
    
*/
SELECT DISTINCT 

  COUNT(td_art.[ArticleNo]) as "TD-Art",
  COUNT(art_td.[TecDoc.Link]) as "PDM-Art",

  COUNT(art.[ArticleID]) as "PDM-ArtID",
  COUNT(art.[K24Number]) as "PDM-K24Nr"

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 
-- TecDoc articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td WITH (NOLOCK) ON art_td.[TecDoc.Link] = td_art.[ArticleNo] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
-- Articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles] art WITH (NOLOCK) ON art.[:Id] = art_td.[:Id]
  LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props WITH (NOLOCK) ON art_props.[:Id] = art.[:Id]

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401' -- art_td.[TecDoc.Version] = '20210401'  
  -- Get articles with an active status in TecDoc
  AND
  td_art.[State:Link] = '73-001' -- art_td.[Status:Link] = '73-001'
  -- Include articles from the German market
  AND
  art_td.[IsValid <DE>] = '1'
  -- Include articles with an active status
  AND
  art_props.[ArticleStatus:Link] = '1'
 
/*
  TODO:

  2021-05-07
  ----------
  TD-Art  PDM-Art  PDM-ArtID  PDM-K24Nr
  2655581 2655581  2655581    2044787   Articles in TecDoc with an active status
  1809900 1809900  1809900    1809327   Articles in the PDM with an active status

*/
  