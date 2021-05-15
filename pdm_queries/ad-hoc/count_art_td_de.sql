/*
  Count the number of products in TecDoc for the German Market regardless of status.
  Required to capture products from some manufactorers and suppliers.
*/
SELECT 
  COUNT(DISTINCT(td_art_de.[:Id])) as "TD-DE-ArtNr"

FROM dbo.[TecDoc.Articles.ArticlesCouSpec] td_art_de

WHERE
  -- Get the articles for the German market
  td_art_de.[Country:Link] = 'DE'
 
/*
  2021-05-10 = 272574
*/
