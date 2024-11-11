CREATE TABLE IF NOT EXISTS name (
	client_id INT,
    name TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO name (client_id, name)
SELECT 
    client_id, client_name AS name
FROM
    ext_clients;
   
SELECT * FROM name;

-- email table
CREATE TABLE IF NOT EXISTS email (
	client_id INT,
    email TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO email (client_id, email)
SELECT 
    client_id, client_email
FROM
    ext_clients;
   
SELECT * FROM email;

-- phone table
CREATE TABLE IF NOT EXISTS phone (
	client_id INT,
    phone TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO phone (client_id, phone)
SELECT 
    client_id, client_phone
FROM
    ext_clients;
   
SELECT * FROM phone;

-- address table
CREATE TABLE IF NOT EXISTS address (
	client_id INT,
    address TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO address (client_id, address)
SELECT 
    client_id, client_address
FROM
    ext_clients;
   
SELECT * FROM address;

-- logins table
CREATE TABLE IF NOT EXISTS logins (
	client_id INT,
    login_id SERIAL,
    login_date TIMESTAMP,
    ip_address TEXT,
    device TEXT,
    login_location TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO logins (client_id, login_date, ip_address, device, login_location)
SELECT 
    client_id, login_date, ip_address, device, location
FROM
    ext_logins;
   
SELECT * FROM logins;


-- activities table
CREATE TABLE IF NOT EXISTS activities (
	client_id INT,
    activity_id SERIAL,
    activity_date TIMESTAMP,
    activity_location TEXT,
    ip_address TEXT,
    device TEXT,
    activity_type_id INT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO activities (client_id, activity_date, activity_location, ip_address, device, activity_type_id)
SELECT 
    client_id, activity_date, activity_location, ip_address, device, 
    CASE activity_type
    	WHEN 'transfer_funds' THEN 1
    	WHEN 'view_account' THEN 2
    	WHEN 'pay_bill' THEN 3
    	WHEN 'chat_support' THEN 4
    	WHEN 'call_support' THEN 5
    END 
FROM
    ext_activities;

SELECT * FROM activities;

-- activity_type table
CREATE TABLE IF NOT EXISTS activity_type (
    activity_type_id SERIAL,
    activity_type TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = row,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED REPLICATED;

INSERT INTO activity_type (activity_type)
VALUES 
	('transfer_funds'), 
	('view_account'),
	('pay_bill'),
	('chat_support'),
	('call_support');
    
SELECT * FROM activity_type;

-- calls_support
CREATE TABLE IF NOT EXISTS calls_support (
	client_id INT,
	call_id SERIAL,
	call_date TIMESTAMP,
	duration INT,
	call_result BOOL
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO calls_support (client_id, call_date, duration, call_result)
SELECT 
    client_id, call_date, duration, result
FROM
    ext_calls_support;

SELECT * FROM calls_support;


-- transactions
CREATE TABLE IF NOT EXISTS transactions (
	client_id INT,
	transaction_id BIGINT,
	transaction_date TIMESTAMP,
	account_number TEXT,
	amount NUMERIC(12, 2),
	transaction_type_id INT,
	currency_id INT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO transactions (client_id, transaction_id, transaction_date, account_number, amount, transaction_type_id, currency_id)
SELECT 
    client_id, transaction_id, transaction_date, account_number, amount, 
    CASE transaction_type
    	WHEN 'transfer_funds' THEN 1
    	WHEN 'pay_bill' THEN 2
    END,
    CASE currency
    	WHEN 'USD' THEN 1
    	WHEN 'RUB' THEN 2
    END
FROM
    ext_transactions;
      
SELECT * FROM transactions;

-- transaction_type
CREATE TABLE IF NOT EXISTS transaction_type (
	transaction_type_id SERIAL,
	transaction_type TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = row,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED REPLICATED;

INSERT INTO transaction_type (transaction_type)
VALUES ('transfer_funds'), ('pay_bill');

SELECT * FROM transaction_type;

-- currency
CREATE TABLE IF NOT EXISTS currency (
	currency_id SERIAL,
	currency TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = row,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED REPLICATED;

INSERT INTO currency (currency)
VALUES ('USD'), ('RUB');

SELECT * FROM currency;

-- payment_method 
CREATE TABLE IF NOT EXISTS payment_method  (
	payment_method_id SERIAL,
	payment_method  TEXT
)
WITH (
	appendoptimized = TRUE,
	orientation = row,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED REPLICATED;

INSERT INTO payment_method (payment_method)
VALUES 
	('credit_card'), 
	('debit_card'), 
	('bank_transfer'), 
	('e_wallet');

SELECT * FROM payment_method;

-- payments
CREATE TABLE IF NOT EXISTS payments (
	client_id INT,
	payment_id BIGINT,
	payment_date TIMESTAMP,
	transaction_id INT,
	amount NUMERIC(12, 2),
	currency_id INT,
	payment_method_id INT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
)
DISTRIBUTED BY (client_id);

INSERT INTO payments (client_id, payment_id, payment_date, transaction_id, amount, currency_id, payment_method_id)
SELECT 
    client_id, payment_id, payment_date, transaction_id, amount,
    CASE currency
    	WHEN 'USD' THEN 1
    	WHEN 'RUB' THEN 2
    END,
    CASE payment_method
    	WHEN 'credit_card' THEN 1
		WHEN 'debit_card' THEN 2
		WHEN 'bank_transfer' THEN 3
		WHEN 'e_wallet' THEN 4
    END
FROM
    ext_payments;
      
SELECT * FROM payments;
