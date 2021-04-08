USE [K24Pdm]
GO

UPDATE [ps].[Lookup.PriceUnits]
   SET [:Id] = <:Id, uniqueidentifier,>
      ,[:Caption] = <:Caption, nvarchar(80),>
      ,[:Log.CreatedBy] = <:Log.CreatedBy, varchar(60),>
      ,[:Log.CreatedAt] = <:Log.CreatedAt, datetime,>
      ,[:Log.LastModBy] = <:Log.LastModBy, varchar(60),>
      ,[:Log.LastModAt] = <:Log.LastModAt, datetime,>
      ,[PriceUnitNo] = <PriceUnitNo, int,>
      ,[Amount] = <Amount, int,>
      ,[TecDocPriceUnit:Link] = <TecDocPriceUnit:Link, nvarchar(20),>
      ,[Designation <en>] = <Designation <en>, nvarchar(80),>
      ,[Designation <de>] = <Designation <de>, nvarchar(80),>
      ,[Designation <pl>] = <Designation <pl>, nvarchar(80),>
      ,[Designation <cs>] = <Designation <cs>, nvarchar(80),>
      ,[Designation <da>] = <Designation <da>, nvarchar(80),>
      ,[Designation <es>] = <Designation <es>, nvarchar(80),>
      ,[Designation <fi>] = <Designation <fi>, nvarchar(80),>
      ,[Designation <fr>] = <Designation <fr>, nvarchar(80),>
      ,[Designation <it>] = <Designation <it>, nvarchar(80),>
      ,[Designation <nl>] = <Designation <nl>, nvarchar(80),>
      ,[Designation <no>] = <Designation <no>, nvarchar(80),>
      ,[Designation <sv>] = <Designation <sv>, nvarchar(80),>
      ,[Designation <tr>] = <Designation <tr>, nvarchar(80),>
 WHERE <Suchbedingungen,,>
GO

