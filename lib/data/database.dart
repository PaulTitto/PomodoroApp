import 'dart:async';

import 'package:floor/floor.dart';
import 'package:podomoro_app/data/setting.dart';
import 'package:podomoro_app/data/setting_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [Setting])
abstract class AppDatabase extends FloorDatabase{
  SettingDao get settingDao;

}