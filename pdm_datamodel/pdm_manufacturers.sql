SELECT 
      [ManufacturerNo],
      [Name],
      [TecDoc.Link],
      [TecDoc.Version],
      [ArticleBrand:Link],
      [ManufacturerShortName],
      [IsActive <DE>]

FROM [K24Pdm].[dbo].[MasterData.Manufacturers]

WHERE [TecDoc.Link] IS NOT NULL

ORDER BY
      [TecDoc.Link]