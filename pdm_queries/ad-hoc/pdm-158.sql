SELECT 
    pdm_art.[ArticleID], 
    pdm_art.[K24Number], 
    pdm_art.[Manufacturer:Link], 
    pdm_art.[ManufacturerArticleNo], 
    pdm_art.[ManufacturerArticleNoWithoutFormat], 
    art_td.[TecDoc.ArtNo],
    ji.[HER-NR]

FROM [dbo].[Article.Articles] pdm_art 
-- TecDoc articles in the PDM
   LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] art_td ON pdm_art.[:Id] = art_td.[:Id] 
-- Add reporting data
   INNER JOIN [ji_reporting].[dbo].[pdm-158] ji ON pdm_art.[ManufacturerArticleNo] = ji.[HER-NR]

   /*
   ORDER BY
   pdm_art.[ArticleID]

   */