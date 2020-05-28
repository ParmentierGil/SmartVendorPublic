from .Database import Database

one_wire_temp_sensor_id = 1

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
        sql = "SELECT Name FROM Product WHERE NumberInVendingMachine = %s"
        params = [number]
        return Database.get_one_row(sql, params)
