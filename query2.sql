SELECT 
    soh.SalesOrderID AS SalesOrderID,
    p.Name AS ProductName,
    p.ListPrice AS ProductPrice,
    SUM(sod.OrderQty) AS QuantitySold,
    p.Color AS ProductColor,
    sc.Name AS Subcategory,
    pc.Name AS Category,
    SUM(p.ListPrice * sod.OrderQty) AS TotalPurchase
INTO OrderDetail
FROM 
    Sales.SalesOrderDetail AS sod
INNER JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN Production.Product AS p ON sod.ProductID = p.ProductID
LEFT JOIN Production.ProductSubcategory AS sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
LEFT JOIN Production.ProductCategory AS pc ON sc.ProductCategoryID = pc.ProductCategoryID
WHERE soh.SalesOrderID IN (
    SELECT SalesOrderID
    FROM OrderHistory
)
GROUP BY p.ProductID, p.Name, p.ListPrice, p.Color, sc.Name, pc.Name, soh.SalesOrderID
ORDER BY SalesOrderID;