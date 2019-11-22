import 'package:flutter_app/module/home_banner_entity.dart';
import 'package:flutter_app/module/user_module_entity.dart';

class EntityFactory {
  static T generateOBJ<T>(json) {
    if (1 == 0) {
      return null;
    } else if (T.toString() == "HomeBannerEntity") {
      return HomeBannerEntity.fromJson(json) as T;
    } else if (T.toString() == "UserModuleEntity") {
      return UserModuleEntity.fromJson(json) as T;
    } else {
      return null;
    }
  }
}