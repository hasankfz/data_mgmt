/*
   Retrieve the number of products in TD and in the PDM for electric cars
*/
SELECT DISTINCT

  td_t4.[Name] as "EngineType", 
  td_t2.[PassengerCarNo] as "CarNr", 
  td_t6.[Name] as "CarMake", 
  td_t7.[Designation] as "CarModel", 
 
  td_t8.[GenericArticleNo] as "TD-GenArtNr",
  td_t9.[Designation] as "TD-GenartDesc", 

  COUNT(td_art.[ArtNo]) as "TecDoc",
--  COUNT(art.[ArticleID]) as "PDM-ArtID"
  COUNT(art.[K24Number]) as "PMD",
  (COUNT(td_art.[ArtNo]) - COUNT(art.[K24Number])) as "Difference"

FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 
  -- 6903998 unique articles IN TD
  LEFT OUTER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_t1 WITH (NOLOCK) ON td_t1.[Article:Link] = td_art.[ArticleNo]
  LEFT OUTER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_t2 WITH (NOLOCK) ON td_t2.[PassengerCarNo] = td_t1.[LinkingTarget:Link]
  -- EngineType  
  LEFT OUTER JOIN dbo.[TecDoc.GeneralData.KeyValues] td_t3 WITH (NOLOCK) ON td_t3.[KeyValueNo] = td_t2.[EngineType:Link]
  LEFT OUTER JOIN dbo.[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] td_t4 WITH (NOLOCK) ON td_t4.[:Id] = td_t3.[:Id]
              AND td_t4.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd' -- DE
  -- Model
  LEFT OUTER JOIN dbo.[TecDoc.LinkingTargets.Models] td_t5 WITH (NOLOCK) ON td_t5.[ModelNo] = td_t2.[Model:Link]
  LEFT OUTER JOIN dbo.[TecDoc.Manufacturer.LinkingTargetBrands] td_t6 WITH (NOLOCK) ON td_t6.[ManufacturerNo] = td_t5.[Manufacturer:Link]
  LEFT OUTER JOIN dbo.[TecDoc.LinkingTargets.Models <TecDoc.GeneralData.UsedCountries>] td_t7 WITH (NOLOCK) ON td_t7.[:Id] = td_t5.[:Id]
              AND td_t7.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d' -- DE

  -- Genart
  LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.GenericArticles] td_t8 WITH (NOLOCK) ON td_t8.[GenericArticleNo] = td_t1.[GenericArticle:Link]
  LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.GenericArticles <TecDoc.GeneralData.UsedLanguages>] td_t9 WITH (NOLOCK) ON td_t9.[:Id] = td_t8.[:Id]
              AND td_t9.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd' -- DE
  -- Article Description
  LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.AssemblyGroups] td_t10 WITH (NOLOCK) ON td_t10.[AssemblyGroupNo] = td_t8.[AssemblyGroup:Link]
  LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.AssemblyGroups <TecDoc.GeneralData.UsedLanguages>] td_t11 WITH (NOLOCK) ON td_t11.[:Id] = td_t10.[:Id] 
              AND td_t11.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd' -- DE

  LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td WITH (NOLOCK) ON art_td.[TecDoc.Link] = td_art.[ArticleNo] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
  -- 2519100 unique articles IN PDM
  LEFT OUTER JOIN dbo.[Article.Articles] art WITH (NOLOCK) ON art.[:Id] = art_td.[:Id]
  LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props WITH (NOLOCK) ON art_props.[:Id] = art.[:Id]
  -- Manufactorer
  LEFT OUTER JOIN dbo.[MasterData.Manufacturers] md_manu WITH (NOLOCK) ON md_manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link] -- md_manu.[ManufacturerNo] = art.[Manufacturer:Link]

WHERE
  -- Use the latest dataset
  (td_art.[ImportVersionNo] = '20210401' OR art_td.[TecDoc.Version] = '20210401')  
  -- Get articles that are active in TecDoc and in the PDM
  AND
  (td_art.[State:Link] = '73-001'
   AND art_td.[Status:Link] = '73-001'
   AND art_props.[ArticleStatus:Link] = '1' )
  -- Get cars with electric engines td_t2.[EngineType:Link] or td_t3.[KeyValueNo]
  AND
  (
     td_t4.[Name] = 'Elektromotor' --80-040
  OR td_t4.[Name] = 'Mild Hybrid' -- 80-048
  OR td_t4.[Name] = 'Full Hybrid' -- 80-048
  OR td_t4.[Name] = 'Plug-In Hybrid' -- 80-046
  ) 
  
GROUP BY
  td_t4.[Name],
  td_t2.[PassengerCarNo], 
  td_t6.[Name], 
  td_t7.[Designation], 
  td_t8.[GenericArticleNo],
  td_t9.[Designation] 

ORDER BY
  td_t4.[Name],
  td_t2.[PassengerCarNo], 
  td_t8.[GenericArticleNo]
 
/*
  TODO:

*/
