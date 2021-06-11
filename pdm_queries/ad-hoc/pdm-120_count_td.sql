/*
  Count the number of products in TecDoc that are for electric vehicles (EVs).
*/
SELECT 
   COUNT(DISTINCT(td_art.[ArticleNo])) as "Articles"

FROM dbo.[TecDoc.Articles.Articles] td_art 
-- Add links to passenger cars 
   INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
-- Include electric vehicles (EVs)
   INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'
-- Get articles with an active status in TecDoc
   AND
   td_art.[State:Link] = '73-001'
-- Get articles for electric vehicles (EVs)
   AND
   ( td_pc.[EngineType:Link] = ('80-040')
     AND
     td_pc.[FuelType:Link] = '182-011' )
