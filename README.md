# Ketocarb app

University Name: [San Jose State University](http://www.sjsu.edu/)

Course: [Cloud Technologies](http://info.sjsu.edu/web-dbgen/catalog/courses/CMPE281.html)

Professor [Sanjay Garje](https://www.linkedin.com/in/sanjaygarje/)

ISA: [Divyankitha Urs](https://www.linkedin.com/in/divyankithaurs/)

Student: [Renato Cordeiro](https://www.linkedin.com/in/renato-c-4281814/), Yu Xu, Lin Cheng, Gyanesh Pandey



## Introduction:
Ketocarb app is an application that allow users to keep track of their food/drink intake



## Screenshots:
![alt text](https://dl.dropboxusercontent.com/s/dpd4uzgostyczf0/ketocarb-screens.png "App screenshots")



## Pre-requisites:

Frontend (mobile app): [Corona SDK](https://www.coronalabs.com)

Backend: PHP 7 with [AWS SDK](https://aws.amazon.com/sdk-for-php/) and PHPRedis



## AWS Resources usage/requirements:

This project uses the following AWS resources:

EC2: 	Web / Application servers.

ELB:	Distributes the requests among the active EC2.

Rekoginition: Identifies food from photo uploaded by user.

Lambda:	It is triggered by new S3 objects (photos) and sends a confirmation email to the user that uploaded it.

AutoScaling Group:	Create new instances if CPU average go over 80%. It is using a Launch Configuration based on a custom EC2 image created especially for this application.

Multi AZ RDS:	Provides a MySQL database which stores users' information.

CloudFront:	It is the front of our backend application. It is configured with 2 origins (ELB and S3)

S3:	Storage place for the photos uploaded by users

R53:	DNS for the application domain (cmpe281.site)







## How to setup:
1. Download / clone this repo;
2. Move the code under "server/php" to an EC2 server. Make sure your EC2 have Apache and PHP 7 installed.
3. (Optional) Create an ELB and Auto Scaling Group for your EC2s
4. Create a S3 bucket and CloudFront distribution with origin to the ELB/EC2 (behavior "*.php") and to S3 (behavior "/" default)
5. Don't forget to have your AWS Keys available in the EC2
6. Update the AWS RDS credentials inside the "server/php/db.php" file.
7. The mobile app is under the "app" folder. You can run it using [Corona SDK](https://www.coronalabs.com). Don't forget to update the "serverURL" variable under "server.lua" to point to your server IP/domain.

