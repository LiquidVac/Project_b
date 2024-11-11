CREATE TABLE IF NOT EXISTS fraud_detection_mart 
WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1
) AS
SELECT
	clients.client_id AS client_id,
	COUNT(transactions.transaction_id) AS total_transactions,
	SUM(CASE WHEN transactions.currency = 'USD' THEN transactions.amount END) AS total_transactions_amount_usd,
	SUM(CASE WHEN transactions.currency = 'RUB' THEN transactions.amount END) AS total_transactions_amount_rub,
	COUNT(DISTINCT transactions.account_number) AS total_transactions_accounts,
	COUNT(payments.payment_id) AS total_payments,
	SUM(CASE WHEN payments.currency = 'USD' THEN payments.amount END) AS total_payments_amount_usd,
	SUM(CASE WHEN payments.currency = 'RUB' THEN payments.amount END) AS total_payments_amount_rub,
	COUNT(logins.login_date) AS total_logins,
	COUNT(DISTINCT logins.ip_address) AS total_ip_addresses,
	COUNT(DISTINCT logins.location) AS total_locations,
	COUNT(DISTINCT logins.device) AS total_devices,
	COUNT(activities.activity_date) AS total_activities,
	COUNT(CASE WHEN activities.activity_type = 'view_account' THEN 1 END) AS total_views_account,
	COUNT(CASE WHEN activities.activity_type = 'chat_support' THEN 1 END) AS total_chats_support,
	COUNT(CASE WHEN activities.activity_type = 'transfer_funds' THEN 1 END) AS total_transfer_funds,
	COUNT(CASE WHEN activities.activity_type = 'pay_bill' THEN 1 END) AS total_pay_bills,
	COUNT(CASE WHEN calls.is_successful IS TRUE THEN 1 END) AS total_resolved_calls,
	COUNT(CASE WHEN calls.is_successful IS FALSE THEN 1 END) AS total_unresolved_calls,
	SUM(calls.duration) AS total_calls_duration,
	-- payment_method
	COUNT(CASE WHEN payments.payment_method = 'credit_card' THEN 1 END) AS total_payments_credit_card,
	SUM(CASE 
		WHEN payments.payment_method = 'credit_card' AND payments.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_credit_card,
	SUM(CASE 
		WHEN payments.payment_method = 'credit_card' AND payments.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_credit_card,
	COUNT(CASE WHEN payments.payment_method = 'debit_card' THEN 1 END) AS total_payments_debit_card,
	SUM(CASE 
		WHEN payments.payment_method = 'debit_card' AND payments.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_debit_card,
	SUM(CASE 
		WHEN payments.payment_method = 'debit_card' AND payments.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_debit_card,
	COUNT(CASE WHEN payments.payment_method = 'bank_transfer' THEN 1 END) AS total_payments_bank_transfer,
	SUM(CASE 
		WHEN payments.payment_method = 'bank_transfer' AND payments.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_bank_transfer,
	SUM(CASE 
		WHEN payments.payment_method = 'bank_transfer' AND payments.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_bank_transfer,
	COUNT(CASE WHEN payments.payment_method = 'e_wallet' THEN 1 END) AS total_payments_e_wallet,
	SUM(CASE 
		WHEN payments.payment_method = 'e_wallet' AND payments.currency = 'USD' 
		THEN payments.amount END) AS total_payments_amount_usd_e_wallet,
	SUM(CASE 
		WHEN payments.payment_method = 'e_wallet' AND payments.currency = 'RUB' 
		THEN payments.amount END) AS total_payments_amount_rub_e_wallet,
	-- transaction_type
	COUNT(CASE WHEN transactions.transaction_type = 'transfer_funds' THEN 1 END) AS total_transactions_transfer_funds,
	SUM(CASE 
		WHEN transactions.transaction_type = 'transfer_funds' AND transactions.currency = 'USD' 
		THEN transactions.amount END) AS total_transactions_usd_transfer_funds,
	SUM(CASE 
		WHEN transactions.transaction_type = 'transfer_funds' AND transactions.currency = 'RUB' 
		THEN transactions.amount END) AS total_transactions_rub_transfer_funds,
	COUNT(CASE WHEN transactions.transaction_type = 'pay_bill' THEN 1 END) AS total_transactions_pay_bill,
	SUM(CASE 
		WHEN transactions.transaction_type = 'pay_bill' AND transactions.currency = 'USD' 
		THEN transactions.amount END) AS total_transactions_usd_pay_bill,
	SUM(CASE 
		WHEN transactions.transaction_type = 'pay_bill' AND transactions.currency = 'RUB' 
		THEN transactions.amount END) AS total_transactions_rub_pay_bill,	
	-- calls_support.result
	COUNT(CASE WHEN calls_support.result = 'resolved' THEN 1 END) AS total_resolved_calls,
	COUNT(CASE WHEN calls_support.result = 'unresolved' THEN 1 END) AS total_unresolved_calls,
	SUM(CASE 
		WHEN calls_support.result = 'resolved'
		THEN calls_support.duration END) AS total_resolved_calls_duration,
	SUM(CASE 
		WHEN calls_support.result = 'unresolved'
		THEN calls_support.duration END) AS total_unresolved_calls_duration

FROM
	clients
LEFT JOIN
	logins USING(client_id)
LEFT JOIN
	activities USING(client_id)
LEFT JOIN
	transactions USING(client_id)
LEFT JOIN
	payments USING(client_id)
LEFT JOIN
	calls USING(client_id)
GROUP BY clients.client_id
DISTRIBUTED BY (client_id);