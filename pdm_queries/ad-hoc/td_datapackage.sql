SELECT  TOP 1000 base.[:Id], 
       base.[:ImageName], 
       base.[ArticleNo], 
       T1.[DataSupplier:Link], 
       T1.[:Id], 
       base.[DataSupplier:Link], 
       T2.[Brand], 
       T2.[:Id], 
       base.[ArtNo], 
       base.[State:Link], 
       T3.[Name], 
       base.[Manufacturer:Link], 
       T4.[Name], 
       T4.[:Id], 
       T5.[Designation], 
       T5.[AdditionalDescription], 
       base.[MatchCode], 
       base.[CatalogNo], 
       base.[StateValidFrom], 
       T6.[NumGenArtReferences], 
       T6.[NumAttributes], 
       T6.[NumPrices], 
       T6.[NumOENumbers], 
       T6.[NumReferenceNumbers], 
       T6.[NumSupersedingArticles], 
       T6.[NumPartsLists], 
       T6.[NumDocuments], 
       T6.[NumInfoTexts], 
       T6.[NumShortCodes], 
       T6.[NumEANs], 
       T6.[NumCountrySpecifics], 
       T6.[NumAccLists], 
       base.[ImportVersionNo], 
       base.[ImportAction], 
       -- HERE
       T2.[VersionNo], 
       T2.[VersionDate]
 FROM [dbo].[TecDoc.Articles.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues] T1 WITH (NOLOCK) ON T1.[KeyValueNo] = [base].[State:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] T2 WITH (NOLOCK) ON T2.[DataSupplierNo] = [base].[DataSupplier:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] T3 WITH (NOLOCK) ON T3.[:Id] = [T1].[:Id] AND T3.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Manufacturer.AftermarketBrands] T4 WITH (NOLOCK) ON T4.[ManufacturerNo] = [base].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles <TecDoc.GeneralData.UsedLanguages>] T5 WITH (NOLOCK) ON T5.[:Id] = [base].[:Id] AND T5.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles:Summary] T6 WITH (NOLOCK) ON T6.[:Id] = [base].[:Id]
 ORDER BY base.[ArticleNo]