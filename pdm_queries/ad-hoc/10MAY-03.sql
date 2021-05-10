
-- Get the acticles in TecDoc that are related to cars (PKWs). Counting the number of links shows the most popular products by links or references to cars.
td_art_pc_CTE (TDArtNr)
AS(

SELECT DISTINCT
td_pcl.[Article:Link]
--COUNT(td_pcl.[LinkingTarget:Link]) as "Counted"
--td_pcl.[GenericArticle:Link]

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[Article:Link]

),

-- Get the electric vehicles (EVs) in TecDoc.
td_art_ev_CTE (TDCarNr)
AS(

SELECT
  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

GROUP BY
  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo

)