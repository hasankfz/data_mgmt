/*
  Summarizes the number of articles for each manufacturer and the number of references to articles by car type--electric, hybrid, or combustion.
  Number of articles in TecDoc = 7000506
  Number of articles for cars  = 4272622 (TecDoc)
  Number of articles for cars  = 1511293 (PDM)
  Number of manufacturers      = 281
  */

SELECT 
   manu.[Name] as "BrandName",
   COUNT(pdm_art.ArticleID) as "Articles (PDM)",
   SUM(td_pcl.Electric) as Electric,
   SUM(td_pcl.Hybrid) as Hybrid,
   SUM(td_pcl.Combustion) as Combustion,
   SUM(td_pcl.Total) as Total

FROM [K24Pdm].[dbo].[MasterData.Manufacturers] manu
-- Add TecDoc articles
   INNER JOIN dbo.[TecDoc.Articles.Articles] td_art ON manu.[TecDoc.Link] = td_art.[DataSupplier:Link] -- manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link]
 
   INNER JOIN (
      SELECT
         td_pcl.[Article:Link],
         SUM(EV) as Electric,
         SUM(HV) as Hybrid,
         SUM(CE) as Combustion,
         COUNT(td_pcl.[Article:Link]) as "Total"

      FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl 
      -- Get the different vehicles by engine type
      JOIN (
       	 SELECT
            td_pc.PassengerCarNo,
            (CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
			        td_pc.[EngineType:Link] = ('80-040')
					AND
					td_pc.[FuelType:Link] = '182-011'
			   THEN 1
			   ELSE 0
			   END) as EV,
            (CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
					td_pc.[EngineType:Link] IN ('80-046','80-048','80-049')
			   THEN 1
			   ELSE 0
			   END) as HV,
			(CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
					td_pc.[EngineType:Link] NOT IN ('80-040','80-046','80-048','80-049')
			   THEN 1
			   ELSE 0
			   END) as CE

            FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 
			)  
        td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.PassengerCarNo

      GROUP BY
         td_pcl.[Article:Link] 

    ) td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]

-- Add TecDoc articles from the PDM
   LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art.[ArticleNo] = art_td.[TecDoc.Link] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
-- Articles in the PDM
   LEFT OUTER JOIN dbo.[Article.Articles] pdm_art ON art_td.[:Id] = pdm_art.[:Id]
   LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]

  
WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'  
   AND
-- Get articles with an active status
   td_art.[State:Link] = '73-001'
-- AND manu.[IsActive <DE>] IS NOT NULL 
-- Get the active articles in the PDM
   AND
   art_props.[ArticleStatus:Link] = '1'
-- Get the articles in the PDM that have a K24 number
   AND
   pdm_art.K24Number IS NOT NULL

GROUP BY
   manu.[Name]
