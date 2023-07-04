import 'package:kid_management/src/models/address_history.dart';

class LocationHistory{
  int id;
  String date;
  List<AddressHistory> addressHistories;

  LocationHistory({this.id, this.date, this.addressHistories});
}