SELECT DISTINCT
    pdm_art.[Manufacturer:Link] as "Brand", 
    pdm_art.[ManufacturerArticleNo] as "BrandNum", 
    ji.[HER-NR] as "BrandNum-Skruvat",
    pdm_art.[ArticleID], 
    pdm_art.[K24Number] 
--    pdm_art.[ManufacturerArticleNoWithoutFormat], 
--    art_td.[TecDoc.ArtNo]

FROM [ji_reporting].[dbo].[pdm-158] ji 
   LEFT OUTER JOIN [dbo].[Article.Articles] pdm_art ON pdm_art.[ManufacturerArticleNo] = ji.[HER-NR]
-- TecDoc articles in the PDM
   LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] art_td ON pdm_art.[:Id] = art_td.[:Id] 

ORDER BY
   pdm_art.[Manufacturer:Link], 
   pdm_art.[ArticleID]
   