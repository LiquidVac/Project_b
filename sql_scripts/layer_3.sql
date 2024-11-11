-- таблица client_transactions
CREATE TABLE IF NOT EXISTS client_transactions (
	client_id INT,
	total_transactions_account INT,
	total_transactions_transfer_funds INT, 
	total_transactions_usd_transfer_funds BIGINT, 
	total_transactions_rub_transfer_funds BIGINT, 
	total_transactions_pay_bill INT,
	total_transactions_usd_pay_bill BIGINT,
	total_transactions_rub_pay_bill BIGINT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1) 
DISTRIBUTED BY (client_id);

INSERT INTO client_transactions 
	(client_id, total_transactions_account, total_transactions_transfer_funds, 
	total_transactions_usd_transfer_funds,total_transactions_rub_transfer_funds, 
	total_transactions_pay_bill, total_transactions_usd_pay_bill, total_transactions_rub_pay_bill)
SELECT client_id, 
	COUNT(DISTINCT transactions.account_number) AS total_transactions_accounts,
	COUNT(CASE WHEN transaction_type.transaction_type = 'transfer_funds' THEN 1 END) AS total_transactions_transfer_funds,
	SUM(CASE 
		WHEN transaction_type.transaction_type = 'transfer_funds' AND currency.currency = 'USD' 
		THEN transactions.amount END) AS total_transactions_usd_transfer_funds,
	SUM(CASE 
		WHEN transaction_type.transaction_type = 'transfer_funds' AND currency.currency = 'RUB' 
		THEN transactions.amount END) AS total_transactions_rub_transfer_funds,
	COUNT(CASE WHEN transaction_type.transaction_type = 'pay_bill' THEN 1 END) AS total_transactions_pay_bill,
	SUM(CASE 
		WHEN transaction_type.transaction_type = 'pay_bill' AND currency.currency = 'USD' 
		THEN transactions.amount END) AS total_transactions_usd_pay_bill,
	SUM(CASE 
		WHEN transaction_type.transaction_type = 'pay_bill' AND currency.currency = 'RUB' 
		THEN transactions.amount END) AS total_transactions_rub_pay_bill
 FROM name LEFT JOIN transactions using(client_id)
 LEFT JOIN transaction_type using(transaction_type_id)
 LEFT JOIN currency using(currency_id)
 GROUP BY client_id;

-- чистим nulls
SELECT update_nulls_to_zero('client_transactions', 
		ARRAY['total_transactions_usd_transfer_funds', 'total_transactions_rub_transfer_funds', 
		'total_transactions_usd_pay_bill', 'total_transactions_rub_pay_bill']);
	
SELECT * FROM client_transactions;

-- таблица client_payments
CREATE TABLE IF NOT EXISTS client_payments (
	client_id INT,
	total_payments_credit_card INT,
	total_payments_amount_usd_credit_card BIGINT, 
	total_payments_amount_rub_credit_card BIGINT, 
	total_payments_debit_card INT, 
	total_payments_amount_usd_debit_card BIGINT,
	total_payments_amount_rub_debit_card BIGINT,
	total_payments_bank_transfer INT,
	total_payments_amount_usd_bank_transfer BIGINT,
	total_payments_amount_rub_bank_transfer BIGINT,
	total_payments_e_wallet INT,
	total_payments_amount_usd_e_wallet BIGINT,
	total_payments_amount_rub_e_wallet BIGINT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1) 
DISTRIBUTED BY (client_id);

INSERT INTO client_payments (	
	client_id, total_payments_credit_card, total_payments_amount_usd_credit_card,
	total_payments_amount_rub_credit_card, total_payments_debit_card,
	total_payments_amount_usd_debit_card, total_payments_amount_rub_debit_card,
	total_payments_bank_transfer, total_payments_amount_usd_bank_transfer,
	total_payments_amount_rub_bank_transfer, total_payments_e_wallet,
	total_payments_amount_usd_e_wallet, total_payments_amount_rub_e_wallet
	)
SELECT 
	client_id, 
	COUNT(CASE WHEN payment_method.payment_method = 'credit_card' THEN 1 END) AS total_payments_credit_card,
	SUM(CASE 
		WHEN payment_method.payment_method = 'credit_card' AND currency.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_credit_card,
	SUM(CASE 
		WHEN payment_method.payment_method = 'credit_card' AND currency.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_credit_card,
	COUNT(CASE WHEN payment_method.payment_method = 'debit_card' THEN 1 END) AS total_payments_debit_card,
	SUM(CASE 
		WHEN payment_method.payment_method = 'debit_card' AND currency.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_debit_card,
	SUM(CASE 
		WHEN payment_method.payment_method = 'debit_card' AND currency.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_debit_card,
	COUNT(CASE WHEN payment_method.payment_method = 'bank_transfer' THEN 1 END) AS total_payments_bank_transfer,
	SUM(CASE 
		WHEN payment_method.payment_method = 'bank_transfer' AND currency.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_bank_transfer,
	SUM(CASE 
		WHEN payment_method.payment_method = 'bank_transfer' AND currency.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_bank_transfer,
	COUNT(CASE WHEN payment_method.payment_method = 'e_wallet' THEN 1 END) AS total_payments_e_wallet,
	SUM(CASE 
		WHEN payment_method.payment_method = 'e_wallet' AND currency.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_e_wallet,
	SUM(CASE 
		WHEN payment_method.payment_method = 'e_wallet' AND currency.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_e_wallet
FROM name 
LEFT JOIN payments using(client_id)
LEFT JOIN payment_method using(payment_method_id)
LEFT JOIN currency using(currency_id)
GROUP BY client_id;

SELECT update_nulls_to_zero('client_payments', 
	ARRAY['total_payments_amount_usd_credit_card', 'total_payments_amount_rub_credit_card',
	'total_payments_amount_usd_debit_card', 'total_payments_amount_rub_debit_card',
	'total_payments_amount_usd_bank_transfer', 'total_payments_amount_rub_bank_transfer',
	'total_payments_amount_usd_e_wallet', 'total_payments_amount_rub_e_wallet']);
SELECT * FROM client_payments;

-- таблица client_logins
CREATE TABLE IF NOT EXISTS client_logins (
	client_id INT,
	total_logins INT,
	total_ip_addresses INT,
	total_locations INT,
	total_devices INT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1) 
DISTRIBUTED BY (client_id);

INSERT INTO client_logins (
	client_id,
	total_logins,
	total_ip_addresses,
	total_locations,
	total_devices
)
SELECT 
	client_id,
	COUNT(logins.login_date) AS total_logins,
	COUNT(DISTINCT logins.ip_address) AS total_ip_addresses,
	COUNT(DISTINCT logins.login_location) AS total_locations,
	COUNT(DISTINCT logins.device) AS total_devices
FROM name 
LEFT JOIN logins using(client_id)
GROUP BY client_id;

SELECT * FROM client_logins;

-- таблица client_activities
CREATE TABLE IF NOT EXISTS client_activities (
	client_id INT,
	total_activities INT,
	total_views_account INT,
	total_chats_support INT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1) 
DISTRIBUTED BY (client_id);

INSERT INTO client_activities (
	client_id,
	total_activities,
	total_views_account,
	total_chats_support
)
SELECT 
	client_id,
	COUNT(activities.activity_date) AS total_activities,
	COUNT(CASE WHEN activity_type.activity_type = 'view_account' THEN 1 END) AS total_views_account,
	COUNT(CASE WHEN activity_type.activity_type = 'chat_support' THEN 1 END) AS total_chats_support
FROM name
LEFT JOIN activities using(client_id)
LEFT JOIN activity_type using(activity_type_id)
GROUP BY client_id;

SELECT * FROM client_activities;

-- таблица client_calls_support
CREATE TABLE IF NOT EXISTS client_calls_support (
	client_id INT,
	total_resolved_calls INT,
	total_unresolved_calls INT,
	total_resolved_calls_duration INT,
	total_unresolved_calls_duration INT
)
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1) 
DISTRIBUTED BY (client_id);

INSERT INTO client_calls_support(
	client_id,
	total_resolved_calls,
	total_unresolved_calls,
	total_resolved_calls_duration,
	total_unresolved_calls_duration
)
SELECT 
	client_id,
	COUNT(CASE WHEN calls_support.call_result = TRUE THEN 1 END) AS total_resolved_calls,
	COUNT(CASE WHEN calls_support.call_result = FALSE THEN 1 END) AS total_unresolved_calls,
	SUM(CASE 
		WHEN calls_support.call_result = TRUE
		THEN calls_support.duration END) AS total_resolved_calls_duration,
	SUM(CASE 
		WHEN calls_support.call_result = FALSE
		THEN calls_support.duration END) AS total_unresolved_calls_duration
FROM name 
LEFT JOIN calls_support using(client_id)
GROUP BY client_id;

SELECT update_nulls_to_zero('client_calls_support', ARRAY['total_resolved_calls_duration', 'total_unresolved_calls_duration']);
SELECT * FROM client_calls_support;