USE master

--Drop the connect to the database prior to dropping/creating
--Code adapted from http://www.kodyaz.com/articles/kill-all-processes-of-a-database.aspx
DECLARE @DatabaseName nvarchar(50)
SET @DatabaseName = N'Budget'

DECLARE @SQL varchar(max)

SELECT @SQL = COALESCE(@SQL,'') + 'Kill ' + Convert(varchar, SPId) + ';'
FROM MASTER..SysProcesses
WHERE DBId = DB_ID(@DatabaseName) AND SPId <> @@SPId
 
EXEC(@SQL)

--Drop and Create the database
DROP DATABASE IF EXISTS Budget

CREATE DATABASE Budget
GO

USE Budget
GO

--Create Account table
CREATE TABLE dbo.Account (
    AcctID int IDENTITY(1,1) PRIMARY KEY,
    AcctName varchar(50),
    AcctDesc varchar(50)
)

--Create Income table
CREATE TABLE dbo.Income (
    IncomeID int IDENTITY(1,1) PRIMARY KEY,
    IncomeDate datetime,
    IncomePayer varchar(50),
    IncomeAmt decimal(10,2),
    IncomeNotes varchar(100),
    AcctID int FOREIGN KEY REFERENCES [Account](AcctID)
)

--Create Owner table
CREATE TABLE dbo.[Owner] (
    OwnerID int IDENTITY(1,1) PRIMARY KEY,
    OwnerFName varchar(50),
    OwnerLName varchar(50),
    OwnerPhone varchar(12)
)

--Create OwnerAccountJoin table
CREATE TABLE OwnerAccountJoin (
    OwnerID int FOREIGN KEY REFERENCES [Owner](OwnerID),
    AcctID int FOREIGN KEY REFERENCES Account(AcctID),
    CONSTRAINT OwnerAcctJoinID PRIMARY KEY (OwnerID, AcctID)
)

--Create Category table
CREATE TABLE dbo.Category (
    CatID int IDENTITY(1,1) PRIMARY KEY,
    CatName varchar(50)
)

--Create Transaction table
CREATE TABLE dbo.[Transaction] (
    TransID int IDENTITY(1,1) PRIMARY KEY,
    TransDate datetime,
    TransVendor varchar(50),
    TransFixed bit,
    TransAutoDraft bit
)

--Create Details table
CREATE TABLE dbo.Details (
    DetailsID int IDENTITY(1,1) PRIMARY KEY,
    DetailsAmt decimal(10,2),
    DetailsDesc varchar(200),
    DetailsDebitCredit varchar(6),
    TransID int FOREIGN KEY REFERENCES [Transaction](TransID),
    CatID int FOREIGN KEY REFERENCES Category(CatID)
)

--Create PaymentType table
CREATE TABLE dbo.PaymentType (
    PayTypeID int IDENTITY(1,1) PRIMARY KEY,
    PayTypeDesc varchar(50)
)

--Create PaymentDetails table
CREATE TABLE dbo.PaymentDetails (
    PayDetailsID int IDENTITY(1,1) PRIMARY KEY,
    PayDetailsAmt decimal(10,2),
    PayTypeID int FOREIGN KEY REFERENCES PaymentType(PayTypeID),
    TransID int FOREIGN KEY REFERENCES [Transaction](TransID),
    AcctID int FOREIGN KEY REFERENCES Account(AcctID)
)

--Insert records into Account table
INSERT INTO dbo.Account
VALUES ('Chase Checking', 'Checking Account'),
    ('Chase Savings', 'For donations'),
    ('Wells Fargo', 'For investments')

--Insert records into Income table
INSERT INTO dbo.Income
VALUES ('20200113 8:00:00 AM','Haag',1000,'Bonus',1),
    ('20200121 8:00:00 AM','Haag',500,'Reimbursement for airfare',1),
    ('20200131 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200218 8:00:00 AM','Haag',500,'Reimbursement for airfare',1),
    ('20200118 8:00:00 AM','Haag',500,'Reimbursement for airfare',1),
    ('20200228 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200331 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200430 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200529 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200630 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200731 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200831 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200930 8:00:00 AM','Haag',10000,'Monthly payroll',1),
    ('20200113 8:00:00 AM','Parents',100,'Gift',3)

--Insert records into Owner table
INSERT INTO dbo.[Owner]
VALUES ('Marcie', 'Deffenbaugh', '813-867-5309'),
    ('Sally', 'Smith', '502-867-5309')

--Insert records into OwnerAccountJoin table
INSERT INTO dbo.OwnerAccountJoin
VALUES (1,1),
        (1,2),
        (1,3),
        (2,1)

--Insert records into Category table
INSERT INTO dbo.Category
VALUES ('Amazon Membership'),
    ('ATM Withdrawal'),
    ('Booze'),
    ('Car Maintenance'),
    ('Childcare'),
    ('Clothes'),
    ('Coffee'),
    ('Credit Card Membership'),
    ('Eating Out'),
    ('Edith School'),
    ('Edith Toys/Books'),
    ('Electricity'),
    ('Electronics'),
    ('Entertainment'),
    ('Gas'),
    ('Gift'),
    ('Giving'),
    ('Groceries'),
    ('Gym'),
    ('Haircut'),
    ('Home Maintenance/Supplies'),
    ('Hotel'),
    ('Insurance'),
    ('Internet'),
    ('Mortgage'),
    ('Netflix'),
    ('Parking'),
    ('Pet Care'),
    ('Pharmacy'),
    ('Postage'),
    ('Ride Share'),
    ('Savings'),
    ('Shopping'),
    ('Spotify'),
    ('Tattoo'),
    ('Taxes'),
    ('Travel'),
    ('Water')

--Insert records into Transaction table
INSERT INTO dbo.[Transaction]
VALUES ('20200801 8:00:00 AM', 'Top Hat Liquors', 0, 0),
    ('20200801 8:00:00 AM', 'Sweet Surrender', 0, 0),
    ('20200801 8:00:00 AM', 'Dragon King''s Daughter', 0, 0),
    ('20200801 8:00:00 AM', 'Nanz and Kraft', 0, 0),
    ('20200803 8:00:00 AM', 'Home Depot', 0, 0),
    ('20200803 8:00:00 AM', 'AT&T Internet', 1, 0),
    ('20200803 8:00:00 AM', 'Dovenmuehle Mortgage', 1, 1),
    ('20200804 8:00:00 AM', 'Joella''s Hot Chicken', 0, 0),
    ('20200804 8:00:00 AM', 'McAlister''s', 0, 0),
    ('20200804 8:00:00 AM', 'Pigs of Iron LLC', 1, 1),
    ('20200804 8:00:00 AM', 'HSA', 1, 1),
    ('20200804 8:00:00 AM', 'TSA Precheck', 0, 0),
    ('20200805 8:00:00 AM', 'State Farm Insurance', 1, 1),
    ('20200810 8:00:00 AM', 'Top Hat Liquors', 0, 0),
    ('20200810 8:00:00 AM', 'Vint', 0, 0),
    ('20200810 8:00:00 AM', 'Taco Luchador', 0, 0),
    ('20200810 8:00:00 AM', 'CVS', 0, 0),
    ('20200813 8:00:00 AM', 'Lincoln Performing Arts School', 0, 0),
    ('20200813 8:00:00 AM', 'Uncommon Goods', 0, 0),
    ('20200814 8:00:00 AM', 'Metropole', 0, 0),
    ('20200815 8:00:00 AM', 'Metropole', 0, 0),
    ('20200815 8:00:00 AM', 'Taste of Belgium', 0, 0),
    ('20200815 8:00:00 AM', 'Solder & Sage', 0, 0),
    ('20200815 8:00:00 AM', 'Ikea', 0, 0),
    ('20200815 8:00:00 AM', 'Ikea', 0, 0),
    ('20200815 8:00:00 AM', 'Elm Street Parking', 0, 0),
    ('20200816 8:00:00 AM', 'Marathon', 0, 0),
    ('20200817 8:00:00 AM', 'Irish Rover', 0, 0),
    ('20200817 8:00:00 AM', 'Sonic', 0, 0),
    ('20200817 8:00:00 AM', 'First Watch', 0, 0),
    ('20200817 8:00:00 AM', 'Ameristop Foodmart', 0, 0),
    ('20200819 8:00:00 AM', 'Chick-Fil-A', 0, 0),
    ('20200819 8:00:00 AM', 'Trader Joe''s', 0, 0),
    ('20200819 8:00:00 AM', 'Netflix', 1, 1),
    ('20200819 8:00:00 AM', 'Spotify', 1, 1),
    ('20200820 8:00:00 AM', 'Amazon', 0, 0),
    ('20200821 8:00:00 AM', 'ATM', 0, 0),
    ('20200823 8:00:00 AM', 'Amazon', 0, 0),
    ('20200824 8:00:00 AM', 'Giving', 1, 0),
    ('20200824 8:00:00 AM', 'Bed Bath & Beyond', 0, 0),
    ('20200824 8:00:00 AM', 'Home Depot', 0, 0),
    ('20200824 8:00:00 AM', 'Savings', 1, 0),
    ('20200825 8:00:00 AM', 'Trader Joe''s', 0, 0),
    ('20200825 8:00:00 AM', 'Trader Joe''s', 0, 0),
    ('20200825 8:00:00 AM', 'USPS', 0, 0),
    ('20200826 8:00:00 AM', 'Vint', 0, 0),
    ('20200827 8:00:00 AM', 'McDonald''s', 0, 0),
    ('20200831 8:00:00 AM', 'Hilltop', 0, 0),
    ('20200831 8:00:00 AM', 'Please & Thank You', 0, 0),
    ('20200831 8:00:00 AM', 'Butchertown Grocery', 0, 0),
    ('20200831 8:00:00 AM', 'Lauren Browne', 0, 0),
    ('20200901 8:00:00 AM', 'Chase Visa', 0, 0),
    ('20200901 8:00:00 AM', 'LG&E', 0, 0),
    ('20200901 8:00:00 AM', 'Kroger', 0, 0),
    ('20200901 8:00:00 AM', 'Dovenmuehle Mortgage', 1, 1),
    ('20200902 8:00:00 AM', 'Pigs of Iron LLC', 1, 1),
    ('20200902 8:00:00 AM', 'HSA', 1, 1),
    ('20200902 8:00:00 AM', 'AT&T Internet', 1, 0),
    ('20200902 8:00:00 AM', 'USPS', 0, 0),
    ('20200903 8:00:00 AM', 'State Farm Insurance', 1, 1),
    ('20200904 8:00:00 AM', 'Banana Republic', 0, 0),
    ('20200904 8:00:00 AM', 'Amazon', 0, 0),
    ('20200907 8:00:00 AM', 'Old Town Wine & Spirit', 0, 0),
    ('20200908 8:00:00 AM', 'Molly Malone''s', 0, 0),
    ('20200908 8:00:00 AM', 'Liquor Night Shop', 0, 0),
    ('20200908 8:00:00 AM', 'Taco Luchador', 0, 0),
    ('20200908 8:00:00 AM', 'Alchemy Restaurant', 0, 0),
    ('20200911 8:00:00 AM', 'AirBnB', 0, 0),
    ('20200912 8:00:00 AM', 'Amazon', 0, 0),
    ('20200914 8:00:00 AM', 'Biscuit Belly', 0, 0),
    ('20200914 8:00:00 AM', 'Hilltop', 0, 0),
    ('20200915 8:00:00 AM', 'QDoba', 0, 0),
    ('20200917 8:00:00 AM', 'Louisville Grows', 0, 0),
    ('20200917 8:00:00 AM', 'Change Today Change Tomorrow', 0, 0),
    ('20200917 8:00:00 AM', 'Girls Rock Louisville', 0, 0),
    ('20200917 8:00:00 AM', 'Louisville Free Public Library', 0, 0),
    ('20200917 8:00:00 AM', 'No Kill Louisville', 0, 0),
    ('20200917 8:00:00 AM', 'Savings', 0, 0),
    ('20200917 8:00:00 AM', 'Giving', 0, 0),
    ('20200917 8:00:00 AM', 'Savings', 0, 0),
    ('20200918 8:00:00 AM', 'Circle K', 0, 0),
    ('20200919 8:00:00 AM', 'Banana Republic', 0, 0),
    ('20200919 8:00:00 AM', 'Banana Republic', 0, 0),
    ('20200920 8:00:00 AM', 'Simply Thai', 0, 0),
    ('20200921 8:00:00 AM', 'Netflix', 1, 1),
    ('20200921 8:00:00 AM', 'Spotify', 1, 1),
    ('20200922 8:00:00 AM', 'Hilary Parker', 0, 0),
    ('20200922 8:00:00 AM', 'Banana Republic', 0, 0),
    ('20200926 8:00:00 AM', 'Chik''n & Mi', 0, 0),
    ('20200927 8:00:00 AM', 'Kroger', 0, 0),
    ('20200927 8:00:00 AM', 'Home Depot', 0, 0),
    ('20200928 8:00:00 AM', 'Crescent Hill Parlour', 0, 0),
    ('20200928 8:00:00 AM', 'The Wine Rack', 0, 0),
    ('20200928 8:00:00 AM', 'Irish Rover', 0, 0),
    ('20200928 8:00:00 AM', 'Amazon', 0, 0),
    ('20200928 8:00:00 AM', 'Tu Xing Tao Etsy', 0, 0),
    ('20200929 8:00:00 AM', 'Amway', 0, 0),
    ('20200929 8:00:00 AM', 'KY Revenue Department', 0, 0)

--Insert records into Details table
INSERT INTO dbo.Details 
VALUES (33.9, NULL, 'Debit', 1, 3),
    (15.75, NULL, 'Debit', 2, 9),
    (62.54, NULL, 'Debit', 3, 9),
    (13.25, NULL, 'Debit', 4, 16),
    (269.48, NULL, 'Debit', 5, 21),
    (50, NULL, 'Debit', 6, 24),
    (2009.26, NULL, 'Debit', 7, 25),
    (19.98, NULL, 'Debit', 8, 9),
    (24.75, NULL, 'Debit', 9, 9),
    (47.7, NULL, 'Debit', 10, 19),
    (58.25, NULL, 'Debit', 11, 21),
    (85, NULL, 'Debit', 12, 37),
    (70.06, NULL, 'Debit', 13, 23),
    (73.1, NULL, 'Debit', 14, 3),
    (7.16, NULL, 'Debit', 15, 7),
    (32.74, NULL, 'Debit', 16, 9),
    (4.97, NULL, 'Debit', 17, 29),
    (45.01, NULL, 'Debit', 18, 10),
    (61.33, NULL, 'Debit', 19, 16),
    (31.03, NULL, 'Debit', 20, 3),
    (157.33, NULL, 'Debit', 21, 9),
    (69.48, NULL, 'Debit', 22, 9),
    (72.42, NULL, 'Debit', 23, 16),
    (1375.7, NULL, 'Debit', 24, 21),
    (263.94, 'Ikea return', 'Credit', 25, 21),
    (5, NULL, 'Debit', 26, 27),
    (25.27, NULL, 'Debit', 27, 15),
    (70.32, NULL, 'Debit', 28, 9),
    (16.62, NULL, 'Debit', 29, 9),
    (45.99, NULL, 'Debit', 30, 9),
    (16.05, NULL, 'Debit', 31, 9),
    (22.81, NULL, 'Debit', 32, 9),
    (162.74, NULL, 'Debit', 33, 18),
    (13.69, NULL, 'Debit', 34, 26),
    (10.59, NULL, 'Debit', 35, 34),
    (44.44, 'Bubbles; hoola hoop', 'Debit', 36, 11),
    (24.04, 'Stapler; staples; tape', 'Debit', 36, 21),
    (20.3, 'Dog food', 'Debit', 36, 28),
    (27.95, 'OrganiCup', 'Debit', 36, 29),
    (40, NULL, 'Debit', 37, 2),
    (4.21, 'Movie rental', 'Debit', 38, 14),
    (500, NULL, 'Debit', 39, 17),
    (26.47, NULL, 'Debit', 40, 21),
    (85.43, NULL, 'Debit', 41, 21),
    (500, NULL, 'Debit', 42, 32),
    (8.46, NULL, 'Debit', 43, 3),
    (17.49, NULL, 'Debit', 44, 18),
    (10.64, NULL, 'Debit', 45, 30),
    (17.73, NULL, 'Debit', 46, 7),
    (2.12, NULL, 'Debit', 47, 9),
    (30.45, NULL, 'Debit', 48, 3),
    (11.75, NULL, 'Debit', 49, 7),
    (51.66, NULL, 'Debit', 50, 9),
    (200, 'Furniture', 'Debit', 51, 21),
    (95, NULL, 'Debit', 52, 8),
    (173.95, NULL, 'Debit', 53, 12),
    (26.21, NULL, 'Debit', 54, 18),
    (2009.26, NULL, 'Debit', 55, 25),
    (47.7, NULL, 'Debit', 56, 19),
    (58.25, NULL, 'Debit', 57, 21),
    (50, NULL, 'Debit', 58, 24),
    (7.75, NULL, 'Debit', 59, 30),
    (70.06, NULL, 'Debit', 60, 23),
    (280.9, NULL, 'Debit', 61, 6),
    (4.21, 'Movie rental', 'Debit', 62, 14),
    (65.71, NULL, 'Debit', 63, 3),
    (17.72, NULL, 'Debit', 64, 3),
    (58.29, NULL, 'Debit', 65, 3),
    (30.87, NULL, 'Debit', 66, 9),
    (38.76, NULL, 'Debit', 67, 9),
    (130.2, NULL, 'Debit', 68, 22),
    (4.21, 'Movie rental', 'Debit', 69, 14),
    (41.58, NULL, 'Debit', 70, 9),
    (56.61, NULL, 'Debit', 71, 9),
    (25.55, NULL, 'Debit', 72, 9),
    (1000, NULL, 'Debit', 73, 17),
    (1000, NULL, 'Debit', 74, 17),
    (1000, NULL, 'Debit', 75, 17),
    (1000, NULL, 'Debit', 76, 17),
    (1000, NULL, 'Debit', 77, 17),
    (100, NULL, 'Debit', 78, 32),
    (500, NULL, 'Debit', 79, 17),
    (500, NULL, 'Debit', 80, 32),
    (28.37, NULL, 'Debit', 81, 15),
    (182.32, 'Clothes return', 'Credit', 82, 6),
    (284.61, NULL, 'Debit', 83, 6),
    (51.34, NULL, 'Debit', 84, 9),
    (13.69, NULL, 'Debit', 85, 26),
    (10.59, NULL, 'Debit', 86, 34),
    (175, NULL, 'Debit', 87, 5),
    (251.86, NULL, 'Debit', 88, 6),
    (66.06, NULL, 'Debit', 89, 9),
    (200.89, NULL, 'Debit', 90, 18),
    (42.12, NULL, 'Debit', 91, 21),
    (27.24, NULL, 'Debit', 92, 3),
    (31.78, NULL, 'Debit', 93, 3),
    (17, NULL, 'Debit', 94, 3),
    (9.99, 'Chalk', 'Debit', 95, 11),
    (42.39, NULL, 'Debit', 96, 16),
    (46.61, 'Dog food; brush; hair removal brush; dog leash', 'Debit', 95, 28),
    (45.58, NULL, 'Debit', 97, 21),
    (10.15, NULL, 'Debit', 98, 36)

--Insert records into PaymentType table
INSERT INTO dbo.PaymentType
VALUES ('Chase Visa'),
    ('Southwest Visa'),
    ('Chase Debit'),
    ('Cash'),
    ('Check'),
    ('Venmo'),
    ('Paypal'),
    ('Zelle'),
    ('Gift Card'),
    ('Auto withdrawal')

--Insert records into PaymentDetails table
INSERT INTO dbo.PaymentDetails
VALUES (33.9, 1, 1, 1),
(15.75, 1, 2, 1),
(62.54, 1, 3, 1),
(13.25, 1, 4, 1),
(269.48, 1, 5, 1),
(50, 3, 6, 1),
(2009.26, 10, 7, 1),
(19.98, 2, 8, 1),
(24.75, 3, 9, 1),
(47.7, 10, 10, 1),
(58.25, 10, 11, 1),
(85, 1, 12, 1),
(70.06, 10, 13, 1),
(44.5, 1, 14, 1),
(28.6, 3, 14, 1),
(7.16, 3, 15, 1),
(32.74, 3, 16, 1),
(4.97, 3, 17, 1),
(45.01, 1, 18, 1),
(61.33, 1, 19, 1),
(31.03, 1, 20, 1),
(157.33, 1, 21, 1),
(69.48, 1, 22, 1),
(72.42, 1, 23, 1),
(1375.7, 1, 24, 1),
(263.94, 1, 25, 1),
(5, 2, 26, 1),
(25.27, 2, 27, 1),
(70.32, 1, 28, 1),
(16.62, 3, 29, 1),
(45.99, 3, 30, 1),
(16.05, 3, 31, 1),
(22.81, 2, 32, 1),
(162.74, 1, 33, 1),
(13.69, 10, 34, 1),
(10.59, 10, 35, 1),
(116.73, 1, 36, 1),
(40, 3, 37, 1),
(4.21, 1, 38, 1),
(500, 3, 39, 1),
(26.47, 3, 40, 1),
(85.43, 3, 41, 1),
(500, 3, 42, 1),
(8.46, 3, 43, 1),
(17.49, 3, 44, 1),
(10.64, 3, 45, 1),
(17.73, 3, 46, 1),
(2.12, 3, 47, 1),
(30.45, 3, 48, 1),
(11.75, 3, 49, 1),
(51.66, 3, 50, 1),
(200, 6, 51, 1),
(95, 1, 52, 1),
(173.95, 3, 53, 1),
(26.21, 3, 54, 1),
(2009.26, 10, 55, 1),
(47.7, 10, 56, 1),
(58.25, 10, 57, 1),
(50, 3, 58, 1),
(7.75, 3, 59, 1),
(70.06, 10, 60, 1),
(280.9, 1, 61, 1),
(4.21, 1, 62, 1),
(65.71, 1, 63, 1),
(17.72, 3, 64, 1),
(58.29, 3, 65, 1),
(30.87, 3, 66, 1),
(38.76, 3, 67, 1),
(130.2, 1, 68, 1),
(4.21, 1, 69, 1),
(41.58, 1, 70, 1),
(56.61, 3, 71, 1),
(25.55, 3, 72, 1),
(1000, 1, 73, 2),
(1000, 1, 74, 2),
(1000, 1, 75, 2),
(1000, 1, 76, 2),
(1000, 1, 77, 2),
(100, 3, 78, 1),
(500, 3, 79, 1),
(500, 3, 80, 1),
(28.37, 3, 81, 1),
(182.32, 1, 82, 1),
(284.61, 1, 83, 1),
(51.34, 2, 84, 1),
(13.69, 10, 85, 1),
(10.59, 10, 86, 1),
(175, 6, 87, 1),
(251.86, 1, 88, 1),
(66.06, 1, 89, 1),
(200.89, 1, 90, 1),
(42.12, 2, 91, 1),
(27.24, 3, 92, 1),
(31.78, 3, 93, 1),
(17, 3, 94, 1),
(56.6, 1, 95, 1),
(42.39, 3, 96, 1),
(45.58, 2, 97, 1),
(10.15, 3, 98, 1)


--BEGINNING OF CLASS REQUIREMENTS
--The queries are numbered in order as they appeared on the SQL Project Requirements PDF document. The index queries were moved to the top of the code since they help improve performance.

--QUERY 17: Design a NONCLUSTERED INDEX with ONE KEY COLUMN that improves the performance of one of the above queries
    --Improves performance of QUERY 16
CREATE NONCLUSTERED INDEX IX_PaymentDetails_PayDetailsID
ON dbo.PaymentDetails (PayDetailsID)

--QUERY 18: Design a NONCLUSTERED INDEX with TWO KEY COLUMNS that improves the performance of one of the above queries
    --Improves performance of QUERY 13
CREATE NONCLUSTERED INDEX IX_Details_DetailsID_DetailsAmt
ON dbo.Details (DetailsID, DetailsAmt)

--QUERY 19: Design a NONCLUSTERED INDEX with AT LEAST ONE KEY COLUMN and AT LEAST ONE INCLUDED COLUMN that improves the performance of one of the above queries
    --Improves performance of QUERY 10
CREATE NONCLUSTERED INDEX IX_Transaction_TransID
ON dbo.[Transaction] (TransID)
INCLUDE (TransVendor)

--QUERY 1: Write a SELECT query that uses a WHERE clause
SELECT i.IncomePayer, i.IncomeDate, i.IncomeAmt
FROM dbo.Income i
WHERE IncomeAmt < 1000

--QUERY 2: Write a SELECT query that uses an OR and an AND operator
SELECT d.DetailsAmt, d.DetailsDesc, c.CatName
FROM dbo.Details d
INNER JOIN dbo.Category c 
ON d.CatID = c.CatID
WHERE d.DetailsAmt < 50 AND (c.CatName = 'Booze' OR c.CatName = 'Eating Out')

--QUERY 3: Write a SELECT query that filters NULL rows using IS NOT NULL
SELECT d.DetailsAmt, d.DetailsDesc, d.DetailsDebitCredit, c.CatName
FROM dbo.Details d
INNER JOIN dbo.Category c 
ON d.CatID = c.CatID 
WHERE d.DetailsDesc IS NOT NULL

--QUERY 4: Write a DML statement that UPDATEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable
Declare @vendor varchar(50) = 'Amazon'

UPDATE dbo.[Transaction]
SET TransVendor = 'Amazon Online'
WHERE TransVendor = @vendor

--Set data back to original format
Declare @vendor2 varchar(50) = 'Amazon Online'

UPDATE dbo.[Transaction]
SET TransVendor = 'Amazon'
WHERE TransVendor = @vendor2

--QUERY 5: Write a DML statement that DELETEs a set of rows with a WHERE clause. The values used in the WHERE clause should be a variable
Declare @amount int = 5

DELETE
FROM dbo.Details
WHERE DetailsAmt < @amount


--QUERY 6: Write a DML statement that DELETEs rows from a table that another table references. This script will have to also DELETE any records that reference these rows. Both of the DELETE statements need to be wrapped in a single TRANSACTION.
BEGIN TRANSACTION 
    --Utilizing @vendor variable declared on line 514
    --Delete from PaymentDetails table
    DELETE
    FROM dbo.PaymentDetails
    WHERE TransID IN (
        SELECT t.TransID
        FROM dbo.[Transaction] t
        WHERE t.TransVendor = @vendor
    )

    --Delete from Details table
    DELETE
    FROM dbo.Details
    WHERE TransID IN (
        SELECT t.TransID
        FROM dbo.[Transaction] t
        WHERE t.TransVendor = @vendor
    )

    --Delete from Transaction table
    DELETE
    FROM dbo.[Transaction]
    WHERE TransVendor = @vendor
COMMIT 


--QUERY 7: Write a SELECT query that utilizes a JOIN
SELECT t.TransVendor, t.TransFixed, t.TransAutoDraft, p.PayDetailsAmt
FROM dbo.[Transaction] t 
INNER JOIN dbo.PaymentDetails p 
ON t.TransID = p.TransID


--QUERY 8: Write a SELECT query that utilizes a JOIN with 3 or more tables
SELECT t.TransDate, t.TransVendor, d.DetailsAmt, d.DetailsDebitCredit, c.CatName
FROM dbo.[Transaction] t
INNER JOIN (dbo.Category c 
INNER JOIN dbo.Details d 
ON c.CatID = d.CatID) 
ON t.TransID = d.TransID 


--QUERY 9: Write a SELECT query that utilizes a LEFT JOIN
SELECT c.CatName, d.DetailsAmt
FROM dbo.Category c
LEFT JOIN dbo.Details d 
ON d.CatID = c.CatID
WHERE d.DetailsAmt IS NULL


--QUERY 10: Write a SELECT query that utilizes a variable in the WHERE clause
Declare @category varchar(50) = 'Booze'

SELECT t.TransVendor, t.TransDate, d.DetailsAmt, d.DetailsDebitCredit, c.CatName
FROM dbo.[Transaction] t
INNER JOIN (dbo.Category c 
INNER JOIN dbo.Details d 
ON c.CatID = d.CatID) 
ON t.TransID = d.TransID 
WHERE c.CatName = @category


--QUERY 11: Write a SELECT query that utilizes a ORDER BY clause
SELECT i.IncomeDate, i.IncomePayer, i.IncomeAmt
FROM dbo.Income i
ORDER BY i.IncomeDate


--QUERY 12: Write a SELECT query that utilizes a GROUP BY clause along with an aggregate function
SELECT COUNT(d.DetailsID), c.CatName
FROM dbo.Details d
INNER JOIN dbo.Category c 
ON d.CatID = c.CatID 
GROUP BY c.CatName


--QUERY 13: Write a SELECT query that utilizes a CALCULATED FIELD
SELECT COUNT(d.DetailsID) AS 'CatCount', SUM(d.DetailsAmt) AS 'DetailsAmtPerCat', c.CatName, '%' + STR(ROUND(SUM(d.DetailsAmt)/COUNT(d.DetailsID), 0)) AS 'CalculatedAvgSpend'
FROM dbo.Details d
INNER JOIN dbo.Category c 
ON d.CatID = c.CatID 
GROUP BY c.CatName


--QUERY 14: Write a SELECT query that utilizes a SUBQUERY
SELECT t.TransDate, t.TransVendor
FROM dbo.[Transaction] t 
WHERE t.TransDate > (
    SELECT i.IncomeDate
    FROM dbo.Income i
    WHERE i.IncomeDate BETWEEN '2020-08-01' AND '2020-09-01'
)


--QUERY 15: Write a SELECT query that utilizes a JOIN, at least 2 OPERATORS (AND, OR, =, IN, BETWEEN, ETC) AND A GROUP BY clause with an aggregate function
SELECT ROUND(AVG(pd.PayDetailsAmt), 0) AS 'RoundedAverage', COUNT(pd.PayDetailsAmt) AS 'AmountCount', pt.PayTypeDesc
FROM dbo.PaymentDetails pd 
INNER JOIN dbo.PaymentType pt 
ON pd.PayTypeID = pt.PayTypeID
WHERE (pd.PayDetailsAmt BETWEEN 10 AND 100) AND pt.PayTypeDesc <> 'Venmo'
GROUP BY pt.PayTypeDesc


--QUERY 16: Write a SELECT query that utilizes a JOIN with 3 or more tables, at 2 OPERATORS (AND, OR, =, IN, BETWEEN, ETC), a GROUP BY clause with an aggregate function, and a HAVING clause
SELECT t.TransVendor, pt.PayTypeDesc, MAX(p.PayDetailsAmt) As MaxAmt
FROM dbo.[Transaction] t
INNER JOIN (dbo.PaymentDetails p 
INNER JOIN dbo.PaymentType pt 
ON pt.PayTypeID = p.PayTypeID) 
ON t.TransID = p.TransID
WHERE (t.TransDate BETWEEN '2020-08-15' AND '2020-09-30') AND (pt.PayTypeDesc LIKE '%Visa%' OR pt.PayTypeDesc LIKE '%Debit%')
GROUP BY pt.PayTypeDesc, t.TransVendor
HAVING t.TransVendor = 'Amazon' OR t.TransVendor = 'Home Depot'