SELECT 
       base.[GenericArticle:Link] as "GenartNr", 
       T1.[Designation <de>] as "GenartBesc", 
       T2.[Designation <de>] as "K24-Kategorie", 
       T4.[CustomsTariffNumber:Link] as "ZolltarifNr"

FROM [dbo].[Article.GenericArticleReferences] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[MasterData.GenericArticles] T1 WITH (NOLOCK) ON T1.[GenericArticleNo] = [base].[GenericArticle:Link]
  LEFT OUTER JOIN [dbo].[MasterData.AssemblyGroups] T2 WITH (NOLOCK) ON T2.[AssemblyGroupNo] = [T1].[AssemblyGroup:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles] T3 WITH (NOLOCK) ON T3.[ArticleID] = [base].[Article:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T4 WITH (NOLOCK) ON T4.[:Id] = [T3].[:Id]
 
 WHERE 
   T4.[CustomsTariffNumber:Link] IS NOT NULL
   AND
   T4.[ArticleStatus:Link] = '1'

GROUP BY
   base.[GenericArticle:Link], 
   T1.[Designation <de>], 
   T2.[Designation <de>], 
   T4.[CustomsTariffNumber:Link]
 
ORDER BY
   base.[GenericArticle:Link], 
   T1.[Designation <de>], 
   T2.[Designation <de>], 
   T4.[CustomsTariffNumber:Link]
