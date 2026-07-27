import 'package:get/get.dart';

import 'en_us.dart';
import 'km_kh.dart';
import 'zh_cn.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'km_KH': kmKH,
    'zh_CN': zhCN,
  };
}