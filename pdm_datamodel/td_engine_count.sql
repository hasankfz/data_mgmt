/*
  Count the number of perconal cars (PCs or PKWs) by engine type
*/
SELECT 
   SUM(EV) as Electric,
   SUM(HV) as Hybrid,
   SUM(CE) as Combustion

   FROM (
       	 SELECT
            td_pc.PassengerCarNo,
            (CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
			        td_pc.[EngineType:Link] = ('80-040')
					AND
					td_pc.[FuelType:Link] = '182-011'
			   THEN 1
			   ELSE 0
			   END) as EV,
            (CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
					td_pc.[EngineType:Link] IN ('80-046','80-048','80-049')
			   THEN 1
			   ELSE 0
			   END) as HV,
			(CASE 
			   WHEN td_pc.ImportVersionNo = '20210401'
			        AND
					td_pc.[EngineType:Link] NOT IN ('80-040','80-046','80-048','80-049')
			   THEN 1
			   ELSE 0
			   END) as CE

            FROM dbo.[TecDoc.LinkingTargets.PassengerCars] td_pc 
			) td_pc
