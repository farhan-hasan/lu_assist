enum InitialDataType { call, message }

class InitialDataModel {
  InitialDataType? type;
  dynamic data;

  InitialDataModel({this.type, this.data});
}
