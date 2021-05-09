/*
   Dump the number of products for electric vehicles in TecDoc with an active status
    
*/
SELECT DISTINCT
--  COUNT(td_art.[ArticleNo]) as "TD-ArtNr"

td_art.[ArticleNo] as "TD-ArticleNo",
td_pc.[PassengerCarNo],
COUNT(*)

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 
  -- Links to articles for passenger cars (PKW or PC)
     INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl WITH (NOLOCK) ON td_pcl.[Article:Link] = td_art.[ArticleNo]
  -- Links to passenger cars (PKW or PC)
     INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc WITH (NOLOCK) ON td_pc.[PassengerCarNo] = td_pcl.[LinkingTarget:Link] 
  -- Cars in the German market 
     LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] td_pc_de WITH (NOLOCK) ON td_pc_de.[:Id] = td_pc.[:Id]
                 AND td_pc_de.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'
 
WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles with an active status
  AND
  td_art.[State:Link] = '73-001'
  -- Get electric vehicles
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

GROUP BY
  td_art.[ArticleNo], 
  td_pc.[PassengerCarNo]

HAVING COUNT(*) > 1

/*
  TODO:

  2021-05-08
  ----------
  6903998   Articles in TD

  - Duplicate article numbers
*/
