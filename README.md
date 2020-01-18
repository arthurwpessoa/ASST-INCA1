# Zero Waste Foods <!-- omit in toc -->

## Contents  <!-- omit in toc -->
 
 - [Prerequisits](#prerequisits)
 - [Introduction](#introduction)
 - [Creating Database](#create-database)
 - [Install REST API](#install-rest-api)
 - [Install Client Application](#install-client-application)
 
## Prerequists
| Environment | Version |
| ------------------------------ | ----- |
| Apache PHP | 5.3 + |
| MySQL | 5.1.73 + |
| Google Chrome | 78.0 +  |
| Internet Explorer | 11.535 +  |

## Introduction

Zero Waste Foods consists of a web application that provides low cost healthy lunches to school and university students. The project scope englobes a client-side application and a REST API connecting with a target database (MySQL). 

**Note:** There's a single web application with different routes for admin and end-users.

## Creating zero waste database

In order to enable the Rest API connectivity, you must craete the database schema on MySQL engine. You can find a exported dump with sample data (admin and end-users, registered daily menus and sample orders) under https://github.com/arthurwpessoa/ASST-INCA1/blob/master/database.sql.

1. Connect to MySQL using your admin user credentials
```
mysql -u root -p
```

2. Create the database schema
```
myql> CREATE DATABASE zerowaste;
```

3. Import the zerowaste dump with the sample data

```
mysql -u username -p zerowaste < database.sql
```

4. Check if imported data is present on schema
```
mysql> use zerowaste;
Database changed
mysql> select * from users;
+----+---------------+----------+---------------+-------+----------------------------------+--------------------------------+--------+
| id | firstname     | lastname | username      | admin | password                         | email                          | points |
+----+---------------+----------+---------------+-------+----------------------------------+--------------------------------+--------+
|  1 | Arthur        | Pessoa   | arthur.pessoa |     0 | f65c142ac4d5654d03ae418f0a3f26ec | arthur.pessoa@praguecollege.cz |     75 |
|  2 | Administrator |          | admin         |     1 | 21232f297a57a5a743894a0e4a801fc3 | admin@zerowaste.cz             |      0 |
+----+---------------+----------+---------------+-------+----------------------------------+--------------------------------+--------+
2 rows in set (0.00 sec)
```

## Install REST API
1. Clone the Zero Waste Repository and change the database configurations
```
git clone https://github.com/arthurwpessoa/ASST-INCA1.git
```

After cloning the project, nagivate to /cloned_dir/api/index.php and change line 18, 19 and 20 in accordance with your database configuration
```
	$dbhost = "localhost:3306";
	$dbuser = "root";
	$dbpass = "root";
 ```

2. Move the REST API application to the Apache server:  /cloned_dir/api folder to the php server instance /apache_install_dir/htdocs/zerowaste/api

3. Test if the applicaton is running by accessing some of the zero waste api end-points. You should see a reply from the rest api with an authentication required message. e.g: http://localhost/zerowaste/api/orders/*

```
{
    "status": 401,
    "message": "You need to authenticate to perform this action"
}
```

**Note:** This example considers that your apache server is running on http protocol. 


## Install Client Application
