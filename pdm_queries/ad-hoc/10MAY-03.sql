
-- Get the acticles in TecDoc that reference passenger cars (PC or PKWs). 
-- Counting the number of links shows the most popular products by links or references to cars.
-- 5556824 articles
td_art_pc_CTE (TDArtPCNr)
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

-- Get the passenger cars in TecDoc that have a reference to an article. 
-- 85120 Links to passenger cars
td_pc_CTE (TDPCNr)
AS(

SELECT DISTINCT
td_pcl.[LinkingTarget:Link]
--COUNT(DISTINCT(td_pcl.[LinkingTarget:Link]))

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[LinkingTarget:Link]

),

-- Get the electric vehicles (EVs) in TecDoc.
-- EngineType   Count
-- 80-046       337
-- 80-040       398
-- 80-048       191
td_ev_CTE (TDEVNr)
AS(

SELECT
--  td_pc.[EngineType:Link],
--  COUNT(td_pc.PassengerCarNo)
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

GROUP BY
--  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo

)

