from .Database import Database


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
        sql = "INSERT INTO Temperature (TemperatureValue, TimeOfTemp) VALUES (%s, NOW())"
        params = [temp]
        temp_id =  Database.execute_sql(sql, params)
        sql2 = "UPDATE VendingMachine SET LatestTemperature = %s"
        params2 = [temp_id]
        return Database.execute_sql(sql2, params2)

    @staticmethod
    def get_product_by_number(number):
        sql = "SELECT Name FROM Product WHERE NumberInVendingMachine = %s"
        params = [number]
        return Database.get_one_row(sql, params)
