-- SQL_Assignment_4

/*

Charlie's Chocolate Factory company produces chocolates. 

The following product information is stored: product name, product ID, and quantity on hand. 
These chocolates are made up of many components. Each component can be supplied by one or more suppliers. 
The following component information is kept: component ID, name, description, quantity on hand, suppliers who supply them, 
    when and how much they supplied, and products in which they are used. 
On the other hand following supplier information is stored: supplier ID, name, and activation status.

Assumptions:
- A supplier can exist without providing components.
- A component does not have to be associated with a supplier. It may already have been in the inventory.
- A component does not have to be associated with a product. Not all components are used in products.
- A product cannot exist without components. 

Do the following exercises, using the data model.
     a) Create a database named "Manufacturer"
     b) Create the tables in the database.
     c) Define table constraints.

*/

-- Create Database

CREATE DATABASE Manufacturer
GO

-- Create Schemas

CREATE SCHEMA Product
GO
CREATE SCHEMA Component
GO


-- Create Product.Product table

CREATE TABLE Product.Product (
    prod_id INT PRIMARY KEY NOT NULL,
    prod_name NVARCHAR(50) NOT NULL,
    quantity INT NOT NULL);


-- Create Component.Component table

CREATE TABLE Component.Component (
    comp_id INT PRIMARY KEY NOT NULL,
    comp_name NVARCHAR(50) NOT NULL,
    description NVARCHAR(50) NULL,
    quantity_comp INT NULL);


-- Create Product.Prod_Comp table

CREATE TABLE Product.Prod_Comp (
    prod_id INT NOT NULL REFERENCES Product.Product,
    comp_id INT NOT NULL REFERENCES Component.Component,
    quantity_comp INT NULL,
    PRIMARY KEY (prod_id, comp_id));


-- Create Component.Suplier table

CREATE TABLE Component.Supplier (
    supp_id INT PRIMARY KEY NOT NULL,
    supp_name NVARCHAR(50) NOT NULL,
    supp_location NVARCHAR(50) NULL,
    supp_country NVARCHAR(50) NULL,
    is_active BIT NULL);


-- Create Component.Comp_Supp table

CREATE TABLE Component.Comp_Supp (
    supp_id INT NOT NULL REFERENCES Component.Supplier,
    comp_id INT NOT NULL REFERENCES Component.Component,
    order_date DATE NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (supp_id, comp_id));