create database lportal character set utf8;
grant all privileges on lportal.* TO 'lportal'@'%' identified by 'lportal';
grant all privileges on lportal.* TO 'lportal'@'localhost' identified by 'lportal';
flush privileges;

