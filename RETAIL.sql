CREATE DATABASE RETAILCASESTUDY;

USE RETAILCASESTUDY;

SELECT * FROM CUSTOMER;
SELECT * FROM prod_cat_info;
SELECT * FROM Transactions;

--------DATA PREPARATION AND UNDERSTANDING-------------

--Total number of rows in each of the 3 tables in database

SELECT
COUNT(*) AS TOT_NUM_ROWS
FROM Customer
UNION
SELECT
COUNT(*) AS TOT_NUM_ROWS
FROM prod_cat_info
UNION
SELECT
COUNT(*) AS TOT_NUM_ROWS
FROM Transactions;

--Total number of transactions that have return

SELECT
COUNT(DISTINCT(Transaction_id)) AS total_tran
FROM Transactions
WHERE QTY < 0;

---Convert the date variables into valid date formuts before proceeding ahead.

SELECT CONVERT(DATE,DOB,105) AS DATE_OF_BIRTH
FROM Customer;

--Time range of the transction data available for analysis
--the output in number of days,months and years simultaneously in different columns.


SELECT
DATEDIFF(DAY,Min(convert(date,TRAN_DATE,105)),Max(convert(date,TRAN_DATE,105))) AS DIFF_DATE,
DATEDIFF(MONTH,Min(convert(date,TRAN_DATE,105)),Max(convert(date,TRAN_DATE,105))) AS DIFF_MONTH,
DATEDIFF(YEAR,Min(convert(date,TRAN_DATE,105)),Max(convert(date,TRAN_DATE,105))) AS DIFF_YEAR 
FROM
Transactions;


--Which product category does the sub_category "DIY" belong to?

SELECT
Prod_cat,prod_subcat
FROM
prod_cat_info
WHERE
prod_subcat = 'DIY';

------------------DATA ANALYSIS-----------------

--Which channel is most frequently used for transcations?

SELECT
TOP 1
STORE_TYPE,
COUNT(*) AS count
FROM
Transactions
GROUP BY STORE_TYPE
ORDER BY Count DESC;

--The count of male and female customers in the database

SELECT
GENDER,
COUNT(*) AS COUNT_GENDER
FROM
Customer
WHERE GENDER IN ('M','F')
GROUP BY GENDER;

--From which city do we have the maximum number of customer and how many

SELECT
TOP 1
city_code,
COUNT(*) AS MAX_NO_CUS
FRom
Customer
GROUP BY city_code
ORDER BY MAX_NO_CUS DESC;


--How many sub-categories are there under the books category?

SELECT
prod_cat,
COUNT(*) AS COUNT_SUBCAT
FROM
prod_cat_info
WHERE
prod_cat = 'BOOKS'
GROUP BY prod_cat
ORDER BY COUNT_SUBCAT DESC;


--What is the maximum quantity of products ever ordered?

SELECT
PROD_CAT_CODE,
MAX(QTY) AS MAX_PROD FROM TRANSACTIONS
GROUP BY PROD_CAT_CODE;

------USING JOIN------

SELECT
T1.prod_cat_code,
MAX(QTY) AS MAX_PROD
FROM
Transactions AS T1
LEFT JOIN
prod_cat_info AS T2
ON T1.prod_cat_code =	T2.prod_cat_code
AND
T1.prod_subcat_code = T2.prod_sub_cat_code
GROUP BY T1.prod_cat_code

--What is the net total revenue generated in categories electronics and books?

SELECT
SUM(TOTAL_AMT) AS NET_TOTAL_REVENUE
FROM
 Transactions AS T1
INNER JOIN
prod_cat_info AS T2
ON T1.prod_cat_code = T2.prod_cat_code
AND
T1.prod_subcat_code =T2.prod_sub_cat_code
WHERE
prod_cat IN ('ELECTRONICS','BOOKS');


ALTER TABLE Transactions
ALTER COLUMN TOTAL_AMT FLOAT

-------OR---------

SELECT
SUM(CAST(TOTAL_AMT AS FLOAT)) AS NET_TOTAL_REVENUE
FROM
 Transactions AS T1
INNER JOIN
prod_cat_info AS T2
ON T1.prod_cat_code = T2.prod_cat_code
AND
T1.prod_subcat_code =T2.prod_sub_cat_code
WHERE
prod_cat IN ('ELECTRONICS','BOOKS');


--How many customers have >10 transactions with us,excluding returns?

SELECT
COUNT(*) AS TOTAL_CUST
FROM
(
SELECT CUST_ID,COUNT(DISTINCT(TRANSACTION_ID)) AS CNT_TRANS
FROM Transactions
WHERE QTY > 0
GROUP BY CUST_ID
HAVING
COUNT(DISTINCT(transaction_id)) > 10
) AS T1


--What is the combined revenue earned from the "Electronics" & "Clothing" categories,from 'Flagship store"?

SELECT
SUM(CAST(TOTAL_AMT AS FLOAT)) AS REVENUE
FROM
Transactions AS T1
INNER JOIN
prod_cat_info AS T2
ON T1.prod_cat_code = T2.prod_cat_code
AND
T1.prod_subcat_code = T2.prod_sub_cat_code
WHERE
T2.prod_cat IN ('Electronics','Clothing')
AND
T1.Store_type = 'Flagship store'
AND
QTY > 0;

--What is the total revenue generated from "Male" customers in "Electronics" category?
--Output should display total revenue by prod sub-cat.

SELECT
PROD_SUBCAT,GENDER,PROD_CAT,
SUM(CAST(TOTAL_AMT AS FLOAT)) AS  TOTAL_REVENUE
FROM
Transactions AS T1
LEFT JOIN
prod_cat_info AS T2
ON T1.prod_cat_code= T2.prod_cat_code
AND
T1.prod_subcat_code = T2.prod_sub_cat_code
 LEFT JOIN
Customer AS T3
ON T3.customer_Id = T1.cust_id
WHERE 
T2.prod_cat = 'Electronics'
AND
GENDER = 'M'
GROUP BY PROD_SUBCAT,GENDER,PROD_CAT;

-------OR-----

SELECT
PROD_SUBCAT,
SUM(CAST(TOTAL_AMT AS FLOAT)) AS  TOTAL_REVENUE
FROM Customer AS T1
LEFT JOIN
Transactions AS T2
ON T1.customer_Id = T2.cust_id
LEFT JOIN
prod_cat_info AS T3
ON T2.prod_cat_code = T3.prod_cat_code
AND
T2.prod_subcat_code = T3.prod_sub_cat_code
WHERE 
GENDER = 'M'
AND
prod_cat = 'Electronics'
GROUP BY PROD_SUBCAT;


--What is percentage of sales and returns by product sub category;
--Display only top 5 sub categories in terms of sales?

-----PERCENTAGE OF SALES

SELECT T5.PROD_SUBCAT,PERCENTAGE_SALES,PERCENTAGE_RETURNS 
FROM
(
SELECT
TOP 5 
PROD_SUBCAT,
(SUM(CAST(TOTAL_AMT AS FLOAT))/(SELECT SUM(CAST(TOTAL_AMT AS FLOAT)) AS TOTAL_SALES 
FROM Transactions
WHERE QTY > 0 )) AS PERCENTAGE_SALES
FROM prod_cat_info AS T1
JOIN
Transactions AS T2
ON T1.PROD_CAT_CODE = T2.prod_cat_code
AND
T1.PROD_SUB_CAT_CODE = T2.prod_subcat_code
WHERE QTY > 0
GROUP BY PROD_SUBCAT
ORDER BY PERCENTAGE_SALES DESC
) AS T5
JOIN
----PERCENTAGE OF RETURNS
(
SELECT
PROD_SUBCAT,
(SUM(CAST(TOTAL_AMT AS FLOAT))/(SELECT SUM(CAST(TOTAL_AMT AS FLOAT)) AS TOTAL_SALES 
FROM Transactions
WHERE QTY < 0 )) AS PERCENTAGE_RETURNS
FROM prod_cat_info AS T1
JOIN
Transactions AS T2
ON T1.PROD_CAT_CODE = T2.prod_cat_code
AND
T1.PROD_SUB_CAT_CODE = T2.prod_subcat_code
WHERE QTY < 0
GROUP BY PROD_SUBCAT) AS T6
ON T5.PROD_SUBCAT = T6.PROD_SUBCAT;


--For all customers aged between 25 to 35 years find what is the net total revenue generated by these consumers
--in last 30 days of transactions from max transaction date available in the data?

SELECT * FROM
(
SELECT * FROM
(
SELECT CUST_ID,
DATEDIFF(YEAR,DOB,MAX_DATE) AS AGE,REVENUE 
FROM 
(
SELECT CUST_ID,DOB,
MAX(CONVERT(DATE,TRAN_DATE,105)) AS MAX_DATE,
SUM(CAST(TOTAL_AMT AS FLOAT)) AS  REVENUE 
FROM Customer AS T1
JOIN
Transactions AS T2
ON T1.customer_Id =T2.cust_id
WHERE QTY > 0
GROUP BY CUST_ID,DOB
) AS A
		)AS B
WHERE AGE BETWEEN 25 AND 35
							  ) AS C
JOIN
(
-----LAST 30 DAYS OF TRANSACTIONS
SELECT CUST_ID,
CONVERT(DATE,TRAN_DATE,105) AS TRAN_DATE
FROM
Transactions
GROUP BY CUST_ID,CONVERT(DATE,TRAN_DATE,105)
HAVING 
CONVERT(DATE,TRAN_DATE,105) > = (SELECT DATEADD(DAY,-30,MAX(CONVERT(DATE,TRAN_DATE,105))) AS CUTOFF_DATE
FROM Transactions)
) AS D
ON C.cust_id = D.CUST_ID

--Which product category has seen the maximum value of returns in the last 3 months of transactions?

SELECT TOP 1 
PROD_CAT_CODE,
SUM(CAST(RETURNS AS FLOAT)) AS TOTAL_RETURNS
FROM
(
SELECT PROD_CAT_CODE,
CONVERT(DATE,TRAN_DATE,105) AS TRAN_DATE,
SUM(CAST(QTY AS FLOAT)) AS RETURNS
FROM
Transactions
WHERE QTY <0
GROUP BY PROD_CAT_CODE,CONVERT(DATE,TRAN_DATE,105)
HAVING 
CONVERT(DATE,TRAN_DATE,105) > = (SELECT DATEADD(MONTH,-3,MAX(CONVERT(DATE,TRAN_DATE,105))) AS CUTOFF_DATE FROM Transactions)
) AS A
GROUP BY PROD_CAT_CODE
ORDER BY TOTAL_RETURNS;

--Which store-type sells maximum products;by the value of sales amount and by quantity sold?

SELECT STORE_TYPE,
SUM(CAST(TOTAL_AMT AS FLOAT)) AS REVENUE,
SUM(CAST(QTY AS FLOAT)) AS QUANTITY
FROM Transactions
WHERE QTY > 0
GROUP BY STORE_TYPE
ORDER BY REVENUE DESC,QUANTITY DESC;

--What are the categories for which average revenue is above the overall average?

SELECT PROD_CAT_CODE,
AVG(CAST(TOTAL_AMT AS FLOAT)) AS AVG_REVENUE
FROM Transactions
WHERE QTY > 0
GROUP BY PROD_CAT_CODE
HAVING AVG(CAST(TOTAL_AMT AS FLOAT)) >= (SELECT AVG(CAST(TOTAL_AMT AS FLOAT)) FROM Transactions WHERE QTY > 0)

--Find the average and total revenue by each subcategory for the categories which are among top 5 categories in terms of quantity sold?

SELECT PROD_SUBCAT_CODE,
SUM(CAST(TOTAL_AMT AS FLOAT)) AS REVENUE,
AVG(CAST(TOTAL_AMT AS FLOAT))  AS AVG_REVENUE
FROM Transactions
WHERE QTY > 0 AND PROD_CAT_CODE IN ( SELECT TOP 5 PROD_CAT_CODE FROM Transactions
									WHERE QTY > 0
									GROUP BY PROD_CAT_CODE
									ORDER BY SUM(QTY) DESC )
GROUP BY PROD_SUBCAT_CODE

ALTER TABLE TRANSACTIONS
ALTER COLUMN QTY FLOAT;
