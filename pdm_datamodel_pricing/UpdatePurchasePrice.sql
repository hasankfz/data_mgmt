USE [K24Pdm]
GO

UPDATE [dbo].[UpdatePurchasePrice]
   SET [ErpReferenceType:Link] = <ErpReferenceType:Link, nvarchar(25),>
      ,[Article:Link] = <Article:Link, bigint,>
      ,[K24-Number MUTTER] = <K24-Number MUTTER, nvarchar(20),>
      ,[HLK MUTTER] = <HLK MUTTER, nvarchar(20),>
      ,[ATNR MUTTER] = <ATNR MUTTER, nvarchar(50),>
      ,[ReferenceArticle:Link] = <ReferenceArticle:Link, bigint,>
      ,[K24-Number KIND] = <K24-Number KIND, nvarchar(20),>
      ,[HLK KIND] = <HLK KIND, nvarchar(20),>
      ,[ATNR KIND] = <ATNR KIND, nvarchar(50),>
      ,[Supplier:Link] = <Supplier:Link, nvarchar(20),>
      ,[SupplierArticleNumber] = <SupplierArticleNumber, nvarchar(50),>
      ,[ValidFrom] = <ValidFrom, date,>
      ,[ValidTo] = <ValidTo, date,>
      ,[PriceUnit:Link] = <PriceUnit:Link, int,>
      ,[Price] = <Price, decimal(18,2),>
      ,[:Id] = <:Id, uniqueidentifier,>
      ,[WWSPrice] = <WWSPrice, decimal(18,2),>
 WHERE <Suchbedingungen,,>
GO

