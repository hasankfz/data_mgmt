/*
   Dump the number of products for electric vehicles in TecDoc with an active status
    
*/
SELECT DISTINCT 
--  COUNT(td_art.[ArticleNo]) as "TD-ArtNr"

td_art.[ArticleNo] as "TD-ArticleNo",
td_ds.[Brand],
td_art.[Manufacturer:Link],
td_art.[DataSupplier:Link],
td_pc.[EngineType:Link],
td_pc.[PassengerCarNo],
td_pc_de.LongDesignation,
td_ga.GenericArticleNo,
td_ga_de.Designation as "GenericArticle",
td_ag_de.Designation as "AssemblyGroup"
-- td_ga_de.Synonyms
-- td_ga.IsUniversalArticle,
-- td_ga.ForPassengerCars,

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 
  -- Links to articles for passenger cars (PKW or PC)
     LEFT OUTER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl WITH (NOLOCK) ON td_pcl.[Article:Link] = td_art.[ArticleNo]
  -- Links to passenger cars (PKW or PC)
     LEFT OUTER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc WITH (NOLOCK) ON td_pc.[PassengerCarNo] = td_pcl.[LinkingTarget:Link] 
  -- Cars in the German market 
     LEFT OUTER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] td_pc_de WITH (NOLOCK) ON td_pc_de.[:Id] = td_pc.[:Id]
                 AND td_pc_de.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'
  -- Generic Articles
     LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.GenericArticles] td_ga WITH (NOLOCK) ON td_ga.[GenericArticleNo] = td_pcl.[GenericArticle:Link]
     LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.GenericArticles <TecDoc.GeneralData.UsedLanguages>] td_ga_de WITH (NOLOCK) ON td_ga_de.[:Id] = td_ga.[:Id]
              AND td_ga_de.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd' -- DE
  -- Assembly Group
     LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.AssemblyGroups] td_ag WITH (NOLOCK) ON td_ag.[AssemblyGroupNo] = td_ga.[AssemblyGroup:Link]
     LEFT OUTER JOIN dbo.[TecDoc.ProductClassification.AssemblyGroups <TecDoc.GeneralData.UsedLanguages>] td_ag_de WITH (NOLOCK) ON td_ag_de.[:Id] = td_ag.[:Id] 
                 AND td_ag_de.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd' -- DE
  -- Data Supplier
     LEFT OUTER JOIN dbo.[TecDoc.GeneralData.DataSupplier] td_ds WITH (NOLOCK) ON td_ds.[DataSupplierNo] = td_art.[DataSupplier:Link]

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles with an active status
  AND
  td_art.[State:Link] = '73-001'
  -- Get electric vehicles
  AND
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

ORDER BY
  td_art.[ArticleNo],
  td_art.[Manufacturer:Link],
  td_pc.[PassengerCarNo]

/*
  TODO:

  2021-05-08
  ----------
  6903998   Articles in TD

*/
