SELECT  TOP 1000 base.[:Id], 
       base.[:ImageName], 
       base.[Supplier:Link], 
       T1.[Name], 
       T1.[:Id], 
       base.[Article:Link], 
       T2.[Manufacturer:Link], 
       T2.[:Id], 
       T2.[ManufacturerArticleNo], 
       T2.[K24Number], 
       T5.[SupplierArticleNumber], 
       T5.[:Id], 
       T5.[SupplierArticleStatus:Link], 
       T6.[ArticleDesignation <de>], 
       T6.[:Id], 
       base.[PriceType:Link], 
       base.[Currency:Link], 
       base.[Country:Link], 
       base.[ValidFrom], 
       base.[ValidTo], 
       base.[LastPriceDate], 
       base.[Price], 
       base.[PriceUnit:Link]
 FROM [dbo].[Article.SupplierPrices] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[MasterData.Suppliers] T1 WITH (NOLOCK) ON T1.[SupplierNo] = [base].[Supplier:Link]
  LEFT OUTER JOIN [dbo].[Article.Articles] T2 WITH (NOLOCK) ON T2.[ArticleID] = [base].[Article:Link]
  LEFT OUTER JOIN [dbo].[Article.SupplierPrices:ExtendedData] T3 WITH (NOLOCK) ON T3.[:Id] = [base].[:Id]
  LEFT OUTER JOIN [dbo].[Article.SupplierArticles] T4 WITH (NOLOCK) ON T4.[:Id] = [T3].[SupplierArticle:Id]
  LEFT OUTER JOIN [dbo].[Article.SupplierArticles:PurchasingData] T5 WITH (NOLOCK) ON T5.[:Id] = [T4].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T6 WITH (NOLOCK) ON T6.[:Id] = [T2].[:Id]
 ORDER BY base.[Supplier:Link], 
          base.[Article:Link], 
          base.[Country:Link], 
          base.[Currency:Link], 
          base.[PriceType:Link], 
          base.[PriceUnit:Link], 
          base.[ValidFrom], 
          base.[ValidTo]