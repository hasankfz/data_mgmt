/*
   Get products in TecDoc with an active status
    
*/
SELECT DISTINCT
/*
  td_art.[ArticleNo] as "TD-ArticleNo",
  td_art.[ArtNo] as "TD-ArtNo", 
  td_art.[Manufacturer:Link],   
  td_art.[DataSupplier:Link] 
  
  td_t1.[GenericArticle:Link]
  td_t1.[LinkingTarget:Link]
  
*/

   td_art.[ArticleNo],
--  td_t1.[GenericArticle:Link],
  COUNT(td_t1.[LinkingTarget:Link])

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 
-- Passenger Cars (PKW)
  INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_t1 WITH (NOLOCK) ON td_t1.[Article:Link] = td_art.[ArticleNo]

WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles that are active in TecDoc and in the PDM
  AND
  td_art.[State:Link] = '73-001'

GROUP BY
 td_art.[ArticleNo]
-- td_t1.[GenericArticle:Link],
-- td_t1.[LinkingTarget:Link]

ORDER BY
  COUNT(td_t1.[LinkingTarget:Link]) DESC,
  td_art.[ArticleNo]
-- td_t1.[GenericArticle:Link],


/*
  TODO:

  2021-05-07
  ----------
  246666021	244544621

*/
