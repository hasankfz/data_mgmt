/*
  This little query shows that adding German products doesn't increase the number of available products. 
*/
SELECT DISTINCT 
	  td_art.ArticleNo

   FROM dbo.[TecDoc.Articles.Articles] td_art

   WHERE
   -- Use the latest dataset
   td_art.[ImportVersionNo] = '20210401'  
   AND
-- Get articles with an active status
   td_art.[State:Link] = '73-001'

UNION

SELECT DISTINCT 
      td_art_de.[Article:Link]

   FROM dbo.[TecDoc.Articles.ArticlesCouSpec] td_art_de -- ON td_art.ArticleNo = td_art_de.[Article:Link]

   WHERE
   -- Get the articles for the German market.
   -- You can add other markets by using an IN statement like IN ('DE','PL').
      td_art_de.[Country:Link] = 'DE'
      AND
   -- Get articles with an active status
      td_art_de.[State:Link] = '73-001'