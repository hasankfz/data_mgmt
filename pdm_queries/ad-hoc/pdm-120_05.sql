SELECT TOP 100 

/*
  T10.[Designation] as "K24-Kategorie", 
  T8.[Designation] as "TD-Genart", 
  T11.[ArticleNo] as "TD-ArtNr", 
  td_art.[TecDoc.ArtNo] as "PDM-TD-ArtNr",

  art.[ArticleID] as "PDM-ArtID", 
  art.[K24Number] as "K24-Nr",

  art.[Manufacturer:Link], -- JPP
  manu.[TecDoc.Link] -- 156

count(distinct(td_art.[:Id]))

*/

td_art.[Manufacturer:Link],
td_art.[ArticleNo],
td_art.[ArtNo],

art_td.[TecDoc.ArtNo],
art_td.[TecDoc.Link],

art.[ArticleID],
art.[ManufacturerArticleNo],
art.[Manufacturer:Link],
art.[K24Number],
md_manu.[ManufacturerNo], -- ATE, BRO
md_manu.[Name], -- ATE, BREMBO
md_manu.[TecDoc.Link], -- 3, 65
md_manu.[ArticleBrand:Link] -- 503, 875

FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK)
     -- 6903998 unique articles
     LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td WITH (NOLOCK) ON art_td.[TecDoc.Link] = td_art.[ArticleNo] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
	 -- 2519100 unique articles
     LEFT OUTER JOIN dbo.[Article.Articles] art WITH (NOLOCK) ON art.[:Id] = art_td.[:Id]
     LEFT OUTER JOIN dbo.[MasterData.Manufacturers] md_manu WITH (NOLOCK) ON md_manu.[ArticleBrand:Link] = td_art.[Manufacturer:Link] -- md_manu.[ManufacturerNo] = art.[Manufacturer:Link]

WHERE
  (td_art.[ImportVersionNo] = '20210401' OR art_td.[TecDoc.Version] = '20210401')  
  AND
  (td_art.[State:Link] = '73-001' AND art_td.[Status:Link] = '73-001')

/*
  TODO:
*/
