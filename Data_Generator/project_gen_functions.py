import random
from faker import Faker
import numpy as np
import pandas as pd
from datetime import datetime, timedelta

fake = Faker()


def random_date(start, end):
    return start + timedelta(seconds=random.randint(0, int((end - start).total_seconds())))


start_date = datetime.now() - timedelta(days=365)
end_date = datetime.now()


def generate_login_data(client_id):
    login_date = random_date(start_date, end_date)
    return {
        'client_id': client_id,
        'login_date': login_date,
        'ip_address': fake.ipv4(),
        'location': f"{random.uniform(-90, 90)}, {random.uniform(-180, 180)}",
        'device': fake.user_agent()
    }


def generate_activity_data(client_id):
    activity_date = random_date(start_date, end_date)
    return {
        'client_id': client_id,
        'activity_date': activity_date,
        'activity_type': random.choice(['view_account', 'transfer_funds', 'pay_bill', 'login', 'logout']),
        'activity_location': fake.uri_path(),
        'ip_address': fake.ipv4(),
        'device': fake.user_agent()
    }


def generate_transaction_data(client_id, transaction_type):
    transaction_date = random_date(start_date, end_date)
    currency = random.choice(['USD', 'RUB'])
    amount = round(random.uniform(100, 10000), 2) if currency == 'USD' else round(random.uniform(9000, 900000), 2)
    return {
        'client_id': client_id,
        'transaction_id': random.randint(1000, 10000),
        'transaction_date': transaction_date,
        'transaction_type': transaction_type,
        'account_number': fake.iban(),
        'currency': currency,
        'amount': amount
    }


def generate_payment_data(client_id, transaction_id):
    payment_date = random_date(start_date, end_date)
    currency = random.choice(['USD', 'RUB'])
    amount = round(random.uniform(100, 10000), 2) if currency == 'USD' else round(random.uniform(9000, 900000), 2)
    return {
        'client_id': client_id,
        'payment_id': random.randint(1000, 10000),
        'payment_date': payment_date,
        'currency': currency,
        'amount': amount,
        'payment_method': random.choice(['credit_card', 'debit_card', 'bank_transfer', 'e_wallet']),
        'transaction_id': transaction_id
    }


def generate_anomalous_data(client_id):
    login_data = generate_login_data(client_id)
    login_data['ip_address'] = fake.ipv4()
    login_data['location'] = f"{random.uniform(-90, 90)}, {random.uniform(-180, 180)}"
    login_records.append(login_data)

    activity_data = generate_activity_data(client_id)
    activity_data['ip_address'] = fake.ipv4()
    activity_data['location'] = f"{random.uniform(-90, 90)}, {random.uniform(-180, 180)}"
    activity_records.append(activity_data)

    transaction_data = generate_transaction_data(client_id, 'payment')
    transaction_data['amount'] *= 10
    transaction_records.append(transaction_data)

    payment_data = generate_payment_data(client_id, transaction_data['transaction_id'])
    payment_data['amount'] *= 10
    payment_records.append(payment_data)
