# DBFoundations-Module06 - VIEWS
IT FDN 130 A Su 20: Foundations Of Databases

Lisa Jones

August 16, 2020

IT FDN 130 A: Foundations of Database Management

Assignment06 

https://github.com/Lisap-01/DBFoundations-Module06

# **Views**

## **Introduction**

A SQL view is a query, simple or complex, that is named and saved.  The result set of the query can then be viewed over and over again without re-writing the query for every use, and always provides results from up-to-date tables. 
Explain when you would use a SQL View
There are multiple reasons you would use a SQL view.  Below are 3 reasons:

###### **1.	Data Security Purposes**
Views protect privacy when used to filter data that is only available for authorized users. For example, a view may be created from the Employees table to allow HR Managers to view private information such as Employees SSN or DOB.  Whereas, a separate view may be created from the Employees table for an IT Department to view Employees’ employee ID and user ID which may be required to provide the employee authorized access to company applications or data, but withholds the employee’s SSN or DOB.

###### **2.	Data Reporting**
Views may be used to provide reporting to end-users.  Most end-users are unable to write queries to pull the data the need.  Views are easy to use, provide data reports in an easily consumable way, and hides all of the complex tables and raw data in the ‘background’.  Views provide up-to-date information as they always pull the most current data from the database.

###### **3.	Views Don’t Take Space**
>Views are used to store your code, not complete tables. Each time you call a view, you’ll run the related query. Therefore, you don’t lose disk space on views. 
(https://www.sqlshack.com/learn-sql-sql-views/, external site, 2020)


## **Explain are the differences and similarities between a View, Function, and Stored Procedure**
The similarities of Views, Functions and Stored procedures are named statements used to store code. All 3 can be used and reused without having to rewrite the code over and over again.  It saves time and space.
The differences are:
*	A View is an easy-to-use way to select (query) and display existing data stored in one or more tables.
*	A Function is used to process or compute data, and only returns one value, for example it can compute 2 or more columns such as [Number of Units] x [Value per Unit].
*	A Stored Procedure is code commonly used to execute transactions and maintain data, for example,
    -	Inserting data into a table
    -	Updating data in a table
    -	Deleting data in a table

## **Summary**

Views, Functions and Stored Procedures save a lot of time by saving queries and code into reusable database objects.
