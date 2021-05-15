WITH CTE_td_evs (Engine, Car)
AS
  (
SELECT
  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')
  AND
  EXISTS (
SELECT
td_pcl.[Article:Link]

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[Article:Link]
  )

GROUP BY
  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo

--ORDER BY
  --td_pc.[EngineType:Link]
  )

 SELECT Engine, Car
 FROM CTE_td_evs