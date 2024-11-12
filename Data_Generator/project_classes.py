import project_gen_functions as fun


class Login:
    def __init__(self, client_id: int):
        self.client_id = client_id
        self.login_date = fun.random_date(fun.start_date, fun.end_date)
        self.ip_address = fun.fake.ipv4()
        self.location = f'{fun.random.uniform(-90, 90)}, {fun.random.uniform(-180, 180)}'
        self.device = fun.fake.user_agent()

    def login_data_to_dict(self) -> dict:
        return {
            'client_id': self.client_id,
            'login_date': self.login_date,
            'ip_address': self.ip_address,
            'location': self.location,
            'device': self.device
        }


class Activity(Login):
    def __init__(self, login_instance: Login):
        for attribute in vars(login_instance):
            setattr(self, attribute, getattr(login_instance, attribute))
        self.activity_date = fun.random_date(self.login_date, fun.end_date)
        self.activity_type = ''.join(fun.random.choices(['view_account', 'transfer_funds', 'pay_bill', 'call_support',
                                                'chat_support'], [7, 3, 3, 1, 2]))
        self.activity_location = fun.fake.uri_path()

    def activity_data_to_dict(self) -> dict:
        return {
            'client_id': self.client_id,
            'activity_date': self.activity_date,
            'activity_type': self.activity_type,
            'activity_location': self.activity_location,
            'ip_address': self.ip_address,
            'device': self.device
        }


class Transaction(Activity):
    def __init__(self, activity_instance: Activity, receiver=None):
        for attribute in vars(activity_instance):
            setattr(self, attribute, getattr(activity_instance, attribute))
        self.receiver = receiver
        self.transaction_date = fun.random_date(self.activity_date, self.activity_date + fun.timedelta(days=1))
        self.currency = fun.random.choice(['USD', 'RUB'])
        self.amount = round(fun.random.uniform(100, 10000), 2) if self.currency == 'USD' \
            else round(fun.random.uniform(9000, 900000), 2)
        self.transaction_id = fun.random.randint(1000, 1000000000)
        self.account_number = fun.fake.iban()

    def transaction_data_to_dict(self) -> dict:
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
        for attribute in vars(transaction_instance):
            setattr(self, attribute, getattr(transaction_instance, attribute))
        self.payment_id = fun.random.randint(1000, 1000000000)
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


class CallSupport(Activity):
    def __init__(self, activity_instance):
        for attribute in vars(activity_instance):
            setattr(self, attribute, getattr(activity_instance, attribute))
        self.duration = fun.random.randint(60, 1800)
        self.result = fun.random.choice(['resolved', 'unresolved'])

    def call_support_data_to_dict(self):
        return {
            'client_id': self.client_id,
            'call_date': self.activity_date,
            'duration': self.duration,
            'result': self.result
        }


class Client:
    def __init__(self, client_id=None):
        self.client_id = client_id
        self.name = fun.fake.name()
        self.client_email = fun.fake.email()
        self.client_phone = fun.fake.phone_number()
        self.client_address = fun.fake.address()
        self.logins = []
        self.activities = []
        self.transactions = []
        self.payments = []
        self.calls_support = []

    def add_login(self, login):
        self.logins.append(login)

    def add_activity(self, activity):
        self.activities.append(activity)

    def add_transaction(self, transaction):
        self.transactions.append(transaction)

    def add_payment(self, payment):
        self.payments.append(payment)

    def add_call_support(self, call_support):
        self.calls_support.append(call_support)

    def make_login_and_inheritors(self, max_activities_per_login, call=False):
        login = Login(self.client_id)
        self.add_login(login)
        for _ in range(fun.random.randint(1, max_activities_per_login)):
            activity = Activity(login)
            self.add_activity(activity)
            if activity.activity_type in ['transfer_funds', 'pay_bill']:
                transaction = Transaction(activity)
                payment = Payment(transaction)
                self.add_transaction(transaction)
                self.add_payment(payment)
            if call:
                if activity.activity_type == 'call_support':
                    call_support = CallSupport(activity)
                    self.add_call_support(call_support)

    def generate_anomalous_amount(self):
        for payment in self.payments: 
            if fun.random.random() < 0.05:
                payment.amount *= 10

    def generate_anomalous_logins(self, max_activities_per_login):
        if fun.random.random() < 0.024:
            for _ in range(50):
                self.make_login_and_inheritors(max_activities_per_login, call=True)
    
    def client_data_to_dict(self):
        return {
            'client_id': self.client_id,
            'client_name': self.name,
            'client_email': self.client_email,
            'client_phone': self.client_phone,
            'client_address': self.client_address
        }
