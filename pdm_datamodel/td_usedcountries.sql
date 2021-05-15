/*
  List the countries that are available in TecDoc. 
*/

SELECT
  [CountryCode],
  [Country:Link],
  [ImportVersionNo]

FROM [K24Pdm].[dbo].[TecDoc.GeneralData.UsedCountries]
