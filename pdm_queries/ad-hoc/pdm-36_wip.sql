/*
  
*/
SELECT TOP 40
   art.[:Id],
   art.[Manufacturer:Link], 
   art.[ManufacturerArticleNo], 
   art.[ArticleID], 
   art.[K24Number],

   art_props.[:Id],
   art_props.CreationDate,
   art_props.ArticleStatusNote,
   art_props.[ArticleDataSource:Link],
   art_props.[GenericArticle:Link],

   art_cat.[:Id],
   art_cat.IsActive,
   art_cat.[IsBuyableInWebshop <DE>],
   art_cat.IsActiveSince,

   art_td.[:Id],
   art_td.StatusValidFrom,
   art_td.[TecDoc.Version],
   art_td.[Status:Link],
   art_td.[IsValid <DE>]

FROM dbo.[Article.Articles] art
INNER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON art.[:Id] = art_props.[:Id]
INNER JOIN dbo.[Article.Articles:Catalog] art_cat ON art.[:Id] = art_cat.[:Id]
INNER JOIN dbo.[Article.Articles:TecDocData] art_td ON art.[:Id] = art_td.[:Id]
-- FROM dbo.[Article.Articles:Texts]

WHERE 
  YEAR(art_props.CreationDate) = '2021'
  AND
  YEAR(art_cat.IsActiveSince) = '2021'
