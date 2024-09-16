WITH SalesData AS (
    SELECT 
        soh.SalesOrderID AS SalesOrderID,
        soh.TotalDue AS TotalDue,
        soh.OrderDate AS OrderDate,
        per.FirstName + ' ' + per.LastName AS CustomerName,
        st.Name AS SalesTerritory,
        DATENAME(WEEKDAY, soh.OrderDate) AS SaleDayOfWeek,
        DATEPART(WEEKDAY, soh.OrderDate) AS SaleDayNumber
    FROM 
        Sales.SalesOrderDetail AS sod
    INNER JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
    INNER JOIN Sales.Customer AS c ON soh.CustomerID = c.CustomerID
    INNER JOIN Person.Person AS per ON c.PersonID = per.BusinessEntityID
    INNER JOIN Sales.SalesTerritory AS st ON soh.TerritoryID = st.TerritoryID
    WHERE NOT (
        YEAR(soh.OrderDate) = 2014
        AND MONTH(soh.OrderDate) = 6
    )
    GROUP BY 
        soh.SalesOrderID, 
        soh.OrderDate, 
        soh.TotalDue, 
        per.FirstName, 
        per.LastName, 
        st.Name, 
        DATENAME(WEEKDAY, soh.OrderDate),
        DATEPART(WEEKDAY, soh.OrderDate)
)

SELECT 
    sd.SalesOrderID,
    sd.OrderDate,
    sd.CustomerName AS CustomerName,
    CASE 
        WHEN sd.SalesTerritory IN ('Northwest', 'Northeast', 'Central', 'Southeast', 'Southwest') 
        THEN 'America'
        ELSE sd.SalesTerritory
    END AS Territory,
    sd.SaleDayOfWeek AS "DayOfWeek",
    sd.SaleDayNumber AS "DayOfWeekNumber",
    sd.TotalDue AS TotalDue
INTO OrderHistory
FROM
    SalesData AS sd;