-- таблица client_all_aggregation
CREATE TABLE client_all_aggregation
  WITH (
	appendoptimized = TRUE,
	orientation = column,
	compresstype = zstd,
	compresslevel = 1) 
    AS (
SELECT 
	client_id,
	total_logins,
	total_ip_addresses,
	total_locations,
	total_devices,
	total_activities,
	total_views_account,
	total_chats_support,
	total_resolved_calls,
	total_unresolved_calls,
	total_resolved_calls_duration,
	total_unresolved_calls_duration,
	total_payments_credit_card,
	total_payments_amount_usd_credit_card, 
	total_payments_amount_rub_credit_card, 
	total_payments_debit_card, 
	total_payments_amount_usd_debit_card,
	total_payments_amount_rub_debit_card,
	total_payments_bank_transfer,
	total_payments_amount_usd_bank_transfer,
	total_payments_amount_rub_bank_transfer,
	total_payments_e_wallet,
	total_payments_amount_usd_e_wallet,
	total_payments_amount_rub_e_wallet,
	total_transactions_account,
	total_transactions_transfer_funds, 
	total_transactions_usd_transfer_funds, 
	total_transactions_rub_transfer_funds, 
	total_transactions_pay_bill,
	total_transactions_usd_pay_bill,
	total_transactions_rub_pay_bill
FROM name
JOIN client_logins using(client_id)
JOIN client_calls_support using(client_id)
JOIN client_activities using(client_id)
JOIN client_payments using(client_id)
JOIN client_transactions using(client_id)
) 
DISTRIBUTED BY (client_id);

SELECT * FROM client_all_aggregation;
