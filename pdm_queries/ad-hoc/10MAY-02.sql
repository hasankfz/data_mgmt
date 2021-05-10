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
  
  )

SELECT SUM(TDArtNr)
FROM td_art_count_CTE