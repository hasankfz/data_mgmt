SELECT 
  COUNT(DISTINCT(td_art.[ArticleNo]))
  -- td_art.[ArticleNo]

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 

JOIN 
(
    SELECT
td_pcl.[Article:Link]

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

WHERE 
--  td_pcl.[LinkingTarget:Link] = EVS
  EXISTS (
SELECT
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')
)

GROUP BY
  td_pcl.[Article:Link]
) as td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]  

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles with an active status
  AND
  td_art.[State:Link] = '73-001'
  -- Get electric vehicles

--ORDER BY
--td_art.[ArticleNo]

-- 6903998 Articles
-- 4782598 Articles for cars
--         Articles for electric vehicles