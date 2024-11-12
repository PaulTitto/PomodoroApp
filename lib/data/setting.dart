import 'package:floor/floor.dart';


@entity
class Setting{
  @primaryKey
  final int id;
  final String name;
  final String value;

  Setting(this.id, this.name,this.value);
}