import 'package:flutter_app/module/home_banner_entity.dart';
import 'package:flutter_app/module/home_data_entity.dart';
import 'package:flutter_app/module/mine_integral_entity.dart';
import 'package:flutter_app/module/mine_integral_rank_entity.dart';
import 'package:flutter_app/module/user_module_entity.dart';
import 'package:flutter_app/module/video_entity.dart';
import 'package:flutter_app/module/welfare_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "HomeBannerEntity") {
      return HomeBannerEntity.fromJson(json) as T;
    } else if (T.toString() == "HomeDataEntity") {
      return HomeDataEntity.fromJson(json) as T;
    } else if (T.toString() == "MineIntegralEntity") {
      return MineIntegralEntity.fromJson(json) as T;
    } else if (T.toString() == "MineIntegralRankEntity") {
      return MineIntegralRankEntity.fromJson(json) as T;
    } else if (T.toString() == "UserModuleEntity") {
      return UserModuleEntity.fromJson(json) as T;
    } else if (T.toString() == "VideoEntity") {
      return VideoEntity.fromJson(json) as T;
    } else if (T.toString() == "WelfareEntity") {
      return WelfareEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}