/*
  Count the number of products in TecDoc regardless of status.
*/
SELECT
  COUNT(DISTINCT(td_art.[:Id])) as "TD-Art-ID"

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  

/*
  2021-05-10 = 8372230
*/
