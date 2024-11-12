import 'package:floor/floor.dart';
import 'package:podomoro_app/data/setting.dart';

@dao
abstract class SettingDao{
  
  @Query('INSERT Into Setting (name, value) VALUES (:name, :value)')
  Stream<Setting?> insertSettingPomodoro(String name, String value);
  
  @Query('UPDATE Setting SET value = :value WHERE name = :name')
  Stream<Setting?> findSettingById(String name, String value);

  @insert
  Future<void> insertSetting(Setting setting);
}