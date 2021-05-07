SELECT DISTINCT
  td_t8.GenericArticleNo as "GenArt",
  T4.Designation as "GenArt-Desc",
  T2.[Designation]
 
FROM [dbo].[TecDoc.ProductClassification.GenericArticles] td_t8 WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles <TecDoc.GeneralData.UsedLanguages>] T2 WITH (NOLOCK) ON T2.[:Id] = td_t8.[:Id]
  AND T2.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.StdGenArtDesignations] T3 WITH (NOLOCK) ON T3.[StdDesignationNo] = td_t8.[StandardDesignation:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.StdGenArtDesignations <TecDoc.GeneralData.UsedLanguages>] T4 WITH (NOLOCK) ON T4.[:Id] = [T3].[:Id]
  AND T4.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
 
WHERE
  td_t8.ForPassengerCars = 'TRUE'
  AND
  td_t8.ImportVersionNo = '20210401'

ORDER BY
td_t8.GenericArticleNo

-- 4186