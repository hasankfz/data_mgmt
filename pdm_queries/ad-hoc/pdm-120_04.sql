/*
Electric	Hybrid	Combustion
459868	1821498	273307965
*/
SELECT

   SUM(EV) as Electric,
   SUM(HV) as Hybrid,
   SUM(CE) as Combustion

FROM dbo.[TecDoc.Linkages.PassengerCars] td_pcl 
-- Get a list of electric vehicles (EVs)
   JOIN (
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
			)  
        td_pc ON td_pcl.[LinkingTarget:Link] = td_pc.PassengerCarNo
/*
GROUP BY
   td_pcl.[Article:Link] 
*/
