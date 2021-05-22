SELECT DISTINCT -- 110545
   manu.[Name],
   COUNT(td_art.[ArticleNo]) as "Total"
/*
   manu.[TecDoc.Link],
   td_art.[DataSupplier:Link],

   manu.[ArticleBrand:Link],
   td_art.[Manufacturer:Link],

   manu.[IsActive <DE>]
*/

FROM [K24Pdm].[dbo].[MasterData.Manufacturers] manu
-- Add TecDoc articles
   LEFT OUTER JOIN dbo.[TecDoc.Articles.Articles] td_art ON manu.[TecDoc.Link] = td_art.[DataSupplier:Link] -- manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link]

JOIN (

SELECT DISTINCT -- 135415 links to articles for EVs
  td_pcl.[Article:Link]
--  COUNT(td_pcl.[LinkingTarget:Link]) as "COUNTY"

FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl 
-- Get a list of electric vehicles (EVs)
   JOIN (
         SELECT DISTINCT 
            td_pc.PassengerCarNo

         FROM
            dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

         WHERE
            td_pc.ImportVersionNo = '20210401'
            AND
            td_pc.[EngineType:Link] = ('80-040')
            AND
            td_pc.[FuelType:Link] = '182-011'

         GROUP BY
            td_pc.PassengerCarNo
        ) 
        td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.PassengerCarNo

GROUP BY
   td_pcl.[Article:Link]
/*
ORDER BY
   COUNTY DESC
*/
)
td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'  
   AND
-- Get articles with an active status
   td_art.[State:Link] = '73-001'
-- AND manu.[IsActive <DE>] IS NOT NULL [1=150 + 0=114 & NULL=518]

GROUP BY 
   manu.[Name]
   
ORDER BY 
   manu.[Name]
