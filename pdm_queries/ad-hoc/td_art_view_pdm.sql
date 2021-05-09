SELECT TOP 100 
--  base.[:Id], 
  base.[ArtNo], 
  base.[DataSupplier:Link], 
  T2.[Brand], 
  T5.[Designation], 
  T6.[NumGenArtReferences] 
  
 FROM [dbo].[TecDoc.Articles.Articles] base 
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues] T1 ON T1.[KeyValueNo] = [base].[State:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] T2 ON T2.[DataSupplierNo] = [base].[DataSupplier:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] T3 ON T3.[:Id] = [T1].[:Id] AND T3.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Manufacturer.AftermarketBrands] T4 ON T4.[ManufacturerNo] = [base].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles <TecDoc.GeneralData.UsedLanguages>] T5 ON T5.[:Id] = [base].[:Id] AND T5.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles:Summary] T6 ON T6.[:Id] = [base].[:Id]
WHERE 
  base.[ImportVersionNo] = '20210401'
  AND
  base.[State:Link] = '73-001'
  AND
   (EXISTS
     (SELECT masterdata.[:Id]
      FROM [Article.Articles] AS masterdata  WITH(NOLOCK)
      INNER JOIN [MasterData.Manufacturers] AS manufacturer WITH(NOLOCK) ON manufacturer.ManufacturerNo = masterdata.[Manufacturer:Link]
      WHERE
        manufacturer.[TecDoc.Link] = base.[DataSupplier:Link]
        AND
        masterdata.ManufacturerArticleNo = base.ArtNo)
      )
 
 ORDER BY
   base.[ArticleNo]