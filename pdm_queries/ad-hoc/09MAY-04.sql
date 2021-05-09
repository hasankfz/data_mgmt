SELECT
--  COUNT(DISTINCT(td_pcl.[Article:Link])) -- 5556824
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

ORDER BY
  td_pcl.[Article:Link]

/*
JOIN (SELECT td_pcl.[Article:Link]
         FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl
	     GROUP BY td_pcl.[Article:Link]) as td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
*/