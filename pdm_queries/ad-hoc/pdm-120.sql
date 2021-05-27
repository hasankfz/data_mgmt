/*

*/

SELECT DISTINCT
   (CASE
        WHEN td_pc.[EngineType:Link] = '80-040'
             AND td_pc.[FuelType:Link] = '182-011'
             THEN 'Electric'
        WHEN td_pc.[EngineType:Link] IN ('80-046','80-047','80-048','80-049')
             THEN 'Hybrid'
        WHEN td_pc.[EngineType:Link] NOT IN ('80-046','80-047','80-048','80-049')
             OR ( td_pc.[EngineType:Link] = ('80-040') AND td_pc.[FuelType:Link] = '182-007' )
             THEN 'Combustion'
		ELSE NULL
		END) as "Engine",
   td_pc_de.LongDesignation as "Car Make",
   ga_de.Designation as "Generic Article",
   td_brand.Brand as "Brand",
   COUNT(DISTINCT(td_art.[ArticleNo])) as "Article"
--   pdm.ArticleID
--   pdm.K24Number

FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc
-- Add links to passenger cars 
   INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_pc.[PassengerCarNo] = td_pcl.[LinkingTarget:Link]
-- Add TecDoc articles
   INNER JOIN dbo.[TecDoc.Articles.Articles] td_art ON td_pcl.[Article:Link] = td_art.[ArticleNo]
-- Add brand name
   INNER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] td_brand ON td_art.[DataSupplier:Link] = td_brand.[DataSupplierNo]
-- Add description of generic article 
   INNER JOIN [dbo].[TecDoc.ProductClassification.GenericArticles] ga ON td_pcl.[GenericArticle:Link] = ga.GenericArticleNo
   INNER JOIN [dbo].[TecDoc.ProductClassification.StdGenArtDesignations] ga_desc ON ga.[StandardDesignation:Link] = ga_desc.[StdDesignationNo]
   INNER JOIN [dbo].[TecDoc.ProductClassification.StdGenArtDesignations <TecDoc.GeneralData.UsedLanguages>] ga_de ON ga_desc.[:Id] = ga_de.[:Id]
          AND ga_de.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
-- Add description of car
   INNER JOIN [dbo].[TecDoc.LinkingTargets.PassengerCars <TecDoc.GeneralData.UsedCountries>] td_pc_de ON td_pc.[:Id] = td_pc_de.[:Id]
          AND td_pc_de.[:TecDoc.GeneralData.UsedCountries_Id] = 'fa28054b-7d56-4c8a-a303-cbaa1df0e43d'

WHERE
-- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'
-- Get articles with an active status in TecDoc
   AND
   td_art.[State:Link] = '73-001'
   AND
   ( td_pc.[EngineType:Link] = '80-040'
             AND td_pc.[FuelType:Link] = '182-011' )
             
GROUP BY
   td_pc.[EngineType:Link],
   td_pc.[FuelType:Link],
   td_pc_de.LongDesignation,
   ga_de.Designation,
   td_brand.Brand