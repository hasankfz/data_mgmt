/*
   Count the number of products for electric vehicles in TecDoc and in the PDM 
    
*/
SELECT TOP 40
/*
  COUNT(DISTINCT(td_art.[ArticleNo])) as "TD-Art",
  COUNT(DISTINCT(art_td.[TecDoc.Link])) as "PDM-Art",

  COUNT(DISTINCT(pdm_art.[ArticleID])) as "PDM-ArtID",
  COUNT(DISTINCT(pdm_art.[K24Number])) as "PDM-K24Nr"
*/
  td_art.[ArticleNo] as "TD-Art",
--  art_td.[TecDoc.Link] as "PDM-Art",
  pdm_art.[ArticleID] as "PDM-ArtID",
  pdm_art.[K24Number] as "PDM-K24Nr"

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 
  -- Links to articles for passenger cars (PKW or PC)
     INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link] 
     -- LEFT OUTER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_t1 ON td_t1.[Article:Link] = td_art.[ArticleNo]
  -- Links to passenger cars (PKW or PC)
     INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo] 
     -- LEFT OUTER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_t2 ON td_t2.[PassengerCarNo] = td_t1.[LinkingTarget:Link]

  -- TecDoc articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art.[ArticleNo] = art_td.[TecDoc.Link]
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
  -- Get electric vehicles
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

ORDER BY
  td_art.[ArticleNo],
  pdm_art.[ArticleID],
  pdm_art.[K24Number]
   
/*
  TODO:

  -- Get the products that dont have a K24-Nr
  AND
  art.[K24Number] IS NULL

  TD-Art   PDM-Art  PDM-ArtID  PDM-K24Nr
  112696   112696   116491     116430
*/
