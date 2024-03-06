SELECT * FROM DB_SCH.WI2_ERP10V2_MDORDERHEAD

DROP TABLE WI2_WOW167_TIMEDIM
DROP TABLE AGG_WI2_WOW167_SALESFACT


CREATE TABLE DB2631257.WI2_WOW167_TIMEDIM(
Time_No DATE PRIMARY KEY,
DAY NUMBER,
MONTH NUMBER,
YEAR NUMBER
);

CREATE TABLE DB2631257.WI2_WOW167_PRODDIM(
Product_No VARCHAR(30) PRIMARY KEY,
DivisionNo VARCHAR(20),
DevisionDescription VARCHAR (30),
ProductionCost NUMBER,
SalesPrice NUMBER,
ProductCategoryNo VARCHAR(30),
ProductCategoryDescription VARCHAR(30),
ProductDescription VARCHAR(30)
);


CREATE TABLE DB2631257.WI2_WOW167_CUSTDIM(
Customer_No VARCHAR(30) PRIMARY KEY,
CityName VARCHAR(30),
SalesOrgNo VARCHAR(30),
SalesOrgDescription VARCHAR(30),
CountryID VARCHAR(30),
CustomerDescription VARCHAR(30),
ValidFrom DATE,
ValidTo DATE
);

CREATE TABLE WI2_WOW167_SALESFACT(
Time_No DATE NOT NULL,
Product_No VARCHAR(30) NOT NULL,
Customer_No VARCHAR(30) NOT NULL,
PRIMARY KEY(Time_No, Product_No, Customer_No),
COSTOFGOODSSOLD NUMBER,
DISCOUNT NUMBER,
REVENUE NUMBER,
SALESQUANTITY NUMBER,
NOOFSALESORDERS NUMBER,
FOREIGN KEY(Time_No) REFERENCES WI2_WOW167_TIMEDIM (Time_No),
FOREIGN KEY(Product_No) REFERENCES WI2_WOW167_PRODDIM (Product_No),
FOREIGN KEY(Customer_No) REFERENCES WI2_WOW167_CUSTDIM (Customer_No)
);

CREATE TABLE AGG_WI2_WOW167_SALESFACT AS
SELECT
    t.Year,
    t.Month,
    p.ProductCategoryNo,
    f.Customer_No,
    COUNT(*) AS FactCount,
    SUM(SALESQUANTITY) AS COSTOFGOODSSOLD,
    SUM(DISCOUNT) AS DISCOUNT,
    SUM(NOOFSALESORDERS) AS NOOFSALESORDERS,
    SUM(SALESQUANTITY) AS REVENUE,
    SUM(SALESQUANTITY) AS SALESQUANTITY
FROM
    WI2_WOW167_SALESFACT f
JOIN WI2_WOW167_PRODDIM p ON
    f.Product_No = p.Product_No
JOIN WI2_WOW167_TIMEDIM t ON
    f.Time_No = t.Time_No
GROUP BY
    Year,
    Month,
    ProductCategoryNo,
    Customer_No;
    
GRANT SELECT ON WI2_WOW167_SALESFACT TO DB_SCH;
GRANT SELECT ON WI2_WOW167_TIMEDIM TO DB_SCH;
GRANT SELECT ON WI2_WOW167_CUSTDIM TO DB_SCH;
GRANT SELECT ON AGG_WI2_WOW167_SALESFACT TO DB_SCH;
GRANT SELECT ON WI2_WOW167_PRODDIM TO DB_SCH;


    
INSERT INTO WI2_WOW167_TIMEDIM (Time_NO, Day, Month, Year)
Values (to_date('2023-05-01', 'yyyy-mm-dd'), 1, 5, 2023)

INSERT INTO WI2_WOW167_TIMEDIM (Time_NO, Day, Month, Year)
Values (to_date('2023-06-02', 'yyyy-mm-dd'), 2, 6, 2023)

INSERT INTO WI2_WOW167_PRODDIM (Product_No, DivisionNo, DevisionDescription, ProductionCost, SalesPrice, ProductCategoryNo, ProductCategoryDescription, ProductDescription)
Values ('1', '1', 'PRO', '30', '40', '1', 'ONP', 'CAR')

INSERT INTO WI2_WOW167_PRODDIM (Product_No, DivisionNo, DevisionDescription, ProductionCost, SalesPrice, ProductCategoryNo, ProductCategoryDescription, ProductDescription)
Values ('2', '2', 'OFG', '23', '30', '2', 'ZHF', 'CAR')

INSERT INTO WI2_WOW167_CUSTDIM (Customer_No, CityName, SalesOrgNo, SalesOrgDescription, CountryID, CustomerDescription, ValidFrom, ValidTo)
VALUES ('1', 'Hamburg', '1', 'OLK', 'DE', 'KHL', to_date('2023-05-01', 'yyyy-mm-dd'), to_date('2023-05-20', 'yyyy-mm-dd'))

INSERT INTO WI2_WOW167_CUSTDIM (Customer_No, CityName, SalesOrgNo, SalesOrgDescription, CountryID, CustomerDescription, ValidFrom, ValidTo)
VALUES ('3', 'NewYork', '2', 'OD', 'US', 'KL', to_date('2022-06-01', 'yyyy-mm-dd'), to_date('2024-06-20', 'yyyy-mm-dd'))

INSERT INTO WI2_WOW167_SALESFACT(Time_No, Product_No, Customer_No, NoOfSalesOrders, CostOfGoodsSold, Discount, Revenue, SalesQuantity)
VALUES (to_date('2023-05-01', 'yyyy-mm-dd'), '1', '1', '1', 20, 10, 20, 25)  


