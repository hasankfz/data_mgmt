/*
  Queries to the number of articles in TecDoc and in the PDM for electric vehicles (EV) in Germany.
*/

-- Get articles in TecDoc with an active state
WITH td_art_CTE (TDArtNumber)
AS
  (
   SELECT DISTINCT
     td_art.[ArticleNo]

   FROM dbo.[TecDoc.Articles.Articles] td_art

   WHERE
   -- Use the latest dataset
      td_art.[ImportVersionNo] = '20210401'  
      AND
   -- Get articles with an active status
      td_art.[State:Link] = '73-001'
  ),

-- Get additional articles in TecDoc for the German market with an active state
td_art_de_CTE (TDArtNumberDE)
AS
  (
   SELECT DISTINCT
     td_art_de.[Article:Link]

   FROM dbo.[TecDoc.Articles.ArticlesCouSpec] td_art_de

   WHERE
   -- Get the articles for the German market.
   -- You can add other markets by using an IN statement like IN ('DE','PL').
      td_art_de.[Country:Link] = 'DE'
      AND
   -- Get articles with an active status
      td_art_de.[State:Link] = '73-001'
  ),

-- Combine the articles for each group.
td_art_combine_CTE (TDArticleNr)
AS(
   SELECT TDArtNumber 
   FROM td_art_CTE 

   UNION ALL

   SELECT TDArtNumberDE
   FROM td_art_de_CTE  
),

-- Create a list of unique articles with an active status in TecDoc including articles for the German market.
-- 2021-05-17 = 7000506  
td_art_combine_nr_CTE (TDArticleNrs)
AS(
   SELECT DISTINCT TDArticleNr
   --COUNT(DISTINCT(TDArticleNr))
   FROM td_art_combine_CTE
), 

-- Get the passenger cars in TecDoc that have a reference to an article. 
-- 85120 links to passenger cars
td_pc_CTE (TDPCNr)
AS(
   SELECT DISTINCT
     td_pcl.[LinkingTarget:Link]
     --COUNT(DISTINCT(td_pcl.[LinkingTarget:Link]))

   FROM
     dbo.[TecDoc.Linkages.PassengerCars] td_pcl

   GROUP BY
     td_pcl.[LinkingTarget:Link]
),

-- Get the electric vehicles (EVs) in TecDoc (392). See Page 20 of specification.
td_ev_CTE (TDEVNr)
AS(
SELECT
--  td_pc.[EngineType:Link],
--  COUNT(td_pc.PassengerCarNo)
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-040')
  AND
  td_pc.[FuelType:Link] = '182-011'

GROUP BY
--  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo
),

-- Get the hybrid vehicles in TecDoc (528).
td_hv_CTE (TDHVNr)
AS(
SELECT
--  td_pc.[EngineType:Link],
--  COUNT(td_pc.PassengerCarNo)
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] IN ('80-046','80-048','80-049')

GROUP BY
--  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo
),

-- Get vehicles that are neither electric nor hybrid in TecDoc (45049).
td_nehv_CTE (TDNEHVNr)
AS(
SELECT
--  td_pc.[EngineType:Link],
--  COUNT(td_pc.PassengerCarNo)
  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'
  AND
  td_pc.[EngineType:Link] NOT IN ('80-040','80-046','80-048','80-049')

GROUP BY
--  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo
),

-- Get the acticles in TecDoc that reference passenger cars (PC or PKWs). 
td_art_pcs_CTE (Article, Car)
AS(
SELECT DISTINCT 
td_pcl.[Article:Link],
td_pcl.[LinkingTarget:Link]

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[Article:Link],
  td_pcl.[LinkingTarget:Link]
)

--td_art_pcs_e_CTE (Article)

   SELECT DISTINCT TOP 40
   td_art.[Manufacturer:Link] as "Manufacturer",
   md_manu.[Name] as "ManufacturerNr", -- ATE, BREMBO
   
--   td_art_combine_nr_CTE.TDArticleNrs as "TD-ArticleNr",
   COUNT(td_art_combine_nr_CTE.TDArticleNrs) as "Count"

   FROM td_art_combine_nr_CTE
   -- Add the article properties back to the results (duh!)
      LEFT OUTER JOIN dbo.[TecDoc.Articles.Articles] td_art ON td_art_combine_nr_CTE.TDArticleNrs = td_art.[ArticleNo]
      LEFT OUTER JOIN dbo.[MasterData.Manufacturers] md_manu ON md_manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link] 

   -- Extract the number of articles related to passenger cars
      INNER JOIN td_art_pcs_CTE ON td_art_combine_nr_CTE.TDArticleNrs = CAST(td_art_pcs_CTE.Article as varchar) -- td_art.[ArticleNo] = td_pcl.[Article:Link]

   -- Extract the articles for EVs
      INNER JOIN td_ev_CTE ON td_art_pcs_CTE.Car = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

	  GROUP BY
   td_art.[Manufacturer:Link],
   md_manu.[Name],
   td_art_combine_nr_CTE.TDArticleNrs

   ORDER BY
   td_art.[Manufacturer:Link]
--   td_art_combine_nr_CTE.TDArticleNrs

##################
##################
SELECT TOP 10
      [ManufacturerNo],
      [Name],
      [TecDoc.Link],
      [TecDoc.Version],
      [ArticleBrand:Link],
      [ManufacturerShortName],
      [IsActive <DE>]

FROM [K24Pdm].[dbo].[MasterData.Manufacturers]

WHERE EXISTS
(
   SELECT *
   FROM td_art_combine_nr_CTE
   -- Add the article properties back to the results (duh!)
      LEFT OUTER JOIN dbo.[TecDoc.Articles.Articles] td_art ON td_art_combine_nr_CTE.TDArticleNrs = td_art.[ArticleNo]
 
   -- Extract the number of articles related to passenger cars
      INNER JOIN td_art_pcs_CTE ON td_art_combine_nr_CTE.TDArticleNrs = CAST(td_art_pcs_CTE.Article as varchar) -- td_art.[ArticleNo] = td_pcl.[Article:Link]

   -- Extract the articles for EVs
      INNER JOIN td_ev_CTE ON td_art_pcs_CTE.Car = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]
)

   SELECT DISTINCT TOP 40
   td_art.[Manufacturer:Link] as "Manufacturer",
   md_manu.[Name] as "ManufacturerNr", -- ATE, BREMBO
   
--   td_art_combine_nr_CTE.TDArticleNrs as "TD-ArticleNr",
   COUNT(td_art_combine_nr_CTE.TDArticleNrs) as "Count"

