/*
   List the electric vehicles in TecDoc 
*/

SELECT DISTINCT
  --  COUNT(pc.[:Id]) 926
  T1.LongDesignation,
  pc.PassengerCarNo

FROM dbo.[TecDoc.LinkingTargets.PassengerCars] pc WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] T1 WITH (NOLOCK) ON T1.[:Id] = pc.[:Id]
              AND T1.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'
  LEFT OUTER JOIN dbo.[TecDoc.GeneralData.KeyValues] T4 WITH (NOLOCK) ON T4.[KeyValueNo] = pc.[EngineType:Link]

WHERE
  pc.[EngineType:Link] IN ('80-040','80-046','80-048')
  AND
  pc.ImportVersionNo = '20210401'

ORDER BY
  T1.LongDesignation
