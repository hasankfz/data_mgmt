/*
  List the engine types and fuel types in TecDoc for passenger cars.
*/

SELECT
  td_pc.[EngineType:Link],
  T3.[Name] as "EngineType", 

  td_pc.[FuelType:Link],
  T5.[Name] as "FuelType", 

  COUNT(td_pc.PassengerCarNo)
--  td_pc.PassengerCarNo

FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues] T2 ON T2.[KeyValueNo] = td_pc.[EngineType:Link]               
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] T3 ON T3.[:Id] = [T2].[:Id]
              AND T3.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'

  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues] T4 ON T4.[KeyValueNo] = td_pc.[FuelType:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] T5 ON T5.[:Id] = [T4].[:Id]
              AND T5.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'

WHERE
  td_pc.ImportVersionNo = '20210401'

GROUP BY
  td_pc.[EngineType:Link],
  T3.[Name],
  td_pc.[FuelType:Link],
  T5.[Name]

ORDER BY
  td_pc.[EngineType:Link],
  T3.[Name],
  td_pc.[FuelType:Link],
  T5.[Name]
