/*
   Join article data in PDM with TecDoc data in PDM
*/

SELECT DISTINCT
  COUNT(td_art.[ArticleNo]) as "TD-Art",
  COUNT(art_td.[TecDoc.Link]) as "PDM-Art",

  COUNT(art.[ArticleID]) as "PDM-ArtID",
  COUNT(art.[K24Number]) as "PDM-K24Nr"


FROM [dbo].[Article.Articles] art WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] art_props WITH (NOLOCK) ON art_props.[:Id] = art.[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] art_td WITH (NOLOCK) ON art_td.[:Id] = art.[:Id]
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles] td_art WITH (NOLOCK) ON td_art.[ArticleNo] = art_td.[TecDoc.Link]

WHERE
  -- Include articles with an active status
  art_props.[ArticleStatus:Link] = '1'
  -- Include articles from the German market
  AND
  art_td.[IsValid <DE>] = '1'
  -- Get articles with an active status in TecDoc
  AND
  td_art.[State:Link] = '73-001' -- art_td.[Status:Link] = '73-001' OR art_props.TecDocArticleStatusDE = '73-001'
 -- Use the latest dataset
  AND
  td_art.[ImportVersionNo] = '20210401' -- art_td.[TecDoc.Version] = '20210401'  
  
/*
  TODO:

  2021-05-07
  ----------
  TD-Art  PDM-Art  PDM-ArtID  PDM-K24Nr
                   3954780    3154206   Articles in the PDM
                   2035526    2031679   Articles in the PDM with an active status
                   1925573    1924717   Articles in the PDM with an active status that are valid in DE
  1809900 1809900  1809900    1809327   Articles in the PDM with an active status from TecDoc

*/