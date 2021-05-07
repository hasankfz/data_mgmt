SELECT  TOP 1000 
--  base.[:Id], 
  base.[ArtNo], 
  base.[DataSupplier:Link], 
  T2.[Brand], 
  T5.[Designation], 
  base.[StateValidFrom], 
  T6.[NumGenArtReferences] 
  
 FROM [dbo].[TecDoc.Articles.Articles] base WITH (NOLOCK) 
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues] T1 WITH (NOLOCK) ON T1.[KeyValueNo] = [base].[State:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.DataSupplier] T2 WITH (NOLOCK) ON T2.[DataSupplierNo] = [base].[DataSupplier:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] T3 WITH (NOLOCK) ON T3.[:Id] = [T1].[:Id] AND T3.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Manufacturer.AftermarketBrands] T4 WITH (NOLOCK) ON T4.[ManufacturerNo] = [base].[Manufacturer:Link]
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles <TecDoc.GeneralData.UsedLanguages>] T5 WITH (NOLOCK) ON T5.[:Id] = [base].[:Id] AND T5.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd'
  LEFT OUTER JOIN [dbo].[TecDoc.Articles.Articles:Summary] T6 WITH (NOLOCK) ON T6.[:Id] = [base].[:Id]
WHERE 
  base.[State:Link] = '73-001'
  AND
  base.[ImportVersionNo] = '20210401'
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
   base.[StateValidFrom] DESC,
   base.[ArticleNo]