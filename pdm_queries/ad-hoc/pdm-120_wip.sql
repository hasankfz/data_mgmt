/*
  Queries to count and list the number of articles in TecDoc and in the PDM for electric vehicles (EV) in Germany.

  To count the articles in TecDoc for the German market, use td_art_count_CTE or td_art_totalcount_CTE.
  To get a list of article numbers for active articles in TecDoc for the German market, use td_art_combine_nr_CTE.
  To count the articles in TecDoc for the German market that are related to passenger cars, use td_art_pcs_CTE.

*/

-- Get articles in TecDoc regardless of state
WITH td_art_CTE (TDArtNumber, TDArtStatus)
AS
  (
SELECT
  td_art.[ArticleNo],
  --td_art.ArtNo,
  --td_art.[Manufacturer:Link],
  --td_art.[DataSupplier:Link],
  td_art.[State:Link]

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  ),

-- Get additional articles in TecDoc for the German market regardless of state
td_art_de_CTE (TDDEArtNumber, TDDEArtStatus)
AS
  (
SELECT
  td_art_de.[Article:Link],
  td_art_de.[State:Link]

-- Articles in TecDoc for specific markets
FROM dbo.[TecDoc.Articles.ArticlesCouSpec] td_art_de

WHERE
  -- Get the articles for the German market.
  -- You can add other markets by using an IN statement like IN ('DE','PL').
  td_art_de.[Country:Link] = 'DE'
  ),

-- Count the number of active articles in TecDoc for the German market.
-- 2021-05-16
--    6903998 Active articles in TecDoc
--     114266 Active articles in TecDoc for the German market
td_art_count_CTE (TDArtNr)
AS(
SELECT  
  COUNT(DISTINCT(TDArtNumber))

FROM td_art_CTE 

WHERE
  -- Get articles with an active status
  TDArtStatus = '73-001' 

UNION ALL

SELECT  
  COUNT(DISTINCT(TDDEArtNumber))

FROM td_art_de_CTE  

WHERE
  -- Get articles with an active status
  TDDEArtStatus = '73-001' 
  ),

-- Count the total number of active articles in TecDoc for the German market.
-- NOTE: This is the value reported in the presentation. 
td_art_totalcount_CTE (TDArtNr)
AS(
   SELECT SUM(TDArtNr)
   FROM td_art_count_CTE
  ),

td_art_combine_CTE (TDArticleNr)
AS(
SELECT TDArtNumber 

FROM td_art_CTE 

WHERE
  -- Get articles with an active status
  TDArtStatus = '73-001' 

UNION ALL

SELECT TDDEArtNumber

FROM td_art_de_CTE  

WHERE
  -- Get articles with an active status
  TDDEArtStatus = '73-001' 
),

-- Creates a list of article numbers for active articles in TecDoc--Global and German.
-- TODO: 7000506 articles compared with td_art_totalcount_CTE 
td_art_combine_nr_CTE (TDArticleNrs)
AS(
SELECT TDArticleNr
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
)

-- 4811969 Articles for PCs in TD
--  125251 Articles for EVs in TD
--   45245 Articles for EVs in PDM
--      23 Articles for EVs in PDM without K24-Nr
SELECT DISTINCT 
-- COUNT(DISTINCT(td_art_pcs_CTE.Article)) -- Articles in TecDoc with links to passenger cars
-- td_art_combine_nr_CTE.TDArticleNrs, -- Articles in TecDoc
td_art_pcs_CTE.Article -- Articles in TecDoc with links to passenger cars

FROM td_art_combine_nr_CTE
-- Extract the number of articles related to passenger cars
   INNER JOIN td_art_pcs_CTE ON td_art_combine_nr_CTE.TDArticleNrs = CAST(td_art_pcs_CTE.Article as varchar) -- td_art.[ArticleNo] = td_pcl.[Article:Link]

-- Extract the artices for EVs
   INNER JOIN td_ev_CTE ON td_art_pcs_CTE.Car = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

   LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art_pcs_CTE.Article = art_td.[TecDoc.Link]          
   LEFT OUTER JOIN dbo.[Article.Articles] art ON art_td.[:Id] = art.[:Id]
   LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON art.[:Id] = art_props.[:Id]

WHERE
   art_props.[ArticleStatus:Link] = '1'
   AND 
   art.K24Number IS NOT NULL

GROUP BY
td_art_pcs_CTE.Article

/*

*/