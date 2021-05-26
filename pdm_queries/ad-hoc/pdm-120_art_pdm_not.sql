/*
  Count the number of TecDoc products in the PDM that are for vehicles with combusion engines (not electric or hybrid vehicles).
*/
SELECT DISTINCT
   td_brand.Brand,
   COUNT(DISTINCT(pdm_art.ArticleID)) as "Articles (PDM)"
   --td_art.[DataSupplier:Link],
   --td_art.[Manufacturer:Link],

FROM dbo.[TecDoc.Articles.Articles] td_art 
-- Add links to passenger cars 
   INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
-- Include electric vehicles (EVs)
   INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]
-- Add brand name
   INNER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] td_brand ON td_art.[DataSupplier:Link] = td_brand.[DataSupplierNo]
-- Add TecDoc articles from the PDM
   INNER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art.[ArticleNo] = art_td.[TecDoc.Link] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
-- Articles in the PDM
   INNER JOIN dbo.[Article.Articles] pdm_art ON art_td.[:Id] = pdm_art.[:Id]
   INNER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'
-- Get articles with an active status in TecDoc
   AND
   td_art.[State:Link] = '73-001'
-- Get articles for vehicles with a combustion engine 
   AND
   td_pc.[EngineType:Link] NOT IN ('80-046','80-047','80-048','80-049')
-- Get articles for electric vehicles (EVs) with a hydgrogen engine
   OR
   ( td_pc.[EngineType:Link] = ('80-040')
     AND
     td_pc.[FuelType:Link] = '182-007' )
	
GROUP BY
   td_brand.Brand

ORDER BY
   td_brand.Brand
 