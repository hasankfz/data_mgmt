/*
  Queries to count and list the number of articles in TecDoc and in the PDM for electric vehicles (EV) in Germany.

  To count the articles with an active statusin TecDoc including articles for the German market, use td_art_combine_nr_CTE.
  To count the articles in TecDoc for the German market that are related to passenger cars, use td_art_pcs_CTE.

*/

-- Get articles in TecDoc with an active state
-- 2021-05-16 = 6903998
WITH td_art_CTE (TDArtNumber)
AS
  (
SELECT DISTINCT
-- COUNT(DISTINCT(td_art.[ArticleNo]))
td_art.[ArticleNo]
--td_art.[ArtNo]
--td_art.[Manufacturer:Link],
--td_art.[DataSupplier:Link],
--td_art.[State:Link]

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  AND
    -- Get articles with an active status
  td_art.[State:Link] = '73-001'
  ),

-- Get additional articles in TecDoc for the German market with an active state
-- 2021-05-16 = 114266
td_art_de_CTE (TDArtNumberDE)
AS
  (
SELECT DISTINCT
--COUNT(DISTINCT(td_art_de.[Article:Link]))
td_art_de.[Article:Link]
--td_art_de.[State:Link]

-- Articles in TecDoc for specific markets
FROM dbo.[TecDoc.Articles.ArticlesCouSpec] td_art_de

WHERE
  -- Get the articles for the German market.
  -- You can add other markets by using an IN statement like IN ('DE','PL').
  td_art_de.[Country:Link] = 'DE'
  AND
  -- Get articles with an active status
  td_art_de.[State:Link] = '73-001'
  ),

/*
  NOTE: If you combine the number of active articles in TecDoc with articles for the German market, you will get a false count.
  These two CTEs sum the total number of unique records in each subcount before removing any duplicates that appear in both subcounts. 
  The better approach is to combine the articles and then count as with td_art_combine_nr_CTE.

td_art_count_CTE (TDArtNr)
AS(
SELECT  
  COUNT(DISTINCT(TDArtNumber))
FROM td_art_CTE 

UNION ALL

SELECT  
  COUNT(DISTINCT(TDArtNumberDE))
FROM td_art_de_CTE  

td_art_totalcount_CTE (TDArtNr)
AS(
   SELECT SUM(TDArtNr)
   FROM td_art_count_CTE
  ),
*/

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

-- Count the total number of vehicles
td_tv_CTE (TDTVNr, PcsCount)
AS(
SELECT
  td_pc.[EngineType:Link],
  COUNT(td_pc.PassengerCarNo)
--  td_pc.PassengerCarNo

FROM
  dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 

WHERE
  td_pc.ImportVersionNo = '20210401'

GROUP BY
  td_pc.[EngineType:Link]
),

-- Get the acticles in TecDoc that reference passenger cars (PC or PKWs). 
-- Counting the number of links shows the most popular products by links or references to cars.
-- NOTE: Counting the unique articles gives the number of articles for cars, which is in the presentation. 
td_art_pcs_CTE (Article, Car)
AS(
SELECT DISTINCT 
td_pcl.[Article:Link],
td_pcl.[LinkingTarget:Link]
--COUNT(DISTINCT(td_pcl.[Article:Link]))
--COUNT(td_pcl.[LinkingTarget:Link]) as "Counted"
--td_pcl.[GenericArticle:Link]

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[Article:Link],
  td_pcl.[LinkingTarget:Link]
),

-- 7000506 Articles in TD
-- 4811969 Articles for PCs in TD 
--  125251 Articles for EVs in TD
--  264522 Articles for HVs in TD
td_art_pcs_CTE (Article)
AS(
   SELECT COUNT(DISTINCT(td_art_combine_nr_CTE.TDArticleNrs))

   FROM td_art_combine_nr_CTE
   -- Extract the number of articles related to passenger cars
      INNER JOIN td_art_pcs_CTE ON td_art_combine_nr_CTE.TDArticleNrs = CAST(td_art_pcs_CTE.Article as varchar) -- td_art.[ArticleNo] = td_pcl.[Article:Link]

   -- Extract the articles for EVs
      INNER JOIN td_ev_CTE ON td_art_pcs_CTE.Car = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

   -- Extract the articles for HVs
   -- INNER JOIN td_hv_CTE ON td_art_pcs_CTE.Car = td_hv_CTE.TDHVNr 

   -- Extract the articles for non EV or HV
   -- INNER JOIN td_nehv_CTE ON td_art_pcs_CTE.Car = td_nehv_CTE.TDNEHVNr 
   ),

-- 2215771 Articles for PCs in PDM (1576977)
--   60430 Articles for EVs in PDM (45244)
--    9978 Articles for EVs in PDM without K24-Nr (23)
pmd_art_pcs_CTE (Article)
AS(
   SELECT COUNT(DISTINCT(art.[:Id])) -- td_art_pcs_CTE.Article)) 125251 --td_art_combine_nr_CTE.TDArticleNrs)) 4811180

   FROM td_art_combine_nr_CTE
   -- Extract the number of articles related to passenger cars
      INNER JOIN td_art_pcs_CTE ON td_art_combine_nr_CTE.TDArticleNrs = CAST(td_art_pcs_CTE.Article as varchar) -- td_art.[ArticleNo] = td_pcl.[Article:Link]

   -- Extract the articles for EVs
      INNER JOIN td_ev_CTE ON td_art_pcs_CTE.Car = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

   LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art_pcs_CTE.Article = art_td.[TecDoc.Link]          
   LEFT OUTER JOIN dbo.[Article.Articles] art ON art_td.[:Id] = art.[:Id]
   LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON art.[:Id] = art_props.[:Id]

   WHERE
     art_props.[ArticleStatus:Link] = '1'
   /*
     AND 
     art.K24Number IS NULL
   */
)