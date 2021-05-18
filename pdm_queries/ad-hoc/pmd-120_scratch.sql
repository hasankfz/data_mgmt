SELECT DISTINCT 
-- COUNT(DISTINCT(td_art_pcs_CTE.Article)) -- Articles in TecDoc with links to passenger cars
-- td_art_combine_nr_CTE.TDArticleNrs, -- Articles in TecDoc
td_art_pcs_CTE.Article as "TD-ArtNr", -- Articles in TecDoc with links to passenger cars
art.ArticleID as "PDM-ArticleID",
art.K24Number as "PDM-K24Nr"

FROM td_art_combine_nr_CTE
-- Extract the number of articles related to passenger cars
   INNER JOIN td_art_pcs_CTE ON td_art_combine_nr_CTE.TDArticleNrs = CAST(td_art_pcs_CTE.Article as varchar) -- td_art.[ArticleNo] = td_pcl.[Article:Link]

-- Extract the artices for EVs
   INNER JOIN td_ev_CTE ON td_art_pcs_CTE.Car = td_ev_CTE.TDEVNr --  td_pcl.[LinkingTarget:Link] = td_pc.[PassengerCarNo]

   LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td ON td_art_pcs_CTE.Article = art_td.[TecDoc.Link]          
   LEFT OUTER JOIN dbo.[Article.Articles] art ON art_td.[:Id] = art.[:Id]
   LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON art.[:Id] = art_props.[:Id]

WHERE
   art_props.[ArticleStatus:Link] = '1'

GROUP BY
td_art_pcs_CTE.Article,
art.ArticleID,
art.K24Number

ORDER BY
td_art_pcs_CTE.Article

/*
   AND 
   art.K24Number IS NOT NULL
*/
