/*
   Count the number of products in TecDoc with an active status
    
*/
SELECT DISTINCT

  COUNT(td_art.[ArtNo]) as "TD-ArtNr"

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles that are active in TecDoc and in the PDM
  AND
  td_art.[State:Link] = '73-001'

  /*
  TODO:

  2021-05-06 = 6903998

 */
