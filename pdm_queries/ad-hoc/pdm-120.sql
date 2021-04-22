SELECT TOP 100 
       T3.[Name], 
       T1.[PassengerCarNo], 
       T5.[Name], 
       T6.[Designation], 
       T7.[GenericArticleNo], 
       T8.[Designation], 
       T10.[Designation], 
       T11.[ArticleNo], 
       T12.[Designation], 
       T11.[State:Link]

 FROM [dbo].[TecDoc.Linkages.PassengerCars] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars] T1 WITH (NOLOCK) ON T1.[PassengerCarNo] = [base].[LinkingTarget:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues] T2 WITH (NOLOCK) ON T2.[KeyValueNo] = [T1].[EngineType:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] T3 WITH (NOLOCK) ON T3.[:Id] = [T2].[:Id] AND T3.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.Models] T4 WITH (NOLOCK) ON T4.[ModelNo] = [T1].[Model:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.Manufacturer.LinkingTargetBrands] T5 WITH (NOLOCK) ON T5.[ManufacturerNo] = [T4].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.Models <TecDoc.GeneralData.UsedCountries>] T6 WITH (NOLOCK) ON T6.[:Id] = [T4].[:Id] AND T6.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles] T7 WITH (NOLOCK) ON T7.[GenericArticleNo] = [base].[GenericArticle:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles <TecDoc.GeneralData.UsedLanguages>] T8 WITH (NOLOCK) ON T8.[:Id] = [T7].[:Id] AND T8.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.AssemblyGroups] T9 WITH (NOLOCK) ON T9.[AssemblyGroupNo] = [T7].[AssemblyGroup:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.AssemblyGroups <TecDoc.GeneralData.UsedLanguages>] T10 WITH (NOLOCK) ON T10.[:Id] = [T9].[:Id] AND T10.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles] T11 WITH (NOLOCK) ON T11.[ArticleNo] = [base].[Article:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles <TecDoc.GeneralData.UsedLanguages>] T12 WITH (NOLOCK) ON T12.[:Id] = [T11].[:Id] AND T12.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
 
 WHERE 
  (
  -- EngineType
    ((T3.[Name] = 'Elektromotor') 
      OR (T3.[Name] = 'Mild Hybrid')
	  OR (T3.[Name] = 'Full Hybrid')
	  OR (T3.[Name] = 'Plug-In Hybrid'))
  AND (T11.[State:Link] = '73-001') -- TecDoc Status
  )

--ORDER BY base.[LinkageNo]