-- clients
CREATE EXTERNAL TABLE ext_clients(
	client_id INT,
	client_name TEXT,
	client_email TEXT,
	client_phone TEXT,
	client_address TEXT
) 
LOCATION ('pxf://user/live_project_b/clean_data/clients?PROFILE=hdfs:csv&SKIP_HEADER_COUNT=1')
FORMAT 'CSV' (DELIMITER ',' NULL '\N' QUOTE '"');

DROP EXTERNAL TABLE ext_clients;

SELECT * FROM ext_clients;

-- clients_activities
CREATE EXTERNAL TABLE ext_activities(
	client_id INT,
	activity_date TIMESTAMP,
	activity_type TEXT,
	activity_location TEXT,
	ip_address TEXT,
	device TEXT
) 
LOCATION ('pxf://user/live_project_b/clean_data/clients_activities?PROFILE=hdfs:csv&SKIP_HEADER_COUNT=1')
FORMAT 'CSV' (DELIMITER ',' NULL '\N' QUOTE '"');

SELECT * FROM ext_activities;

-- clients_calls_support
CREATE EXTERNAL TABLE ext_calls_support(
	client_id INT,
	call_date TIMESTAMP,
	duration INT,
	result BOOL
) 
LOCATION ('pxf://user/live_project_b/clean_data/clients_calls_support?PROFILE=hdfs:csv&SKIP_HEADER_COUNT=1')
FORMAT 'CSV' (DELIMITER ',' NULL '\N' QUOTE '"');

SELECT * FROM ext_calls_support;

-- clients_logins
CREATE EXTERNAL TABLE ext_logins(
	client_id INT,
	login_date TIMESTAMP,
	ip_address TEXT,
	location TEXT,
	device TEXT
) 
LOCATION ('pxf://user/live_project_b/clean_data/clients_logins?PROFILE=hdfs:csv&SKIP_HEADER_COUNT=1')
FORMAT 'CSV' (DELIMITER ',' NULL '\N' QUOTE '"');

SELECT * FROM ext_logins;

-- clients_payments
CREATE EXTERNAL TABLE ext_payments(
	client_id INT,
	payment_id BIGINT,
	payment_date TIMESTAMP,
	currency TEXT,
	amount NUMERIC(12, 2),
	payment_method TEXT, 
	transaction_id BIGINT
) 
LOCATION ('pxf://user/live_project_b/clean_data/clients_payments?PROFILE=hdfs:csv&SKIP_HEADER_COUNT=1')
FORMAT 'CSV' (DELIMITER ',' NULL '\N' QUOTE '"');

SELECT * FROM ext_payments;

-- clients_transactions
CREATE EXTERNAL TABLE ext_transactions(
	client_id INT,
	transaction_id BIGINT,
	transaction_date TIMESTAMP,
	transaction_type TEXT,
	account_number TEXT,
	currency TEXT, 
	amount NUMERIC(12, 2)
) 
LOCATION ('pxf://user/live_project_b/clean_data/clients_transactions?PROFILE=hdfs:csv&SKIP_HEADER_COUNT=1')
FORMAT 'CSV' (DELIMITER ',' NULL '\N' QUOTE '"');

SELECT * FROM ext_transactions;
