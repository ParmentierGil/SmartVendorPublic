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
    def set_status(online):
        sql = "UPDATE VendingMachine SET Online = %s WHERE VendingMachineId = 1"
        params = [online]
        Database.execute_sql(sql, params)

    @staticmethod
    def get_status():
        sql = "SELECT Online FROM VendingMachine WHERE VendingMachineId = 1"
        return Database.get_one_row(sql)
        

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
    def get_products_in_machine():
        sql = "SELECT * FROM Product WHERE NumberInVendingMachine != 0"
        products = Database.get_rows(sql)
        print(products)      
        return products

    @staticmethod
    def buy_product(product):
        sql2 = "UPDATE vendingmachine.Order SET ProductId = %s, Credit = Credit - %s WHERE VendingMachineId = 1 AND MomentOfPurchase IS NULL"
        params2 = [product['ProductId'], product['Price']]
        Database.execute_sql(sql2, params2)  

    @staticmethod
    def insert_credit(amount):
        sql = "SELECT OrderId FROM vendingmachine.Order WHERE VendingMachineId = 1 AND MomentOfPurchase IS NULL"
        active_order_id = Database.get_one_row(sql)['OrderId']
        sql2 = "INSERT INTO SensorHistory (VendingMachineId, SensorId, Action, ActionTime, MeasuredValue) VALUES (1, %s, %s, NOW(), %s)"
        params = [coin_acceptor_sensor_id, "geld_in", amount]
        Database.execute_sql(sql2, params)
        sql3 = "UPDATE vendingmachine.Order SET Credit = Credit + %s WHERE OrderId = %s"
        params2 = [amount, active_order_id]
        return Database.execute_sql(sql3, params2)
    
    @staticmethod
    def get_total_credit():
        sql = "SELECT Credit FROM vendingmachine.Order WHERE VendingMachineId = 1 AND MomentOfPurchase IS NULL"
        return Database.get_one_row(sql)

    @staticmethod
    def get_total_money():
        sql = "SELECT SUM(MeasuredValue) as total FROM SensorHistory WHERE Action = 'geld_in'"
        return Database.get_one_row(sql)

    @staticmethod
    def get_last_order():
        sql = "SELECT * FROM vendingmachine.Order WHERE VendingMachineId = 1 ORDER BY MomentOfPurchase DESC"
        return Database.get_one_row(sql)

    @staticmethod
    def insert_weight(weight):
        sql = "INSERT INTO SensorHistory (VendingMachineId, SensorId, Action, ActionTime, MeasuredValue) VALUES (1, %s, %s, NOW(), %s)"
        params = [load_cell_sensor_id, "meting", weight]
        return Database.execute_sql(sql, params)

    @staticmethod
    def get_all_products():
        sql = "SELECT * FROM Product WHERE Active = 1 ORDER BY NumberInVendingMachine DESC"
        return Database.get_rows(sql)

    @staticmethod
    def delete_product(id):
        sql = "UPDATE Product SET Active = 0 WHERE ProductId = %s"
        params = [id]
        return Database.execute_sql(sql, params)

    @staticmethod
    def confirm_order(productid):
        sql = "UPDATE vendingmachine.Order SET MomentOfPurchase = NOW(), ProductHasFallen = 1 WHERE MomentOfPurchase IS NULL"
        Database.execute_sql(sql)
        sql2 = "INSERT INTO vendingmachine.Order (VendingMachineId) VALUES (1)"
        Database.execute_sql(sql2)        
        sql3 = "UPDATE Product SET SoldCount = SoldCount + 1 WHERE ProductId = %s"
        param = [productid]
        Database.execute_sql(sql3, param)

    @staticmethod
    def update_product(product):
        sql = "UPDATE Product SET Name = %s, Price = %s, StockCount = %s, NumberInVendingMachine = %s WHERE ProductId = %s"
        # if product['NumberInVendingMachine'] == None:
        #     product['NumberInVendingMachine'] = 'null'
        params = [product['Name'], product['Price'], product['StockCount'], product['NumberInVendingMachine'], product['ProductId']]
        return Database.execute_sql(sql, params)