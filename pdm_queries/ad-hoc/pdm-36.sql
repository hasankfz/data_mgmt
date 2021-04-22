SELECT
  ArticleID,
  K24Number,
  Manufacturer,
  ManufacturerArticleNo,
  Texts:ArticleDesignation[de],
  ArticleProperties:GenericArticle,
  ArticleProperties:SubCategory>ResponsiblePerson>Name,
  Catalog:IsBuyableInWebshop[DE],
  DataWarehouseInformation:ABCClassificationK24,
  ArticleProperties:ArticleStatus,
  DataWarehouseInformation:SalesQuantity12MonthsRolling,
  DataWarehouseInformation:TotalStockQuantity,
  ArticleProperties:IsBulkyGoods,
  Catalog:IsActive

FROM Article.Articles

WHERE (PLACEHOLDER)
  AND (K24Number IS NOT NULL)
  AND (ArticlesHasManufacturerPrioForCountryFilterProvider('DE'))
  AND (Catalog:IsBuyableInWebshop[DE] = true)

ORDER BY DataWarehouseInformation:SalesQuantity12MonthsRolling DESC;