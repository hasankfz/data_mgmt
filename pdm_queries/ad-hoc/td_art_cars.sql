
/*
  List the articles in TecDoc that are available for cars.
  Rewrites join to fix duplicate records due to one-to-many relationship between TecDoc articles and links.
*/
SELECT
  --COUNT(DISTINCT(td_art.[ArticleNo]))
  td_art.[ArticleNo]

-- Articles in TecDoc
FROM dbo.[TecDoc.Articles.Articles] td_art 
-- Links to articles for passenger cars (PKW or PC)
   JOIN (SELECT td_pcl.[Article:Link]
         FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl
         GROUP BY td_pcl.[Article:Link]) as td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
 
WHERE
  -- Use the latest dataset
  td_art.[ImportVersionNo] = '20210401'  
  -- Get articles with an active status
  AND
  td_art.[State:Link] = '73-001'

ORDER BY
td_art.[ArticleNo]

-- 6903998 Articles
-- 4782598 Articles for cars