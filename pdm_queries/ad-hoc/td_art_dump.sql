/*
   Count the number of products in TecDoc and in the PDM with an active status
    
*/
SELECT DISTINCT TOP 45000

  td_art.[ArticleNo] as "TD-ArticleNo",
--  art_td.[TecDoc.Link] as "PDM-Art",

  td_art.[ArtNo] as "TD-ArtNo", 
--  art_td.[TecDoc.ArtNo],
  art.[ManufacturerArticleNo],

  art.[ArticleID] as "PDM-ArticleID",
  art.[K24Number] as "PDM-K24Nr",

  --  td_art.[Manufacturer:Link],
  art.[Manufacturer:Link],
  td_art.[DataSupplier:Link]  

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 
-- TecDoc articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON art_td.[TecDoc.Link] = td_art.[ArticleNo] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
-- Articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles] art ON art.[:Id] = art_td.[:Id]
  LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON art_props.[:Id] = art.[:Id]

WHERE
  -- Use the latest dataset
  (td_art.[ImportVersionNo] = '20210401' OR art_td.[TecDoc.Version] = '20210401')  
  -- Get articles that are active in TecDoc and in the PDM
  AND
  (td_art.[State:Link] = '73-001' OR art_td.[Status:Link] = '73-001')
  -- Include articles in the German market
  AND
  art_td.[IsValid <DE>] = '1'
  -- Include articles with an active status
  AND
  art_props.[ArticleStatus:Link] = '1'
  AND art.[Manufacturer:Link] NOT LIKE '9%'

ORDER BY
  art.[ArticleID],
  art.[K24Number]
 /*
  TODO:

  2021-05-07
  ----------
  TD-Art  PDM-Art  PDM-ArtID  PDM-K24Nr
  2655892 2655892  2655892    2045093   ALL
  1809936 1809936  1809936    1809407   WITH ArticleStatus = '1'

 */
