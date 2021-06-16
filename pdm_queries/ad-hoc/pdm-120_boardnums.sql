/*
  Provide a list of K24-Numbers for the TecDoc products in the PDM that are for electric vehicles (EVs).
*/
SELECT DISTINCT
   pdm_art.K24Number as "K24-Nr",
   pdm_art.ArticleID as "ArticleID"

FROM dbo.[TecDoc.Articles.Articles] td_art 
-- Add links to passenger cars 
   INNER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_pcl ON td_art.[ArticleNo] = td_pcl.[Article:Link]
-- Include electric vehicles (EVs)
   INNER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]
-- Add brand name
   INNER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] td_brand ON td_art.[DataSupplier:Link] = td_brand.[DataSupplierNo]
-- Add TecDoc articles from the PDM
   INNER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art.[ArticleNo] = art_td.[TecDoc.Link] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
-- Articles in the PDM
   INNER JOIN dbo.[Article.Articles] pdm_art ON art_td.[:Id] = pdm_art.[:Id]
   INNER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]

WHERE
-- Get articles with an active status in TecDoc
   td_art.[State:Link] = '73-001'
-- Get articles for electric vehicles (EVs)
   AND
   ( td_pc.[EngineType:Link] = ('80-040')
     AND
     td_pc.[FuelType:Link] = '182-011' )
-- Get the articles in the PDM with an active status     
   AND
   art_props.[ArticleStatus:Link] = '1'
-- Get the articles in the PDM with a K24 number
   AND
   pdm_art.K24Number IS NOT NULL

ORDER BY
   pdm_art.K24Number,
   pdm_art.ArticleID
