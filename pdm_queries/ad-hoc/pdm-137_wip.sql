/*

*/
SELECT TOP 10
   pdm_art.[K24Number],
   pdm_art.[ArticleID],

--   art_props.[GenericArticle:Link],
   ga.[GenericArticleNo],
   ga.[Designation <de>],
   std_desc.[Description <de>],

   CONCAT_WS(': ', T21.[Name <de>], T31.[KeyValue <de>]) as "AVP",
   bass.[UntypedValue],
   bass.[DateValue]
   
FROM dbo.[Article.Articles] pdm_art
   INNER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]
-- Add description for the generic article
   INNER JOIN [dbo].[MasterData.GenericArticles] ga ON art_props.[GenericArticle:Link] = ga.[GenericArticleNo]
   INNER JOIN [dbo].[MasterData.StandardizedArticleDescriptions] std_desc ON ga.[StandardizedArticleDescription:Link] = std_desc.[StandardizedArticleDescriptionNo]
-- TODO: Rewrite how attributes are handled. Every attribute is a row; need an array.
   INNER JOIN [dbo].[Article.ArticleAttributes] bass ON pdm_art.[ArticleID] = bass.[Article:Link]
   INNER JOIN [dbo].[MasterData.Attributes] T21 ON bass.[Attribute:Link] = T21.[AttributeNo]
   INNER JOIN [dbo].[MasterData.KeyValues] T31 ON bass.[KeyValue:Link] = T31.[KeyValueNo]
   
WHERE
 -- Get the articles in the PDM with an active status     
   art_props.[ArticleStatus:Link] = '1'
-- Get the articles in the PDM with a K24 number
   AND
   pdm_art.K24Number IS NOT NULL
-- Add a list of test cases.
   AND	
   pdm_art.[K24Number] IN ('2271-10396')
 
  