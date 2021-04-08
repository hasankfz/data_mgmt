USE [K24Pdm]
GO

UPDATE [ps].[Article.SupplierPrices]
   SET [:Id] = <:Id, uniqueidentifier,>
      ,[:Caption] = <:Caption, nvarchar(80),>
      ,[:Log.CreatedBy] = <:Log.CreatedBy, varchar(60),>
      ,[:Log.CreatedAt] = <:Log.CreatedAt, datetime,>
      ,[:Log.LastModBy] = <:Log.LastModBy, varchar(60),>
      ,[:Log.LastModAt] = <:Log.LastModAt, datetime,>
      ,[ValidFrom] = <ValidFrom, date,>
      ,[ValidTo] = <ValidTo, date,>
      ,[Article:Link] = <Article:Link, bigint,>
      ,[Country:Link] = <Country:Link, nvarchar(2),>
      ,[Currency:Link] = <Currency:Link, nvarchar(3),>
      ,[PriceType:Link] = <PriceType:Link, nvarchar(30),>
      ,[PriceUnit:Link] = <PriceUnit:Link, int,>
      ,[Price] = <Price, decimal(18,2),>
      ,[Supplier:Link] = <Supplier:Link, nvarchar(20),>
      ,[LastPriceDate] = <LastPriceDate, date,>
      ,[PriceScale] = <PriceScale, nvarchar(max),>
 WHERE <Suchbedingungen,,>
GO

