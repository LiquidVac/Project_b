import time
import project_classes as clas
import project_gen_functions as fun

max_clients_per_iteration = 10
max_logins_per_client = 10
max_activities_per_login = 20

max_normal_logins_per_client = 1
max_normal_activities_per_login = 2
sleep_time = 60


while True:
    clients_per_iteration = fun.random.randint(0, max_clients_per_iteration)
    data_logins = []
    data_activities = []
    data_transactions = []
    data_payments = []

    for _ in range(clients_per_iteration):
        client_id = fun.random.randint(1, 10000)
        client = clas.Client(client_id)
        logins_per_iteration = fun.probability_value(max_normal_logins_per_client, max_logins_per_client, 0.9)
        for _ in range(fun.random.randint(1, logins_per_iteration)):
            activities_per_login = fun.probability_value(max_normal_activities_per_login, max_activities_per_login, 0.9)
            client.make_login_and_inheritors(activities_per_login)
        
        client.generate_anomalous_amount()
        
        for _ in client.logins:
            data_logins.append(_.login_data_to_dict())

        for _ in client.activities:
            data_activities.append(_.activity_data_to_dict())

        for _ in client.transactions:
            data_transactions.append(_.transaction_data_to_dict())
        
        for _ in client.payments:
            data_payments.append(_.payment_data_to_dict())

    timestamp = fun.datetime.now().strftime("%Y%m%d_%H%M%S")

    folder_name = fun.create_folder_if_not_exists('real_time_data')

    # dataframe for clients logins
    data_df = fun.pd.DataFrame(data_logins)
    data_df.to_csv(f'{folder_name}/clients_logins_{timestamp}.csv', index=False)

    # dataframe for clients activities
    data_df = fun.pd.DataFrame(data_activities)
    data_df.to_csv(f'{folder_name}/clients_activities_{timestamp}.csv', index=False)

    # dataframe for clients transactions
    data_df = fun.pd.DataFrame(data_transactions)
    data_df.to_csv(f'{folder_name}/clients_transactions_{timestamp}.csv', index=False)

    # dataframe for clients payments
    data_df = fun.pd.DataFrame(data_payments)
    data_df.to_csv(f'{folder_name}/clients_payments_{timestamp}.csv', index=False)

    time.sleep(sleep_time)
    # break
