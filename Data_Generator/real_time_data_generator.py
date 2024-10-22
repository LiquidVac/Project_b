import project_classes as clas
import project_gen_functions as fun


max_logins_per_client = 10
max_activities_per_login = 10
sleep_time = 60

while True:
    client_id = fun.random.randint(1, 1000)
    client = clas.Client(client_id)
    for _ in range(fun.random.randint(1, max_logins_per_client)):
        login = clas.Login(client_id)
        client.add_login(login)
        for _ in range(fun.random.randint(1, max_activities_per_login)):
            activity = clas.Activity(login)
            client.add_activity(activity)
            if activity.activity_type in ['transfer_funds', 'pay_bill']:
                transaction = clas.Transaction(activity)
                payment = clas.Payment(transaction)
                client.add_transaction(transaction)
                client.add_payment(payment)
    timestamp = fun.datetime.now().strftime("%Y%m%d_%H%M%S")
    client.generate_anomalous_data()
    data_logins = []
    for _ in client.logins:
        data_logins.append(_.login_data_to_dict())
    data_df = fun.pd.DataFrame(data_logins)
    data_df.to_csv(f'client_logins_{timestamp}.csv', index=False)

    data_activities = []
    for _ in client.activities:
        data_activities.append(_.activity_data_to_dict())
    data_df = fun.pd.DataFrame(data_activities)
    data_df.to_csv(f'client_activities_{timestamp}.csv', index=False)

    data_transactions = []
    for _ in client.transactions:
        data_transactions.append(_.transaction_data_to_dict())
    data_df = fun.pd.DataFrame(data_transactions)
    data_df.to_csv(f'client_transactions_{timestamp}.csv', index=False)

    data_payments = []
    for _ in client.payments:
        data_payments.append(_.payment_data_to_dict())
    data_df = fun.pd.DataFrame(data_payments)
    data_df.to_csv(f'client_payments_{timestamp}.csv', index=False)



    
    

    break



for _ in client.payments:
    print(_.payment_data_to_dict())
for _ in client.transactions:
    print(_.transaction_data_to_dict())
