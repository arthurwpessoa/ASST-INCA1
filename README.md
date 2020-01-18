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

## Install REST API
1. Clone the Zero Waste Repository 
```
git clone https://github.com/arthurwpessoa/ASST-INCA1.git
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
