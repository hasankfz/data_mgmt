
/*
  Takes a list of K24-Nr and extracts logistical data from the PDM for them.
*/
SELECT DISTINCT
  imported.[H-Lief],
  imported.[Hersteller> Herstellername] as "Herstellername",

  T1.[Manufacturer:Link] as "Hersteller-ABK",

  imported.[ArtN] as "K24-Nr",

  imported.[Bezeichnung],

  base.[Length] as "Laenge", 
  base.[Width] as "Breite", 
  base.[Height] as "Hoehe", 
  base.[Volume], 
  base.[Weight] as "Gewicht" 

FROM [ji_reporting].[dbo].[Tabellenblatt1$] imported 
  LEFT OUTER JOIN [dbo].[Article.Articles] T1 ON T1.[K24Number] = imported.ArtN
  LEFT OUTER JOIN [dbo].[Article.ExtendedLogisticData] base ON [base].[Article:Link] = T1.[ArticleID]
  LEFT OUTER JOIN [dbo].[Article.Articles:Texts] T2 ON T2.[:Id] = [T1].[:Id]
  LEFT OUTER JOIN [dbo].[Article.Articles:ArticleProperties] T3 ON T3.[:Id] = [T1].[:Id]

WHERE
    base.[PackagingUnit:Link] = 'VPE1'

ORDER BY
  imported.[H-Lief],
  imported.[ArtN]