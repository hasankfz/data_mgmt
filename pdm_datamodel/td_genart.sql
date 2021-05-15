/*
  List the product groups (generische Artiklen oder Genarten) for passenger cars in TecDoc that are available. 
  The descriptions are for the German market.
*/

SELECT DISTINCT
  td_t8.GenericArticleNo as "GenArt",
  T4.Designation as "GenArt-Desc",
  T2.[Designation]
 
FROM [dbo].[TecDoc.ProductClassification.GenericArticles] td_t8 
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles <TecDoc.GeneralData.UsedLanguages>] T2 ON T2.[:Id] = td_t8.[:Id]
  AND T2.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.StdGenArtDesignations] T3 ON T3.[StdDesignationNo] = td_t8.[StandardDesignation:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.ProductClassification.StdGenArtDesignations <TecDoc.GeneralData.UsedLanguages>] T4 ON T4.[:Id] = [T3].[:Id]
  AND T4.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
 
WHERE
  td_t8.ForPassengerCars = 'TRUE'
  AND
  td_t8.ImportVersionNo = '20210401'

ORDER BY
td_t8.GenericArticleNo

-- 4186