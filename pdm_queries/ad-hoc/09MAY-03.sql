
/*
  List the products in TecDoc that are available for electric vehicles (EVs).
*/
SELECT TOP 40
  --COUNT(DISTINCT(td_art.[ArticleNo]))
  td_art.[ArticleNo],
  td_pcl.[Article:Link],
  td_pc2.[LinkingTarget:Link]

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 
-- Links to articles for passenger cars (PKW or PC)
   JOIN (SELECT td_pcl.[Article:Link]
         FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl
	     GROUP BY td_pcl.[Article:Link]) as td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
-- Links to articles for passenger cars (PKW or PC)
   JOIN (SELECT td_pc2.[LinkingTarget:Link]
         FROM dbo.[TecDoc.Linkages.PassengerCars] td_pc2
	     GROUP BY td_pc2.[LinkingTarget:Link]) as td_pc2 ON td_pcl.[Article:Link] = CAST(td_pc2.[LinkingTarget:Link] as varchar)

/*
-- Links to passenger cars (PKW or PC)
   JOIN (SELECT td_pc.[PassengerCarNo]
         FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc
         WHERE td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')
	    ) as td_pc ON td_art.[ArticleNo] = td_pcl.[Article:Link]

--   INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc  ON td_pc.[PassengerCarNo] = td_pcl.[LinkingTarget:Link] 
*/
WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles with an active status
  AND
  td_art.[State:Link] = '73-001'
  -- Get electric vehicles

ORDER BY
td_art.[ArticleNo]

-- 6903998 Articles
-- 4782598 Articles for cars