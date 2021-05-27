/*

*/
SELECT TOP 10
   pdm_art.[:Id],
   pdm_art.[K24Number],
   pdm_art.[ArticleID],
   art_props.[GenericArticle:Link],

   base.[GenericArticle:Link],
   T1.[Designation <de>],
   T2.[Description <de>],

   T21.[Name <de>],
   T31.[KeyValue <de>],
   bass.[UntypedValue],
   bass.[DateValue]
   
FROM dbo.[Article.Articles] pdm_art
   INNER JOIN dbo.[Article.Articles:ArticleProperties] art_props ON pdm_art.[:Id] = art_props.[:Id]

   INNER JOIN [dbo].[MasterData.GenericArticleSynonyms] base ON art_props.[GenericArticle:Link] = base.[GenericArticle:Link]
   INNER JOIN [dbo].[MasterData.GenericArticles] T1 ON T1.[GenericArticleNo] = base.[GenericArticle:Link]
   INNER JOIN [dbo].[MasterData.StandardizedArticleDescriptions] T2 ON T2.[StandardizedArticleDescriptionNo] = T1.[StandardizedArticleDescription:Link]
   INNER JOIN [dbo].[System.Languages] T3 ON T3.[LanguageCode] = base.[Language:Link]
-- TODO: Rewrite how attributes are handled. Every attribute is a row; need an array.
   INNER JOIN [dbo].[Article.ArticleAttributes] bass ON Pdm_art.[ArticleID] = bass.[Article:Link]
   INNER JOIN [dbo].[MasterData.Attributes] T21 ON T21.[AttributeNo] = bass.[Attribute:Link]
   INNER JOIN [dbo].[MasterData.KeyValues] T31 ON T31.[KeyValueNo] = bass.[KeyValue:Link]

WHERE
 -- Get the articles in the PDM with an active status     
   art_props.[ArticleStatus:Link] = '1'
-- Get the articles in the PDM with a K24 number
   AND
   pdm_art.K24Number IS NOT NULL
-- Add a list of test cases.	
   -- pdm_art.[K24Number] IN ('2320-148888','2320-5432') AND
-- Add a reference to the language
   AND
   T3.[Language:Link] = 'de'
  