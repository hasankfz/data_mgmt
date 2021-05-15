/*
  Query from PDM to extract relevant data for PDM-120.
*/
SELECT TOP 10
       T1.[EngineType:Link], 
       base.[Article:Link], 
       T2.[DataSupplier:Link], 
       T2.[Manufacturer:Link], 
       T2.[ArtNo], 
       T3.[Designation], 
       base.[GenericArticle:Link], 
       T5.[Designation], 
       base.[LinkingTarget:Link], 
       T6.[LongDesignation]

 FROM [dbo].[TecDoc.Linkages.PassengerCars] base  
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars] T1 ON T1.[PassengerCarNo] = [base].[LinkingTarget:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] T6 ON T6.[:Id] = [T1].[:Id]
             AND T6.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'

  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles] T2 ON T2.[ArticleNo] = [base].[Article:Link]

  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles <TecDoc.GeneralData.UsedLanguages>] T3 ON T3.[:Id] = [T2].[:Id]
              AND T3.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'

  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles] T4 ON T4.[GenericArticleNo] = [base].[GenericArticle:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles <TecDoc.GeneralData.UsedLanguages>] T5 ON T5.[:Id] = [T4].[:Id]
              AND T5.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'

WHERE
 T1.[EngineType:Link] IN ('80-040','80-046','80-048')

ORDER BY
  base.[Article:Link]