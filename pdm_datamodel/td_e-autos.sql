/*
   List the electric vehicles in TecDoc that are available in the German market
*/

SELECT DISTINCT
  --  COUNT(pc.[:Id]) 926
  td_pc_de.LongDesignation,
  td_pc.PassengerCarNo

FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc WITH (NOLOCK)
  -- Get cars in the German market 
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] td_pc_de WITH (NOLOCK) ON td_pc_de.[:Id] = td_pc.[:Id]
              AND td_pc_de.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'

WHERE
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')
  AND
  td_pc.ImportVersionNo = '20210401'

ORDER BY
  td_pc_de.LongDesignation
