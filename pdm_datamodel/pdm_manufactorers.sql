SELECT T2.[Name], T2.[TecDoc.Link]
FROM [dbo].[MasterData.Manufacturers] T2 WITH (NOLOCK)
WHERE T2.[Name] LIKE 'ATE'