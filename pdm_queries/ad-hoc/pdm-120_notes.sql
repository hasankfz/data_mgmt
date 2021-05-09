
-- 1. Articles in TecDoc
dbo.[TecDoc.Articles.Articles] td_art

-- 2.  Links to the TecDoc articles related to passenger cars (PKW or PC)

-- 2.1 RESULTS CONTAIN DUPLICATES BECAUSE ARTICLES MAY HAVE LINKS TO ONE OR MORE CARS
SELECT
  td_pcl.[Article:Link],
  td_pcl.[GenericArticle:Link],
  td_pcl.[LinkingTarget:Link]

FROM
 dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[Article:Link],
  td_pcl.[GenericArticle:Link],
  td_pcl.[LinkingTarget:Link]

ORDER BY
  td_pcl.[Article:Link]

-- 2.2 
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

-- 3. List of electric vehicles (EVs)

SELECT
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

ORDER BY
  td_pc.PassengerCarNo

-- 4. Articles in PDM
