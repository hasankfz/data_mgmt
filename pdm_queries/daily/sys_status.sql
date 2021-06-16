/*
  A query to view the current performance of the database system.
*/
-- EXEC sp_who 

SELECT 
   sp.spid,
   sp.waittime,
   sp.lastwaittype,
   sp.cpu,
   sp.physical_io,
   sp.memusage,
   sp.login_time,
   sp.last_batch,
   sp.status,
   sp.program_name,
   sp.cmd,
   sp.loginame

FROM master.dbo.sysprocesses sp 
JOIN master.dbo.sysdatabases sd ON sp.dbid = sd.dbid

WHERE
   sd.name = 'K24Pdm'
   AND
   sp.status IN ('suspended','runnable')
/* AND
   sp.waittime <> 10
*/

ORDER BY
   sp.cpu DESC,
   sp.memusage DESC,
   sp.physical_io DESC,
   sp.loginame

