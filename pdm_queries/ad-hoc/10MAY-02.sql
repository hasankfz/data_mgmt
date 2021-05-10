/*

*/

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

td_art_de_CTE (TDDEArtNumber, TDDEArtStatus)
AS
  (
SELECT
  td_art_de.[Article:Link],
  td_art_de.[State:Link]

-- Articles in TecDoc for specific markets
FROM dbo.[TecDoc.Articles.ArticlesCouSpec] td_art_de

WHERE
  -- Get the articles for the German market; can add other markets with an IN statement.
  td_art_de.[Country:Link] = 'DE'

  ),

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

/*
  2021-05-10
  ----------
  6903998 Active articles in TecDoc
   114266 Active articles in TecDoc for the German market
*/
  
  ),

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

-- Get the article numbers for active articles in TecDoc--Global and German.
td_art_combine_nr_CTE (TDArticleNrs)
AS(

SELECT DISTINCT TDArticleNr
FROM td_art_combine_CTE
), 

-- Get the passenger cars in TecDoc that have a reference to an article. 
-- 85120 Links to passenger cars
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

-- Get the acticles in TecDoc that reference passenger cars (PC or PKWs). 
-- Counting the number of links shows the most popular products by links or references to cars.
-- 5556824 articles
td_art_pc_CTE (TDArtPCNr)
AS(

SELECT DISTINCT
td_pcl.[Article:Link]
--COUNT(td_pcl.[LinkingTarget:Link]) as "Counted"
--td_pcl.[GenericArticle:Link]

FROM
  dbo.[TecDoc.Linkages.PassengerCars] td_pcl

GROUP BY
  td_pcl.[Article:Link]

),

-- Get the electric vehicles (EVs) in TecDoc.
-- EngineType   Count
-- 80-046       337
-- 80-040       398
-- 80-048       191
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
  td_pc.[EngineType:Link] IN ('80-040','80-046','80-048')

GROUP BY
--  td_pc.[EngineType:Link],
  td_pc.PassengerCarNo

)

-- 4843188 Articles
SELECT TOP 10
COUNT(DISTINCT(td_art_combine_nr_CTE.TDArticleNrs)), -- Articles in TecDoc
COUNT(DISTINCT(td_art_pc_CTE.TDArtPCNr)) -- Articles in TecDoc for passenger cars
--td_art_combine_nr_CTE.TDArticleNrs, -- Articles in TecDoc
--td_art_pc_CTE.TDArtPCNr -- Articles in TecDoc for passenger cars
--td_pc_CTE.TDPCNr,
--td_ev_CTE.TDEVNr

FROM td_art_combine_nr_CTE
-- Extract the number of articles related to passenger cars
   INNER JOIN td_art_pc_CTE ON td_art_combine_nr_CTE.TDArticleNrs = td_art_pc_CTE.TDArtPCNr --  td_art.[ArticleNo] = td_pcl.[Article:Link]

--LEFT OUTER JOIN td_ev_CTE ON td_pc_CTE.TDPCNr = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

/*
  FROM dbo.[TecDoc.Articles.Articles] td_art 
  -- Links to articles for passenger cars (PKW or PC)
     INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link] 
  -- Links to passenger cars (PKW or PC)
     INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo] 
*/