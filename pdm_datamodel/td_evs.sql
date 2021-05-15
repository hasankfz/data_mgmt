/*
  List the electric vehicles in TecDoc that are available.
  The descriptions are for the German market.
*/

SELECT 
  --COUNT(DISTINCT(td_pc.[:Id])) -- 926 EVS
  td_pc_de.LongDesignation,
  td_pc.PassengerCarNo

FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 
  -- Description for cars in German 
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] td_pc_de  ON td_pc_de.[:Id] = td_pc.[:Id]
              AND td_pc_de.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

ORDER BY
  td_pc_de.LongDesignation
