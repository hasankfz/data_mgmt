/*
   Count the number of products for electric vehicles in TecDoc and in the PDM 
    
*/
SELECT DISTINCT

  COUNT(td_art.[ArtNo]) as "TD-ArtNr",
  COUNT(art_td.[TecDoc.ArtNo]) as "PDM-TD-ArtNr",
  COUNT(art.[ArticleID]) as "PDM-ArtID",
  COUNT(art.[K24Number]) as "K24-Nr"

FROM dbo.[TecDoc.Articles.Articles] td_art WITH (NOLOCK) 
  -- Articles in TecDoc
  LEFT OUTER JOIN dbo.[TecDoc.Linkages.PassengerCars] td_t1 WITH (NOLOCK) ON td_t1.[Article:Link] = td_art.[ArticleNo]
  LEFT OUTER JOIN dbo.[TecDoc.LinkingTargets.PassengerCars] td_t2 WITH (NOLOCK) ON td_t2.[PassengerCarNo] = td_t1.[LinkingTarget:Link]
  -- EngineType  
  LEFT OUTER JOIN dbo.[TecDoc.GeneralData.KeyValues] td_t3 WITH (NOLOCK) ON td_t3.[KeyValueNo] = td_t2.[EngineType:Link]
  LEFT OUTER JOIN dbo.[TecDoc.GeneralData.KeyValues <TecDoc.GeneralData.UsedLanguages>] td_t4 WITH (NOLOCK) ON td_t4.[:Id] = td_t3.[:Id]
              AND td_t4.[:TecDoc.GeneralData.UsedLanguages_Id] = '3e8124e1-b1cd-4faf-bdda-eebbfaf0acfd' -- DE

  -- TecDoc articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles:TecDocData] art_td WITH (NOLOCK) ON art_td.[TecDoc.Link] = td_art.[ArticleNo] -- art_td.[TecDoc.ArtNo] = td_art.[ArtNo]
  -- Articles in the PDM
  LEFT OUTER JOIN dbo.[Article.Articles] art WITH (NOLOCK) ON art.[:Id] = art_td.[:Id]
  LEFT OUTER JOIN dbo.[Article.Articles:ArticleProperties] art_props WITH (NOLOCK) ON art_props.[:Id] = art.[:Id]

WHERE
  -- Use the latest dataset
  (td_art.[ImportVersionNo] = '20210401' OR art_td.[TecDoc.Version] = '20210401')  
  -- Get articles that are active in TecDoc and in the PDM
  AND
  (td_art.[State:Link] = '73-001'
   AND
   art_td.[Status:Link] = '73-001'
   AND
   art_props.[ArticleStatus:Link] = '1'
  )
  -- Get cars with electric engines td_t2.[EngineType:Link] or td_t3.[KeyValueNo]
  AND
  (
      td_t4.[Name] = 'Elektromotor' --80-040
   OR td_t4.[Name] = 'Mild Hybrid' -- 80-048
   OR td_t4.[Name] = 'Full Hybrid' -- 80-048
   OR td_t4.[Name] = 'Plug-In Hybrid' -- 80-046
  ) 
  /*
  TODO:

  -- Get the products that dont have a K24-Nr
  AND
  art.[K24Number] IS NULL

TD-ArtNr  PDM-TD-ArtNr  PDM-ArtID  K24-Nr
147725	147524	147725	147484
238179  237397  238179  237560
170871  170420  170871  170485
175735  175296  175735  175299
732510	730637	732510	730828
 */
