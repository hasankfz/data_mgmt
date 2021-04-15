SELECT
       base.[GenericArticleNo] as "Genart-Nr", 
       base.[Designation <de>] as "Genart-Desc-DE", 
       base.[Designation <en>] as "Genart-Desc-EN", 

       T1.[Designation <de>] as "BauGruppe-DE", 
       T1.[Designation <en>] as "BauGruppe-EN", 

       T2.[Description <de>] as "ART-Bezeichng-DE", 
       T2.[Description <en>] as "ART-Bezeichng-EN", 

       T3.[Designation <de>] as "Verwendungszweck-DE", 
       T3.[Designation <en>] as "Verwendungszweck-EN", 

       T5.[Designation] as "K24-Bezeichng", 

       base.[IsUniversalGenericArticle], 
       T4.[IsDangerousGoods], 
       T4.[IsHazardousSubstance],
       base.[DataSupplier:Link]

 FROM [dbo].[MasterData.GenericArticles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[MasterData.AssemblyGroups] T1 WITH (NOLOCK) ON T1.[AssemblyGroupNo] = [base].[AssemblyGroup:Link]
  LEFT OUTER JOIN [dbo].[MasterData.StandardizedArticleDescriptions] T2 WITH (NOLOCK) ON T2.[StandardizedArticleDescriptionNo] = [base].[StandardizedArticleDescription:Link]
  LEFT OUTER JOIN [dbo].[MasterData.PurposeOfUse] T3 WITH (NOLOCK) ON T3.[UsageNo] = [base].[UsagePurpose:Link]
  LEFT OUTER JOIN [dbo].[MasterData.GenericArticles:MasterData] T4 WITH (NOLOCK) ON T4.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[MasterData.SubCategories] T5 WITH (NOLOCK) ON T5.[SubCategoryNo] = [T4].[SubCategory:Link]
 WHERE (((EXISTS(	SELECT *
				                            FROM	[Article.GenericArticleReferences] (NOLOCK) Alias17
				                            WHERE	Alias17.[GenericArticle:Link] = base.GenericArticleNo))))
 ORDER BY base.[Designation <de>], T2.[Description <de>], T3.[Designation <de>]  