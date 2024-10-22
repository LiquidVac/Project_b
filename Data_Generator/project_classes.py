import project_gen_functions as fun


class Login:
    def __init__(self, client_id=None):
        self.client_id = client_id
        self.login_date = fun.random_date(fun.start_date, fun.end_date)
        self.ip_address = fun.fake.ipv4()
        self.location = f'{fun.random.uniform(-90, 90)}, {fun.random.uniform(-180, 180)}'
        self.device = fun.fake.user_agent()

    def login_data_to_dict(self):
        return {
            'client_id': self.client_id,
            'login_date': self.login_date,
            'ip_address': self.ip_address,
            'location': self.location,
            'device': self.device
        }


class Activity(Login):
    def __init__(self, login_instance):
        super().__init__(login_instance.client_id)
        self.login_date = login_instance.login_date
        self.ip_address = login_instance.ip_address
        self.location = login_instance.location
        self.device = login_instance.device
        self.activity_date = fun.random_date(self.login_date, fun.end_date)
        self.activity_type = fun.random.choice(['view_account', 'transfer_funds', 'pay_bill', 'logout', 'login'])
        self.activity_location = fun.fake.uri_path()

    def activity_data_to_dict(self):
        return {
            'client_id': self.client_id,
            'activity_date': self.activity_date,
            'activity_type': self.activity_type,
            'activity_location': self.activity_location,
            'ip_address': self.ip_address,
            'device': self.device
        }


class Client:
    def __init__(self, client_id=None):
        self.client_id = client_id
        self.name = fun.fake.name()
        self.logins = []
        self.activities = []
        self.transactions = []
        self.payments = []

    def add_login(self, login):
        self.logins.append(login)

    def add_activity(self, activity):
        self.activities.append(activity)

    def add_transaction(self, transaction):
        self.transactions.append(transaction)

    def add_payment(self, payment):
        self.payments.append(payment)

    def generate_anomalous_data(self):
        for _ in self.payments:
            if fun.random.random() < 0.01:
                _.amount *= 10
                # super(_).amount *= 100000000
        for _ in self.transactions:
            if fun.random.random() < 0.01:
                _.amount *= 10


class Transaction(Activity):
    def __init__(self, activity_instance, receiver=None):
        super().__init__(activity_instance)
        self.login_date = activity_instance.login_date
        self.ip_address = activity_instance.ip_address
        self.location = activity_instance.location
        self.device = activity_instance.device
        self.activity_date = activity_instance.activity_date
        self.activity_type = activity_instance.activity_type
        self.activity_location = activity_instance.activity_location
        self.receiver = receiver
        self.transaction_date = fun.random_date(self.activity_date, self.activity_date + fun.timedelta(days=1))
        self.currency = fun.random.choice(['USD', 'RUB'])
        self.amount = round(fun.random.uniform(100, 10000), 2) if self.currency == 'USD' \
            else round(fun.random.uniform(9000, 900000), 2)
        self.transaction_id = fun.random.randint(1000, 10000)
        self.account_number = fun.fake.iban()

    def transaction_data_to_dict(self):
        return {
            'client_id': self.client_id,
            'transaction_id': self.transaction_id,
            'transaction_date': self.transaction_date,
            'transaction_type': self.activity_type,
            'account_number': self.account_number,
            'currency': self.currency,
            'amount': self.amount
        }


class Payment(Transaction):
    def __init__(self, transaction_instance):
        super().__init__(transaction_instance)
        self.login_date = transaction_instance.login_date
        self.ip_address = transaction_instance.ip_address
        self.location = transaction_instance.location
        self.device = transaction_instance.device
        self.activity_date = transaction_instance.activity_date
        self.activity_type = transaction_instance.activity_type
        self.activity_location = transaction_instance.activity_location
        self.receiver = transaction_instance.receiver
        self.transaction_date = transaction_instance.transaction_date
        self.currency = transaction_instance.currency
        self.amount = transaction_instance.amount
        self.transaction_id = transaction_instance.transaction_id
        self.account_number = transaction_instance.account_number
        self.payment_id = fun.random.randint(1000, 10000)
        self.payment_date = fun.random_date(self.transaction_date, self.transaction_date + fun.timedelta(days=1))
        self.payment_method = fun.random.choice(['credit_card', 'debit_card', 'bank_transfer', 'e_wallet'])

    def payment_data_to_dict(self):
        return {
            'client_id': self.client_id,
            'payment_id': self.payment_id,
            'payment_date': self.payment_date,
            'currency': self.currency,
            'amount': self.amount,
            'payment_method': self.payment_method,
            'transaction_id': self.transaction_id
        }
