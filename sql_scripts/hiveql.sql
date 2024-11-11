create database if not exists live_project_b location '/user/live_project_b';
show databases;

use live_project_b;

CREATE EXTERNAL TABLE IF NOT EXISTS clients_activities (
    client_id INT,
    activity_date TIMESTAMP,
    activity_type STRING,
    activity_location STRING,
    ip_address STRING,
    device STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/live_project_b/clients_activities';

select * from clients_activities;

drop table if exists clients_payments;


CREATE EXTERNAL TABLE IF NOT EXISTS clients_calls_support (
    client_id INT,
    call_date TIMESTAMP,
    duration INT,
    result STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/live_project_b/clients_calls_support';

select * from clients_calls_support;


CREATE EXTERNAL TABLE IF NOT EXISTS clients_logins (
    client_id INT,
    login_date TIMESTAMP,
    ip_address STRING,
    location STRING,
    device STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/live_project_b/clients_logins';

select * from clients_logins;

CREATE EXTERNAL TABLE IF NOT EXISTS clients_payments (
    client_id INT,
    payment_id INT,
    payment_date TIMESTAMP,
    currency STRING,
    amount DECIMAL(12, 2),
    payment_method STRING,
    transaction_id INT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/live_project_b/clients_payments';

select * from clients_payments;

CREATE EXTERNAL TABLE IF NOT EXISTS clients_transactions (
    client_id INT,
    transaction_id INT,
    transaction_date TIMESTAMP,
    transaction_type STRING,
    account_number STRING,
    currency STRING,
    amount DECIMAL(12, 2)
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/live_project_b/clients_transactions';

select * from clients_transactions;