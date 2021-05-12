import Demo_pb2

sensors_record = Demo_pb2.txRoadSensorsRecord()
roadsensors = Demo_pb2.txRoadSensors()
roadsensors.start_timestamp = 930
roadsensors.end_timestamp = 1000

sensor_1=roadsensors.sensor.add()
sensor_1.flow=2222
sensor_1=roadsensors.sensor.add()
sensor_1.flow=2224

sensors_record.sensors[1].CopyFrom(roadsensors) #实例roadsensors作为值
sensors_record.sensors[2].CopyFrom(roadsensors)
print(sensors_record)




# #序列化
# serializeToString = sensors_record.SerializeToString()
# print(serializeToString,type(serializeToString))


# # 反序列化
# sensors_record.ParseFromString(serializeToString)

# for key in sensors_record.sensors:
#     print(key,sensors_record.sensors[key])
