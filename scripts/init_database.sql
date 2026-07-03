/*
========================================================================
CREATING DATABASE AND THE SCHEMAS
========================================================================
This script is used to create our database called Datawarehouse.
- it first checks if a database named Datawarehouse exists or not
		if NO: create database named Datawarehouse
then it uses Datawarehouse db to store the data.

It also creates three schemas used in the medallion architecture for this project
bronze -> silver -> gold

WARNING: This script ONLY creates the database called Datawarehouse if it does not exists.
if the 'Datawarehouse' db already exists in your sever then make sure to truncate it OR delete it.
*/

USE master;
GO

-- Create the 'Datawarehouse' database if does NOT exist
IF NOT EXISTS(SELECT 1 FROM sys.databases WHERE name='Datawarehouse')
BEGIN
	CREATE DATABASE Datawarehouse;
END;
GO

USE Datawarehouse;
GO


-- Create Schemas
CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
