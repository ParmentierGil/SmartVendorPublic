from .Database import Database

one_wire_temp_sensor_id = 1
coin_acceptor_sensor_id = 2
load_cell_sensor_id = 3

class DataRepository:
    @staticmethod
    def json_or_formdata(request):
        if request.content_type == 'application/json':
            gegevens = request.get_json()
        else:
            gegevens = request.form.to_dict()
        return gegevens

    @staticmethod
    def update_temperature(temp):
        sql = "INSERT INTO SensorHistory (VendingMachineId, SensorId, Action, ActionTime, MeasuredValue) VALUES (1, %s, %s, NOW(), %s)"
        params = [one_wire_temp_sensor_id, "meting", temp]
        SH_id =  Database.execute_sql(sql, params)
        return SH_id

    @staticmethod
    def get_product_by_number(number):
        sql = "SELECT * FROM Product WHERE NumberInVendingMachine = %s"
        params = [number]
        product = Database.get_one_row(sql, params)
        print(product)      
        return product

    @staticmethod
    def buy_product(product):
        sql2 = "UPDATE vendingmachine.Order SET ProductId = %s, Credit = Credit - %s WHERE VendingMachineId = 1 AND MomentOfPurchase IS NULL"
        params2 = [product['ProductId'], product['Price']]
        Database.execute_sql(sql2, params2)  

    @staticmethod
    def insert_credit(amount):
        sql = "SELECT OrderId FROM vendingmachine.Order WHERE VendingMachineId = 1 AND MomentOfPurchase IS NULL"
        active_order_id = Database.get_one_row(sql)['OrderId']
        sql2 = "UPDATE vendingmachine.Order SET Credit = Credit + %s WHERE OrderId = %s"
        params = [amount, active_order_id]
        return Database.execute_sql(sql2, params)
    
    @staticmethod
    def get_total_credit():
        sql = "SELECT Credit FROM vendingmachine.Order WHERE VendingMachineId = 1 AND MomentOfPurchase IS NULL"
        return Database.get_one_row(sql)

    @staticmethod
    def insert_weight(weight):
        sql = "INSERT INTO SensorHistory (VendingMachineId, SensorId, Action, ActionTime, MeasuredValue) VALUES (1, %s, %s, NOW(), %s)"
        params = [load_cell_sensor_id, "meting", weight]
        return Database.execute_sql(sql, params)