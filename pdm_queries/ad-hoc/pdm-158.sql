SELECT DISTINCT
    pdm_art.[Manufacturer:Link] as "Brand", 
    pdm_art.[ManufacturerArticleNo] as "BrandNum", 
    ji.[HER-NR] as "BrandNum-Skruvat",
    pdm_art.[ArticleID], 
    pdm_art.[K24Number] 
--    pdm_art.[ManufacturerArticleNoWithoutFormat], 
--   pdm_art.ManufacturerArticleNoWithoutSpaces
--    art_td.[TecDoc.ArtNo]

FROM [ji_reporting].[dbo].[pdm-158_import] ji 
   LEFT OUTER JOIN [dbo].[Article.Articles] pdm_art ON TRIM(ji.[HER-NR]) = pdm_art.[ManufacturerArticleNo]
                                                    OR TRIM(ji.[HER-NR]) = pdm_art.[ManufacturerArticleNoWithoutSpaces]
-- TecDoc articles in the PDM
   LEFT OUTER JOIN [dbo].[Article.Articles:TecDocData] art_td ON pdm_art.[:Id] = art_td.[:Id] 

WHERE
   pdm_art.[Manufacturer:Link] IN ('SKF','TRW','VAL','BOH') 

ORDER BY
   pdm_art.[Manufacturer:Link], 
   pdm_art.[ArticleID]
   