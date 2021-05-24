/*
  Shows the manufacturers and number of articles for hybrid vehicles (HVs)
*/

SELECT 
   manu.[Name] as "BrandName",
   COUNT(td_art.ArticleNo) as "Articles (TD)"

FROM [K24Pdm].[dbo].[MasterData.Manufacturers] manu
-- Add TecDoc articles
   INNER JOIN dbo.[TecDoc.Articles.Articles] td_art ON manu.[TecDoc.Link] = td_art.[DataSupplier:Link] -- manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link]
-- Add links to passenger cars 
   INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
-- Include electric vehicles (EVs)
   INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'  
   AND
-- Get articles with an active status
   td_art.[State:Link] = '73-001'
   AND
-- Get articles for hybrid vehicles
   td_pc.[EngineType:Link] IN ('80-046','80-048','80-049')
-- Get the active articles in the PDM

GROUP BY
   manu.[Name]

ORDER BY
   manu.[Name]