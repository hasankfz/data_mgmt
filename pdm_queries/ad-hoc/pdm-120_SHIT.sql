/*
  Count the number of products in TecDoc that are for eletric vehicles (EVs).
*/
SELECT DISTINCT
   td_brand.Brand,
   COUNT(td_art.[ArticleNo]) as Electric
   --td_art.[DataSupplier:Link],
   --td_art.[Manufacturer:Link],

FROM dbo.[TecDoc.Articles.Articles] td_art 
-- Add links to passenger cars 
   INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
-- Include electric vehicles (EVs)
   INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]
-- Add brand name
   INNER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] td_brand ON td_art.[DataSupplier:Link] = td_brand.[DataSupplierNo]

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'
-- Get articles with an active status in TecDoc
   AND
   td_art.[State:Link] = '73-001'
-- Get articles for electric vehicles (EVs)
   AND
   td_pc.[EngineType:Link] = ('80-040')
   AND
   td_pc.[FuelType:Link] = '182-011'

GROUP BY
   td_brand.Brand
 